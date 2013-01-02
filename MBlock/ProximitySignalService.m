//
//  ProximitySignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/21/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "ProximitySignalService.h"

static const int32_t kProximitySignalType = 0x30;

@implementation ProximitySignalService

- (NSString *)info {
	return @"Checks if device is close to the user.";
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)start {
	if (self.running) {
		return;
	}
	[UIDevice currentDevice].proximityMonitoringEnabled = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(proximityStateDidChange:)
												 name:UIDeviceProximityStateDidChangeNotification
											   object:nil];
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIDeviceProximityStateDidChangeNotification
												  object:nil];
	[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	[super stop];
}

- (void)proximityStateDidChange:(NSNotification *)notification {
	int32_t s[6];
	s[0] = (int32_t)[UIDevice currentDevice].proximityState;
	s[1] = 0;
	s[2] = 0;
	s[3] = 0;
	s[4] = 0;
	s[5] = 0;
	NSData *data = [NSData dataWithBytes:&s[0] length:(sizeof(int32_t))];
	[self sendSignal:kProximitySignalType withData:data];
}

- (BOOL)acceptsSignalType:(int32_t)signalType {
	return signalType == kProximitySignalType;
}

- (void)logData:(NSData *)data {
	const int32_t *s = (int32_t *)[data bytes];
	const BOOL p = (BOOL)s[0];
	NSLog(@"Proximity: %d", p);
}

@end
