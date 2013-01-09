//
//  TouchInputViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/7/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "TouchInputViewController.h"

@interface TouchInputViewController ()

@end

@implementation TouchInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
	TouchInputView *touchInputView = [[TouchInputView alloc] init];
	touchInputView.multipleTouchEnabled = YES;
	touchInputView.backgroundColor = [UIColor blackColor];
	touchInputView.marksColor = [UIColor greenColor];
	touchInputView.touchesColor = [UIColor yellowColor];
	self.view = touchInputView;
}

- (TouchInputView *)touchInputView {
	return (TouchInputView *)self.view;
}

@end
