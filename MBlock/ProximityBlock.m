//
//  ProximityBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "ProximityBlock.h"

@implementation ProximityBlock

- (BOOL)unique {
	return YES;
}

- (NSString *)name {
	return @"Proximity";
}

- (NSString *)info {
	return @"Checks if device is close to the user.";
}

- (BlockCategory *)category {
	return [BlockCategory generators];
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
}

+ (NSArray *)labels {
	static NSArray *labels;
	if (!labels) {
		labels = [NSArray arrayWithObjects:@"proximity", nil];
	}
	return labels;
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
	[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIDeviceProximityStateDidChangeNotification
												  object:nil];
	[super stop];
}

- (void)proximityStateDidChange:(NSNotification *)notification {
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:1];
	[values addObject:[NSNumber numberWithDouble:[UIDevice currentDevice].proximityState]];
	[self sendSignal:[[Signal alloc] initWithType:kProximitySignalType
										   values:values
										   labels:[ProximityBlock labels]]];
}

@end
