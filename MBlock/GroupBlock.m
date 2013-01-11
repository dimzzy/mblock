//
//  GroupBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "GroupBlock.h"

@interface GroupSink : NSObject <SignalReceiver>

@property(unsafe_unretained) GroupBlock *host;

@end


@implementation GroupSink

- (void)receiveSignal:(Signal *)signal {
	[self.host.signalReceiver receiveSignal:signal];
}

@end


@interface GroupBlock ()

@property(readonly) id<SignalReceiver> groupSink;
@property(readonly) NSMutableArray *mutableBlocks;

@end

@implementation GroupBlock {
@private
	GroupSink *_groupSink;
	NSMutableArray *_blocks;
}

- (NSString *)info {
	return @"Groups several blocks in chain.";
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		NSArray *blocks = [coder decodeObjectForKey:@"blocks"];
		if ([blocks count] > 0) {
			[self.mutableBlocks addObjectsFromArray:blocks];
//			for (int i = 0; i < [self.mutableBlocks count]; i++) {
//				Block *block = [self.mutableBlocks objectAtIndex:i];
//				if (i < ([self.mutableBlocks count] - 1)) {
//					Block *nextBlock = [self.mutableBlocks objectAtIndex:(i + 1)];
//					block.signalReceiver = nextBlock;
//				} else {
//					block.signalReceiver = self.groupSink;
//				}
//			}
			Block *lastBlock = [self.mutableBlocks lastObject];
			lastBlock.signalReceiver = self.groupSink;
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.mutableBlocks forKey:@"blocks"];
	[super encodeWithCoder:coder];
}

- (id<SignalReceiver>)groupSink {
	if (!_groupSink) {
		_groupSink = [[GroupSink alloc] init];
		_groupSink.host = self;
	}
	return _groupSink;
}

- (NSArray *)blocks {
	return self.mutableBlocks;
}

- (NSMutableArray *)mutableBlocks {
	if (!_blocks) {
		_blocks = [NSMutableArray array];
	}
	return _blocks;
}

- (void)addBlock:(Block *)block {
	Block *lastBlock = [self.mutableBlocks lastObject];
	lastBlock.signalReceiver = block;
	block.signalReceiver = self.groupSink;
	[self.mutableBlocks addObject:block];
}

- (void)insertBlock:(Block *)block atIndex:(NSUInteger)index {
	Block *prevBlock = nil;
	if (index > 0) {
		prevBlock = [self.mutableBlocks objectAtIndex:(index - 1)];
		prevBlock.signalReceiver = block;
	}
	Block *nextBlock = nil;
	if (index < [self.mutableBlocks count]) {
		nextBlock = [self.mutableBlocks objectAtIndex:index];
		block.signalReceiver = nextBlock;
	} else {
		block.signalReceiver = self.groupSink;
	}
	[self.mutableBlocks insertObject:block atIndex:index];
}

- (void)removeBlockAtIndex:(NSUInteger)index {
	Block *block = [self.mutableBlocks objectAtIndex:index];
	block.signalReceiver = nil;
	Block *prevBlock = nil;
	if (index > 0) {
		prevBlock = [self.mutableBlocks objectAtIndex:(index - 1)];
	}
	Block *nextBlock = nil;
	if (index < [self.mutableBlocks count] - 1) {
		nextBlock = [self.mutableBlocks objectAtIndex:(index + 1)];
		prevBlock.signalReceiver = nextBlock;
	} else {
		prevBlock.signalReceiver = self.groupSink;
	}
	[self.mutableBlocks removeObjectAtIndex:index];
}

- (void)moveBlockAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
	if (index == toIndex) {
		return;
	}
	Block *block = [self.mutableBlocks objectAtIndex:index];
	[self removeBlockAtIndex:index];
	if (toIndex < index) {
		[self insertBlock:block atIndex:toIndex];
	} else {
		[self insertBlock:block atIndex:(toIndex - 1)];
	}
}

- (void)sendSignal:(Signal *)signal {
	id<SignalReceiver> receiver = self.groupSink;
	if ([self.blocks count] > 0) {
		receiver = [self.blocks objectAtIndex:0];
	}
	[receiver receiveSignal:signal];
}

- (void)start {
	for (Block *block in self.blocks) {
		[block start];
	}
	[super start];
}

- (void)stop {
	for (Block *block in self.blocks) {
		[block stop];
	}
	[super stop];
}

@end
