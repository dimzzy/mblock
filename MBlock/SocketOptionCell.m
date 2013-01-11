//
//  SocketOptionCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/11/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SocketOptionCell.h"

@implementation SocketOptionCell

- (void)textDidChange:(UITextField *)textField {
	self.updater(self.IPAddressView.text, [self.portView.text intValue]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
