//
//  ScopeViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "ScopeViewController.h"

@implementation ScopeViewController

- (void)loadView {
	ScopeView *scopeView = [[ScopeView alloc] init];
	scopeView.multipleTouchEnabled = YES;
	scopeView.backgroundColor = [UIColor blackColor];
	self.view = scopeView;
}

- (ScopeView *)scopeView {
	return (ScopeView *)self.view;
}

@end
