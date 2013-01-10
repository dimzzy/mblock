//
//  TouchInputBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "TouchInputBlock.h"
#import "TouchInputViewController.h"
#import "AppDelegate.h"

@implementation TouchInputBlock {
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
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:([_touchInfos count] * 3)];
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:([_touchInfos count] * 3)];
	[_touchInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		TouchInfo *touchInfo = obj;
		[values addObject:[NSNumber numberWithDouble:touchInfo.identifier]];
		[values addObject:[NSNumber numberWithDouble:touchInfo.x]];
		[values addObject:[NSNumber numberWithDouble:touchInfo.y]];
		[labels addObject:[NSString stringWithFormat:@"id%d", idx]];
		[labels addObject:[NSString stringWithFormat:@"x%d", idx]];
		[labels addObject:[NSString stringWithFormat:@"y%d", idx]];
	}];
	[self sendSignal:[[Signal alloc] initWithType:kTouchInputSignalType values:values labels:labels]];
}

- (NSString *)actionTitle {
	return @"Touchpad";
}

- (void)performAction {
	TouchInputViewController *controller = [[TouchInputViewController alloc] init];
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appd.navigationController pushViewController:controller animated:YES];
}

@end
