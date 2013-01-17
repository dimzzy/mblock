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
	NSUInteger _samplesCount;
}

- (NSString *)info {
	return @"Resends last received signal at the specified frequency.";
}

- (double)minFrequency {
	return 1.0;
}

- (double)maxFrequency {
	return 100.0;
}

- (void)dealloc {
	[self removeObserverForProperty:@"frequency"];
	[self removeObserverForProperty:@"average"];
}

- (id)init {
	if ((self = [super init])) {
		_frequency = 10.0;
		_average = NO;
		[self addObserverForProperty:@"frequency"];
		[self addObserverForProperty:@"average"];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_frequency = [coder decodeDoubleForKey:@"frequency"];
		_average = [coder decodeBoolForKey:@"average"];
		[self addObserverForProperty:@"frequency"];
		[self addObserverForProperty:@"average"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeDouble:_frequency forKey:@"frequency"];
	[coder encodeBool:_average forKey:@"average"];
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
	if (self.average) {
		if (_samplesCount == 0 || !_signal || _signal.type != signal.type || _signal.width != signal.width) {
			_signal = signal;
		} else {
			const double ourWeight = (double)_samplesCount / (double)(_samplesCount + 1);
			const double newWeight = 1.0 / (double)(_samplesCount + 1);
			NSMutableArray *values = [NSMutableArray arrayWithCapacity:_signal.width];
			for (int i = 0; i < _signal.width; i++) {
				const double value = [_signal valueAtIndex:i] * ourWeight + [signal valueAtIndex:i] * newWeight;
				[values addObject:[NSNumber numberWithDouble:value]];
			}
			_signal = [[Signal alloc] initWithType:signal.type values:values labels:signal.labels];
		}
	} else {
		_signal = signal;
	}
}

- (void)sendTimedSignal:(NSTimer *)timer {
	if (_signal) {
		[self sendSignal:_signal];
	}
	_samplesCount = 0;
}

@end
