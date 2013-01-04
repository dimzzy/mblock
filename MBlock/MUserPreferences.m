//
//  MUserPreferences.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/19/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "MUserPreferences.h"

@implementation MUserPreferences

+ (void)initialize {
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  @"127.0.0.1",                       @"ip",
	  [NSNumber numberWithInteger:25000], @"port",
	  [NSNumber numberWithDouble:10.0],   @"motion_frequency",
	  [NSNumber numberWithBool:NO],       @"location_continuous",
	  [NSNumber numberWithDouble:10.0],   @"location_frequency",
	  [NSNumber numberWithBool:NO],       @"proximity_continuous",
	  [NSNumber numberWithDouble:10.0],   @"proximity_frequency",
	  nil]];
}

+ (MUserPreferences *)instance {
	static MUserPreferences *instance;
	if (!instance) {
		instance = [[MUserPreferences alloc] init];
	}
	return instance;
}

- (NSString *)IPAddress {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
}

- (void)setIPAddress:(NSString *)IPAddress {
	[[NSUserDefaults standardUserDefaults] setObject:IPAddress forKey:@"ip"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)port {
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"port"];
}

- (void)setPort:(int)port {
	[[NSUserDefaults standardUserDefaults] setInteger:port forKey:@"port"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)motionFrequency {
	return [[NSUserDefaults standardUserDefaults] doubleForKey:@"motion_frequency"];
}

- (void)setMotionFrequency:(double)frequency {
	[[NSUserDefaults standardUserDefaults] setDouble:frequency forKey:@"motion_frequency"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)locationContinuous {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"location_continuous"];
}

- (void)setLocationContinuous:(BOOL)continuous {
	[[NSUserDefaults standardUserDefaults] setBool:continuous forKey:@"location_continuous"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)locationFrequency {
	return [[NSUserDefaults standardUserDefaults] doubleForKey:@"location_frequency"];
}

- (void)setLocationFrequency:(double)frequency {
	[[NSUserDefaults standardUserDefaults] setDouble:frequency forKey:@"location_frequency"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)proximityContinuous {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"proximity_continuous"];
}

- (void)setProximityContinuous:(BOOL)continuous {
	[[NSUserDefaults standardUserDefaults] setBool:continuous forKey:@"proximity_continuous"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)proximityFrequency {
	return [[NSUserDefaults standardUserDefaults] doubleForKey:@"proximity_frequency"];
}

- (void)setProximityFrequency:(double)frequency {
	[[NSUserDefaults standardUserDefaults] setDouble:frequency forKey:@"proximity_frequency"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
