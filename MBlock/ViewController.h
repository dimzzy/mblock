//
//  ViewController.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/14/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;

@property NSString *IPAddress;
@property int port;

@end
