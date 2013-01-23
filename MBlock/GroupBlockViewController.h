//
//  GroupBlockViewController.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupBlock.h"

@interface GroupBlockViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property GroupBlock *groupBlock;

@property IBOutlet UITableView *tableView;
@property IBOutlet UIBarButtonItem *runItem;
@property IBOutlet UILabel *statusLabel;

- (IBAction)runAction;

@end
