//
//  BlockCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "BlockCell.h"

@implementation BlockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
