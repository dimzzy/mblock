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
	  @"127.0.0.1", @"ip",
	  [NSNumber numberWithInteger:25000], @"port",
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

@end
