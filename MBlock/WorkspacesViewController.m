//
//  WorkspacesViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "WorkspacesViewController.h"
#import "AppDelegate.h"
#import "GroupBlockViewController.h"

@interface WorkspacesViewController ()

@property(readonly) Workspace *workspace;

@end

@implementation WorkspacesViewController

- (Workspace *)workspace {
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return appd.workspace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Lanes";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																						  target:self
																						  action:@selector(addGroupBlock)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (IBAction)addGroupBlock {
	GroupBlock *groupBlock = [[GroupBlock alloc] init];
	groupBlock.workspace = self.workspace;
	[self.workspace.groupBlocks addObject:groupBlock];
	[self.workspace write];
	[self.tableView reloadData];
}

- (NSString *)labelForGroupBlock:(GroupBlock *)groupBlock {
	NSMutableString *s = [NSMutableString string];
	for (Block *block in groupBlock.blocks) {
		if (s.length > 0) {
			[s appendString:@" -> "];
		}
		[s appendString:block.name];
	}
	return s;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workspace.groupBlocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GroupBlock *groupBlock = [self.workspace.groupBlocks objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"WSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = [self labelForGroupBlock:groupBlock];
	cell.accessoryType = groupBlock.running ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.workspace.groupBlocks removeObjectAtIndex:indexPath.row];
		[self.workspace write];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	GroupBlock *groupBlock = [self.workspace.groupBlocks objectAtIndex:fromIndexPath.row];
	[self.workspace.groupBlocks removeObjectAtIndex:fromIndexPath.row];
	[self.workspace.groupBlocks insertObject:groupBlock atIndex:toIndexPath.row];
	[self.workspace write];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	GroupBlock *groupBlock = [self.workspace.groupBlocks objectAtIndex:indexPath.row];
	GroupBlockViewController *viewController = [[GroupBlockViewController alloc] initWithNibName:@"GroupBlockViewController"
																						  bundle:nil];
	viewController.groupBlock = groupBlock;
     [self.navigationController pushViewController:viewController animated:YES];
}

@end
