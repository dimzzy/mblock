//
//  GroupBlockViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "GroupBlockViewController.h"
#import "UITableView+BALoading.h"
#import "UIView+BACookie.h"
#import "SequencerBlock.h"
#import "LoggingBlock.h"
#import "UDPSenderBlock.h"
#import "MotionBlock.h"
#import "LocationBlock.h"
#import "ProximityBlock.h"
#import "TouchInputBlock.h"
#import "SineBlock.h"
#import "BlockOptionsViewController.h"
#import "Workspace.h"

@interface GroupBlockViewController ()

@property UIBarButtonItem *startBarButtonItem;
@property UIBarButtonItem *stopBarButtonItem;
@property(readonly) NSDictionary *factoryBlocks;

@end

@implementation GroupBlockViewController {
@private
	NSMutableDictionary *_factoryBlocks; // <category_name:NSString -> [:Block]>
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self updateStatus];
}

- (void)addFactoryBlock:(Block *)block {
	NSMutableArray *blocks = [_factoryBlocks objectForKey:block.category.name];
	[blocks addObject:block];
}

- (NSDictionary *)factoryBlocks {
	if (!_factoryBlocks) {
		_factoryBlocks = [[NSMutableDictionary alloc] init];
		for (BlockCategory *category in [BlockCategory allCategories]) {
			[_factoryBlocks setObject:[NSMutableArray array] forKey:category.name];
		}
		[self addFactoryBlock:[[SequencerBlock alloc] init]];
		[self addFactoryBlock:[[LoggingBlock alloc] init]];
		[self addFactoryBlock:[[UDPSenderBlock alloc] init]];
		[self addFactoryBlock:[[MotionBlock alloc] init]];
		[self addFactoryBlock:[[LocationBlock alloc] init]];
		[self addFactoryBlock:[[ProximityBlock alloc] init]];
		[self addFactoryBlock:[[SineBlock alloc] init]];
		[self addFactoryBlock:[[TouchInputBlock alloc] init]];
	}
	return _factoryBlocks;
}

- (void)updateStatus {
	self.runItem.title = self.groupBlock.running ? @"Stop" : @"Start";
	self.statusLabel.text = self.groupBlock.running ? @"Running" : @"Idle";
	if (self.groupBlock.workspace.lastStartFailure) {
		self.statusLabel.text = self.groupBlock.workspace.lastStartFailure;
	}
}

- (IBAction)runAction {
	self.groupBlock.workspace.lastFailedBlock = nil;
	self.groupBlock.workspace.lastStartFailure = nil;
	if (self.groupBlock.running) {
		[self.groupBlock stop];
	} else {
		[self.groupBlock start];
	}
	[self updateStatus];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	[self.tableView setEditing:editing animated:animate];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = 1;
	if (self.editing) {
		count += [self.factoryBlocks count];
	}
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [self.groupBlock.blocks count];
	} else {
		BlockCategory *category = [[BlockCategory allCategories] objectAtIndex:(section - 1)];
		NSArray *blocks = [self.factoryBlocks objectForKey:category.name];
		return [blocks count];
	}
}
- (Block *)factoryBlockAtIndexPath:(NSIndexPath *)indexPath {
	BlockCategory *category = [[BlockCategory allCategories] objectAtIndex:(indexPath.section - 1)];
	NSArray *blocks = [self.factoryBlocks objectForKey:category.name];
	return [blocks objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Block *block = nil;
	if (indexPath.section == 0) {
		block = [self.groupBlock.blocks objectAtIndex:indexPath.row];
	} else {
		block = [self factoryBlockAtIndexPath:indexPath];
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBlockCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GBlockCell"];
	}
	cell.textLabel.text = block.name;
	if (indexPath.section == 0 && [block conformsToProtocol:@protocol(Actionable)]) {
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.selectionStyle = indexPath.section == 0 ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		Block *block = [self.groupBlock.blocks objectAtIndex:indexPath.row];
		if ([block conformsToProtocol:@protocol(Actionable)]) {
			[(id<Actionable>)block performAction];
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.groupBlock removeBlockAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		Block *factoryBlock = [self factoryBlockAtIndexPath:indexPath];
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:factoryBlock];
		Block *newBlock = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		[self.groupBlock addBlock:newBlock];
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:([self.groupBlock.blocks count] - 1) inSection:0];
		[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	[self.groupBlock moveBlockAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section)
		? 0 : [self.groupBlock.blocks count] - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.groupBlock.running) {
		return;
	}
	Block *block = [self.groupBlock.blocks objectAtIndex:indexPath.row];
	BlockOptionsViewController *controller = [[BlockOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.block = block;
	controller.title = @"Options";
	[self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	} else {
		BlockCategory *category = [[BlockCategory allCategories] objectAtIndex:(section - 1)];
		return category.name;
	}
	return nil;
}

@end
