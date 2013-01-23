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

@implementation TouchInputBlock

- (NSString *)name {
	return @"Touches";
}

- (NSString *)info {
	return @"Fingers coordinates on the screen.";
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
}

- (void)start {
	if (self.running) {
		return;
	}
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
	NSArray *touchInfos = view.touchInfos;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:([touchInfos count] * 3)];
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:([touchInfos count] * 3)];
	[touchInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
