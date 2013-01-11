//
//  SequencerBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SequencerBlock.h"

@implementation SequencerBlock {
@private
	NSTimer *_sendTimer;
	Signal *_signal;
}

- (NSString *)info {
	return @"Resends last received signal at the specified frequency.";
}

- (id)init {
	if ((self = [super init])) {
		_frequency = 10.0;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_frequency = [coder decodeDoubleForKey:@"frequency"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeDouble:_frequency forKey:@"frequency"];
	[super encodeWithCoder:coder];
}

- (void)start {
	if (self.running) {
		return;
	}
	if (self.frequency > 0) {
		const NSTimeInterval interval = 1.0 / self.frequency;
		_sendTimer = [NSTimer scheduledTimerWithTimeInterval:interval
													  target:self
													selector:@selector(sendTimedSignal:)
													userInfo:nil
													 repeats:YES];
	}
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	if (_sendTimer) {
		[_sendTimer invalidate];
		_sendTimer = nil;
	}
	_signal = nil;
	[super stop];
}

- (void)receiveSignal:(Signal *)signal {
	_signal = signal;
}

- (void)sendTimedSignal:(NSTimer *)timer {
	if (_signal) {
		[self sendSignal:_signal];
	}
}

@end
