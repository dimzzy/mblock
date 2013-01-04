//
//  ContinuousOptionCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "ContinuousOptionCell.h"

@implementation ContinuousOptionCell {
@private
	BOOL _continuous;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	_continuous = self.continuousView.on;
}

- (BOOL)continuous {
	return _continuous;
}

- (void)setContinuous:(BOOL)continuous {
	_continuous = continuous;
	self.continuousView.on = continuous;
}

- (IBAction)continuousViewDidChange:(UISwitch *)source {
	_continuous = self.continuousView.on;
	self.updater(self.continuous);
}

@end
