//
//  SineBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/17/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SineBlock.h"

@implementation SineBlock {
@private
	NSTimer *_sendTimer;
	CFAbsoluteTime _time0;
}

- (NSString *)info {
	return @"Sine wave generator.";
}

- (double)minFrequency {
	return 1.0;
}

- (double)maxFrequency {
	return 100.0;
}

- (void)dealloc {
	[self removeObserverForProperty:@"frequency"];
}

- (id)init {
	if ((self = [super init])) {
		_frequency = 10.0;
		[self addObserverForProperty:@"frequency"];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_frequency = [coder decodeDoubleForKey:@"frequency"];
		[self addObserverForProperty:@"frequency"];
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
	_time0 = CFAbsoluteTimeGetCurrent();
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
	[super stop];
}

- (void)sendTimedSignal:(NSTimer *)timer {
	const CFTimeInterval t = CFAbsoluteTimeGetCurrent() - _time0;
	const double value = sin(t * 2 * M_PI);
	[self sendSignal:[[Signal alloc] initWithType:kSineSignalType
										   values:@[[NSNumber numberWithDouble:value]]
										   labels:@[@"sin"]]];
}

@end
