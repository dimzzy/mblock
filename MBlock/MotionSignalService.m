//
//  MotionSignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "MotionSignalService.h"
#import <CoreMotion/CoreMotion.h>

static const uint8_t kMotionSignalType = 0x0a;

@implementation MotionSignalService {
@private
	CMMotionManager *_motionManager;
}

- (NSString *)info {
	return @"The acceleration that the user is giving to the device.";
}

- (id)init {
	if ((self = [super init])) {
		_frequency = 10.0;
	}
	return self;
}

- (void)start {
	if (self.running || self.frequency <= 0) {
		return;
	}
	__weak MotionSignalService *weakSelf = self;
	_motionManager = [[CMMotionManager alloc] init];
	_motionManager.deviceMotionUpdateInterval = 1.0 / self.frequency;
	[_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
										withHandler:^(CMDeviceMotion *motion, NSError *error)
	 {
		 MotionSignalService *strongSelf = weakSelf;
		 if (!strongSelf) {
			 return;
		 }
		 CMAcceleration a = motion.userAcceleration;
		 int32_t s[3];
		 s[0] = (int32_t)(a.x * kSignalAmplification);
		 s[1] = (int32_t)(a.y * kSignalAmplification);
		 s[2] = (int32_t)(a.z * kSignalAmplification);
		 __block NSData *data = [NSData dataWithBytes:&s[0] length:(sizeof(int32_t) * 3)];
		 dispatch_async(dispatch_get_main_queue(), ^{
			 [strongSelf sendSignal:kMotionSignalType withData:data];
		 });
	 }];
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	[_motionManager stopDeviceMotionUpdates];
	_motionManager = nil;
	[super stop];
}

- (BOOL)acceptsSignalType:(int8_t)signalType {
	return signalType == kMotionSignalType;
}

- (void)logData:(NSData *)data {
	const int32_t *s = (int32_t *)[data bytes];
	const double x = (double)s[0] / kSignalAmplification;
	const double y = (double)s[1] / kSignalAmplification;
	const double z = (double)s[2] / kSignalAmplification;
	NSLog(@"Motion: %f, %f, %f", x, y, z);
}

@end
