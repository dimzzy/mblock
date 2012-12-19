//
//  UDPClientCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/17/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kUDPClientCellHeight = 127;

@interface UDPClientCell : UITableViewCell

@property IBOutlet UITextField *IPAddressView;
@property IBOutlet UITextField *portView;
@property IBOutlet UISwitch *connectedView;

@end
