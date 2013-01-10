//
//  Block.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@implementation Block {
@private
	NSMutableSet *_signalReceivers;
}

- (void)dealloc {
	[self stop];
}

- (NSMutableSet *)signalReceivers {
	if (!_signalReceivers) {
		_signalReceivers = [[NSMutableSet alloc] init];
	}
	return _signalReceivers;
}

- (void)receiveSignal:(Signal *)signal {
	[self sendSignal:signal];
}

- (void)sendSignal:(Signal *)signal {
	for (id<SignalReceiver> receiver in self.signalReceivers) {
		[receiver receiveSignal:signal];
	}
}

- (void)start {
	_running = YES;
}

- (void)stop {
	_running = NO;
}

@end
