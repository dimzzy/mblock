//
//  SocketOptionCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/11/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kSocketOptionCellHeight = 50;
static const CGFloat kSocketOptionFullCellHeight = 90;

typedef void (^SocketOptionUpdater)(NSString *IPAddress, int port);

@interface SocketOptionCell : UITableViewCell <UITextFieldDelegate>

@property IBOutlet UITextField *IPAddressView;
@property IBOutlet UITextField *portView;
@property(strong) SocketOptionUpdater updater;

- (IBAction)textDidChange:(UITextField *)textField;

@end
