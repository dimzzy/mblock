//
//  MotionSignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "MotionSignalService.h"
#import <CoreMotion/CoreMotion.h>

static const int32_t kMotionSignalType = 0x10;

@implementation MotionSignalService {
@private
	CMMotionManager *_motionManager;
}

- (NSString *)info {
	return @"Measurements of the attitude and acceleration of a device.";
}

- (id)init {
	if ((self = [super init])) {
		_frequency = 2.0;
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
		 int32_t s[6];
		 CMAttitude *t = motion.attitude;
		 s[0] = (int32_t)(t.roll * kSignalAmplification);
		 s[1] = (int32_t)(t.pitch * kSignalAmplification);
		 s[2] = (int32_t)(t.yaw * kSignalAmplification);
		 CMAcceleration a = motion.userAcceleration;
		 s[3] = (int32_t)(a.x * kSignalAmplification);
		 s[4] = (int32_t)(a.y * kSignalAmplification);
		 s[5] = (int32_t)(a.z * kSignalAmplification);
		 __block NSData *data = [NSData dataWithBytes:&s[0] length:(sizeof(int32_t) * sizeof(s))];
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

- (BOOL)acceptsSignalType:(int32_t)signalType {
	return signalType == kMotionSignalType;
}

- (void)logData:(NSData *)data {
	const int32_t *s = (int32_t *)[data bytes];
	const double roll = (double)s[0] / kSignalAmplification;
	const double pitch = (double)s[1] / kSignalAmplification;
	const double yaw = (double)s[2] / kSignalAmplification;
	const double x = (double)s[3] / kSignalAmplification;
	const double y = (double)s[4] / kSignalAmplification;
	const double z = (double)s[5] / kSignalAmplification;
	NSLog(@"Motion: %f, %f, %f, %f, %f, %f", roll, pitch, yaw, x, y, z);
}

@end
