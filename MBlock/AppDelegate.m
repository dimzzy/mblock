//
//  AppDelegate.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/14/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupBlock.h"
#import "MotionBlock.h"
#import "LoggingBlock.h"
#import "GroupBlockViewController.h"
#import "WorkspacesViewController.h"

@implementation AppDelegate

- (UINavigationController *)navigationController {
	return (UINavigationController *)self.window.rootViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_workspace = [Workspace readGlobal];
	if ([_workspace.groupBlocks count] < 1) {
		_workspace = [[Workspace alloc] init];
		GroupBlock *groupBlock = [[GroupBlock alloc] init];
		MotionBlock *motionBlock = [[MotionBlock alloc] init];
		LoggingBlock *loggingBlock = [[LoggingBlock alloc] init];
		[groupBlock addBlock:motionBlock];
		[groupBlock addBlock:loggingBlock];
		[_workspace.groupBlocks addObject:groupBlock];
	}
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	WorkspacesViewController *topController = [[WorkspacesViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:topController];
	self.window.rootViewController = navController;

	if ([_workspace.groupBlocks count] > 0) {
		GroupBlockViewController *viewController = [[GroupBlockViewController alloc] initWithNibName:@"GroupBlockViewController"
																							  bundle:nil];
		viewController.groupBlock = [_workspace.groupBlocks objectAtIndex:0];
		[navController pushViewController:viewController animated:YES];
	}

	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
