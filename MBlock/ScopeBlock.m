//
//  ScopeBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "ScopeBlock.h"
#import "ScopeViewController.h"
#import "AppDelegate.h"
#import "SignalCapture.h"

@implementation ScopeBlock {
@private
	SignalCapture *_capture;
}

- (NSString *)name {
	return @"Scope";
}

- (NSString *)info {
	return @"Shows signal values over time.";
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
	_capture = [[SignalCapture alloc] init];
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	_capture = nil;
	[super stop];
}

- (void)receiveSignal:(Signal *)signal {
	[_capture addSignal:signal];
	[super receiveSignal:signal];
}

- (void)performAction {
	ScopeViewController *controller = [[ScopeViewController alloc] init];
	controller.scopeView.capture = _capture;
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appd.navigationController pushViewController:controller animated:YES];
}

@end
