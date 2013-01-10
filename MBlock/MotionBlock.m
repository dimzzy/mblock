//
//  MotionBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "MotionBlock.h"
#import <CoreMotion/CoreMotion.h>

@implementation MotionBlock {
@private
	CMMotionManager *_motionManager;
}

- (BOOL)unique {
	return YES;
}

- (NSString *)info {
	return @"Measurements of the attitude and acceleration of a device.";
}

+ (NSArray *)labels {
	static NSArray *labels;
	if (!labels) {
		labels = [NSArray arrayWithObjects:@"roll", @"pitch", @"yaw", @"x", @"y", @"z", nil];
	}
	return labels;
}

- (void)start {
	if (self.running || self.frequency <= 0) {
		return;
	}
	__weak MotionBlock *weakSelf = self;
	_motionManager = [[CMMotionManager alloc] init];
	_motionManager.deviceMotionUpdateInterval = 1.0 / self.frequency;
	[_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
										withHandler:^(CMDeviceMotion *motion, NSError *error)
	 {
		 MotionBlock *strongSelf = weakSelf;
		 if (!strongSelf) {
			 return;
		 }
		 NSMutableArray *values = [NSMutableArray arrayWithCapacity:6];
		 CMAttitude *t = motion.attitude;
		 [values addObject:[NSNumber numberWithDouble:t.roll]];
		 [values addObject:[NSNumber numberWithDouble:t.pitch]];
		 [values addObject:[NSNumber numberWithDouble:t.yaw]];
		 CMAcceleration a = motion.userAcceleration;
		 [values addObject:[NSNumber numberWithDouble:a.x]];
		 [values addObject:[NSNumber numberWithDouble:a.y]];
		 [values addObject:[NSNumber numberWithDouble:a.z]];
		 dispatch_async(dispatch_get_main_queue(), ^{
			 [strongSelf sendSignal:[[Signal alloc] initWithType:kMotionSignalType
														  values:values
														  labels:[MotionBlock labels]]];
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

@end
