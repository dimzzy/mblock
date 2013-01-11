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
#import "BlockCell.h"
#import "SequencerBlock.h"
#import "LoggingBlock.h"
#import "UDPSenderBlock.h"
#import "MotionBlock.h"
#import "LocationBlock.h"
#import "ProximityBlock.h"
#import "TouchInputBlock.h"

@interface GroupBlockViewController ()

@property UIBarButtonItem *startBarButtonItem;
@property UIBarButtonItem *stopBarButtonItem;
@property(readonly) NSArray *newBlocks;

@end

@implementation GroupBlockViewController {
@private
	NSArray *_newBlocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.startBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start"
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(startBlock)];
	self.stopBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
															  style:UIBarButtonItemStyleBordered
															 target:self
															 action:@selector(stopBlock)];
	self.navigationItem.leftBarButtonItem = self.groupBlock.running ? self.stopBarButtonItem : self.startBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)newBlocks {
	if (!_newBlocks) {
		_newBlocks = @[
		[[SequencerBlock alloc] init],
		[[LoggingBlock alloc] init],
		[[UDPSenderBlock alloc] init],
		[[MotionBlock alloc] init],
		[[LocationBlock alloc] init],
		[[ProximityBlock alloc] init],
		[[TouchInputBlock alloc] init]
		];
	}
	return _newBlocks;
}

- (Block *)makeBlockAtIndex:(NSUInteger)index {
	switch (index) {
		case 0: return [[SequencerBlock alloc] init];
		case 1: return [[LoggingBlock alloc] init];
		case 2: return [[UDPSenderBlock alloc] init];
		case 3: return [[MotionBlock alloc] init];
		case 4: return [[LocationBlock alloc] init];
		case 5: return [[ProximityBlock alloc] init];
		case 6: return [[TouchInputBlock alloc] init];
	}
	return nil;
}

- (IBAction)startBlock {
	[self.groupBlock start];
	self.navigationItem.leftBarButtonItem = self.stopBarButtonItem;
}

- (IBAction)stopBlock {
	[self.groupBlock stop];
	self.navigationItem.leftBarButtonItem = self.startBarButtonItem;
}

- (IBAction)performBlockAction:(UIButton *)sender {
	if (self.editing) {
		return;
	}
	id<Actionable> actionable = sender.cookie;
	[actionable performAction];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.editing ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [self.groupBlock.blocks count];
	} else if (section == 1) {
		return [self.newBlocks count];
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Block *block = nil;
	if (indexPath.section == 0) {
		block = [self.groupBlock.blocks objectAtIndex:indexPath.row];
	} else {
		block = [self.newBlocks objectAtIndex:indexPath.row];
	}
	BOOL loaded = NO;
	BlockCell *cell = (BlockCell *)[tableView dequeueOrLoadReusableCellWithClass:[BlockCell class]
																		  loaded:&loaded];
	if (loaded) {
		[cell.actionButton addTarget:self action:@selector(performBlockAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	cell.infoView.text = block.info;
	if (indexPath.section == 0 && [block conformsToProtocol:@protocol(Actionable)]) {
		cell.actionButton.cookie = block;
		id<Actionable> actionable = (id<Actionable>)block;
		[cell.actionButton setTitle:[actionable actionTitle] forState:UIControlStateNormal];
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		Block *block = [self.groupBlock.blocks objectAtIndex:indexPath.row];
		if ([block conformsToProtocol:@protocol(Actionable)]) {
			return kBlockCellExtHeight;
		}
		return kBlockCellHeight;
	} else if (indexPath.section == 1) {
		return kBlockCellHeight;
	}
	return 0;
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
		Block *newBlock = [self makeBlockAtIndex:indexPath.row];
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
}

@end
