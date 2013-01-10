//
//  EventfulBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "EventfulBlock.h"

@implementation EventfulBlock {
	NSTimer *_sendTimer;
}

- (void)start {
	if (self.running) {
		return;
	}
	if (self.continuous && self.frequency > 0) {
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
	[super stop];
}

- (void)sendTimedSignal:(NSTimer *)timer {
}

@end
