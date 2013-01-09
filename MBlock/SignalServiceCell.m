//
//  SignalServiceCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/17/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "SignalServiceCell.h"

@implementation SignalServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)runnable {
	return !self.runningView.hidden;
}

- (void)setRunnable:(BOOL)runnable {
	if (self.runnable == runnable) {
		return;
	}
	self.runningView.hidden = !runnable;
	CGRect titleFrame = self.titleView.frame;
	CGRect runFrame = self.runningView.frame;
	if (runnable) {
		titleFrame.size.width = runFrame.origin.x - 10.0;
	} else {
		titleFrame.size.width = runFrame.origin.x + runFrame.size.width - titleFrame.origin.x;
	}
}

@end
