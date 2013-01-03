//
//  LocationSignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/17/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "LocationSignalService.h"

static const uint8_t kLocationSignalType = 0x20;

@implementation LocationSignalService {
@private
	CLLocationManager *_locationManager;
}

- (NSString *)info {
	return @"Geographical coordinates and altitude of the device’s location.";
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	int32_t s[6];
	s[0] = (int32_t)(newLocation.coordinate.latitude * kSignalAmplification);
	s[1] = (int32_t)(newLocation.coordinate.longitude * kSignalAmplification);
	s[2] = (int32_t)(newLocation.altitude * kSignalAmplification);
	s[3] = 0;
	s[4] = 0;
	s[5] = 0;
	NSData *data = [NSData dataWithBytes:&s[0] length:sizeof(s)];
	[self sendSignal:kLocationSignalType withData:data];
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

- (BOOL)acceptsSignalType:(int32_t)signalType {
	return signalType == kLocationSignalType;
}

- (void)logData:(NSData *)data {
	const int32_t *s = (int32_t *)[data bytes];
	const double lat = (double)s[0] / kSignalAmplification;
	const double lng = (double)s[1] / kSignalAmplification;
	const double alt = (double)s[2] / kSignalAmplification;
	NSLog(@"Location: %f, %f, %f", lat, lng, alt);
}

@end
