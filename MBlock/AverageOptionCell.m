//
//  AverageOptionCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/17/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "AverageOptionCell.h"

@implementation AverageOptionCell

- (IBAction)averageViewDidChange:(UISwitch *)source {
	_updater(source.on);
}

@end
