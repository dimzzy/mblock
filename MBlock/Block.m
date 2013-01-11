//
//  Block.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@implementation Block

- (void)dealloc {
	[self stop];
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		_signalReceiver = [coder decodeObjectForKey:@"signalReceiver"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	if ([_signalReceiver conformsToProtocol:@protocol(NSCoding)]) {
		[coder encodeObject:_signalReceiver forKey:@"signalReceiver"];
	}
}

- (void)receiveSignal:(Signal *)signal {
	[self sendSignal:signal];
}

- (void)sendSignal:(Signal *)signal {
	[self.signalReceiver receiveSignal:signal];
}

- (void)start {
	_running = YES;
}

- (void)stop {
	_running = NO;
}

@end
