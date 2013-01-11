//
//  BlockCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kBlockCellHeight = 50;
static const CGFloat kBlockCellExtHeight = 100;

@interface BlockCell : UITableViewCell

@property IBOutlet UILabel *infoView;
@property IBOutlet UIButton *actionButton;

@end
