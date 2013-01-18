//
//  AverageOptionCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/17/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kAverageOptionCellHeight = 50;

typedef void (^AverageOptionUpdater)(BOOL average);

@interface AverageOptionCell : UITableViewCell

@property IBOutlet UISwitch *averageView;
@property(strong) AverageOptionUpdater updater;

- (IBAction)averageViewDidChange:(UISwitch *)source;

@end
