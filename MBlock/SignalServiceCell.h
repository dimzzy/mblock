//
//  SignalServiceCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/17/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kSignalServiceCellHeight = 50;

@interface SignalServiceCell : UITableViewCell

@property IBOutlet UILabel *titleView;
@property IBOutlet UISwitch *runningView;

@end
