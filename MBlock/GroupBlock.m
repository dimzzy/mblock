//
//  GroupBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "GroupBlock.h"

@interface GroupSink : NSObject <SignalReceiver>

@property NSSet *signalReceivers; // {:SignalReceiver}

@end


@implementation GroupSink

- (void)receiveSignal:(Signal *)signal {
	for (id<SignalReceiver> receiver in self.signalReceivers) {
		[receiver receiveSignal:signal];
	}
}

@end


@interface GroupBlock ()

@property(readonly) id<SignalReceiver> groupSink;

@end

@implementation GroupBlock {
@private
	GroupSink *_groupSink;
	NSMutableArray *_blocks;
}

- (NSString *)info {
	return @"Groups several blocks in chain.";
}

- (id<SignalReceiver>)groupSink {
	if (!_groupSink) {
		_groupSink = [[GroupSink alloc] init];
		_groupSink.signalReceivers = self.signalReceivers;
	}
	return _groupSink;
}

- (NSArray *)blocks {
	return _blocks;
}

- (void)addBlock:(Block *)block {
	Block *lastBlock = [_blocks lastObject];
	[lastBlock.signalReceivers removeObject:self.groupSink];
	[lastBlock.signalReceivers addObject:block];
	[block.signalReceivers addObject:self.groupSink];
	[_blocks addObject:block];
}

- (void)removeBlockAtIndex:(NSUInteger)index {
	Block *block = [_blocks objectAtIndex:index];
	Block *prevBlock = nil;
	if (index > 0) {
		prevBlock = [_blocks objectAtIndex:(index - 1)];
		[prevBlock.signalReceivers removeObject:block];
	}
	Block *nextBlock = nil;
	if (index < [_blocks count] - 1) {
		nextBlock = [_blocks objectAtIndex:(index + 1)];
		[block.signalReceivers removeObject:nextBlock];
		[prevBlock.signalReceivers addObject:nextBlock];
	} else {
		[block.signalReceivers removeObject:self.groupSink];
		[prevBlock.signalReceivers addObject:self.groupSink];
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
