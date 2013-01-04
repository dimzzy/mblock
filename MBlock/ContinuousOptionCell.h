//
//  ContinuousOptionCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kContinuousOptionCellHeight = 50;

typedef void (^ContinuousOptionUpdater)(BOOL continuous);

@interface ContinuousOptionCell : UITableViewCell

@property IBOutlet UILabel *titleView;
@property IBOutlet UISwitch *continuousView;
@property(strong) ContinuousOptionUpdater updater;
@property BOOL continuous;

- (IBAction)continuousViewDidChange:(UISwitch *)source;

@end
