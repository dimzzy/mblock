//
//  TouchSignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/7/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "TouchSignalService.h"
#import "TouchInputViewController.h"
#import "AppDelegate.h"

static const int32_t kTouchSignalType = 0x40;

@implementation TouchSignalService {
	NSMutableArray *_touchInfos;
}

- (NSString *)info {
	return @"Reports coordinates of the fingers on the screen.";
}

- (id)init {
	if ((self = [super init])) {
		_touchInfos = [NSMutableArray array];
	}
	return self;
}

- (void)start {
	if (self.running) {
		return;
	}
	[_touchInfos removeAllObjects];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(touchesDidChange:)
												 name:TouchesDidChangeNotification
											   object:nil];
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:TouchesDidChangeNotification
												  object:nil];
	[super stop];
}

- (void)touchesDidChange:(NSNotification *)notification {
	TouchInputView *view = [notification object];
	[_touchInfos removeAllObjects];
	[_touchInfos addObjectsFromArray:view.touchInfos];
	if (!self.continuous) {
		[self sendState];
	}
}

- (void)sendTimedSignal:(NSTimer *)timer {
	[self sendState];
}

- (void)sendState {
	int32_t s[6];
	if ([_touchInfos count] > 0) {
		TouchInfo *touchInfo = [_touchInfos objectAtIndex:0];
		s[0] = touchInfo.identifier;
		s[1] = (int32_t)(touchInfo.x * kSignalAmplification);
		s[2] = (int32_t)(touchInfo.y * kSignalAmplification);
	} else {
		s[0] = 0;
		s[1] = 0;
		s[2] = 0;
	}
	if ([_touchInfos count] > 1) {
		TouchInfo *touchInfo = [_touchInfos objectAtIndex:1];
		s[3] = touchInfo.identifier;
		s[4] = (int32_t)(touchInfo.x * kSignalAmplification);
		s[5] = (int32_t)(touchInfo.y * kSignalAmplification);
	} else {
		s[3] = 0;
		s[4] = 0;
		s[5] = 0;
	}
	NSData *data = [NSData dataWithBytes:&s[0] length:sizeof(s)];
	[self sendSignal:kTouchSignalType withData:data];
}

- (BOOL)acceptsSignalType:(int32_t)signalType {
	return signalType == kTouchSignalType;
}

- (void)logData:(NSData *)data {
	const int32_t *s = (int32_t *)[data bytes];
	const int32_t i1 = s[0];
	const double x1 = (double)s[1] / kSignalAmplification;
	const double y1 = (double)s[2] / kSignalAmplification;
	const int32_t i2 = s[3];
	const double x2 = (double)s[4] / kSignalAmplification;
	const double y2 = (double)s[5] / kSignalAmplification;
	NSLog(@"Touch 1: %d (%g, %g)", i1, x1, y1);
	NSLog(@"Touch 2: %d (%g, %g)", i2, x2, y2);
}

- (NSString *)serviceActionTitle {
	return @"Show Touchpad";
}

- (void)performServiceAction {
	TouchInputViewController *controller = [[TouchInputViewController alloc] init];
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appd.navigationController pushViewController:controller animated:YES];
}

@end
