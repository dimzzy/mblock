//
//  LocationBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "LocationBlock.h"

@implementation LocationBlock {
@private
	CLLocationManager *_locationManager;
}

- (BOOL)unique {
	return YES;
}

- (NSString *)info {
	return @"Geographical coordinates and altitude of the device’s location.";
}

+ (NSArray *)labels {
	static NSArray *labels;
	if (!labels) {
		labels = [NSArray arrayWithObjects:@"lat", @"lng", @"alt", nil];
	}
	return labels;
}

- (void)start {
	if (self.running) {
		return;
	}
	_locationManager = [[CLLocationManager alloc] init];
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	[_locationManager stopUpdatingLocation];
	_locationManager = nil;
	[super stop];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	CLLocation *l = newLocation;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:3];
	[values addObject:[NSNumber numberWithDouble:l.coordinate.latitude]];
	[values addObject:[NSNumber numberWithDouble:l.coordinate.longitude]];
	[values addObject:[NSNumber numberWithDouble:l.altitude]];
	[self sendSignal:[[Signal alloc] initWithType:kLocationSignalType
										   values:values
										   labels:[LocationBlock labels]]];
}

@end
