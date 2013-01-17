//
//  AppDelegate.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/14/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignalService.h"
#import "UDPClient.h"
#import "Workspace.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(readonly) UINavigationController *navigationController;

@property UDPClient *dataClient;
@property(readonly) NSArray *signalServices;
@property(readonly) Workspace *workspace;

@end
