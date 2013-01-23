//
//  BlockOptionsViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/11/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "BlockOptionsViewController.h"
#import "UITableView+BALoading.h"
#import "MotionBlock.h"
#import "SequencerBlock.h"
#import "SineBlock.h"
#import "UDPSenderBlock.h"
#import "FrequencyOptionCell.h"
#import "AverageOptionCell.h"
#import "SocketOptionCell.h"

@implementation BlockOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.block isKindOfClass:[MotionBlock class]]) {
		return 1;
	} else if ([self.block isKindOfClass:[SequencerBlock class]]) {
		return 2;
	} else if ([self.block isKindOfClass:[SineBlock class]]) {
		return 1;
	} else if ([self.block isKindOfClass:[UDPSenderBlock class]]) {
		return 1;
	}
    return 0;
}

- (FrequencyOptionCell *)makeFrequencyCell:(UITableView *)tableView {
	BOOL loaded = NO;
	FrequencyOptionCell *cell = (FrequencyOptionCell *)[tableView dequeueOrLoadReusableCellWithClass:[FrequencyOptionCell class]
																							  loaded:&loaded];
	cell.frequencyView.minimumValue = [[self.block valueForKey:@"minFrequency"] doubleValue];
	cell.frequencyView.maximumValue = [[self.block valueForKey:@"maxFrequency"] doubleValue];
	[cell updateFrequencyLimits];
	cell.frequency = [[self.block valueForKey:@"frequency"] doubleValue];
	cell.updater = ^(double frequency) {
		[self.block setValue:[NSNumber numberWithDouble:frequency] forKey:@"frequency"];
	};
	return cell;
}

- (AverageOptionCell *)makeAverageCell:(UITableView *)tableView {
	BOOL loaded = NO;
	AverageOptionCell *cell = (AverageOptionCell *)[tableView dequeueOrLoadReusableCellWithClass:[AverageOptionCell class]
																						  loaded:&loaded];
	cell.averageView.on = [[self.block valueForKey:@"average"] boolValue];
	cell.updater = ^(BOOL average) {
		[self.block setValue:[NSNumber numberWithBool:average] forKey:@"average"];
	};
	return cell;
}

- (SocketOptionCell *)makeSocketCell:(UITableView *)tableView {
	BOOL loaded = NO;
	SocketOptionCell *cell = (SocketOptionCell *)[tableView dequeueOrLoadReusableCellWithClass:[SocketOptionCell class]
																						loaded:&loaded];
	cell.IPAddressView.text = [self.block valueForKey:@"IPAddress"];
	int port = [[self.block valueForKey:@"port"] intValue];
	cell.portView.text = [NSString stringWithFormat:@"%d", port];
	cell.updater = ^(NSString *IPAddress, int port) {
		[self.block setValue:IPAddress forKey:@"IPAddress"];
		[self.block setValue:[NSNumber numberWithInt:port] forKey:@"port"];
	};
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.block isKindOfClass:[MotionBlock class]]) {
		if (indexPath.row == 0) {
			return [self makeFrequencyCell:tableView];
		}
	} else if ([self.block isKindOfClass:[SequencerBlock class]]) {
		if (indexPath.row == 0) {
			return [self makeFrequencyCell:tableView];
		} else if (indexPath.row == 1) {
			return [self makeAverageCell:tableView];
		}
	} else if ([self.block isKindOfClass:[SineBlock class]]) {
		if (indexPath.row == 0) {
			return [self makeFrequencyCell:tableView];
		}
	} else if ([self.block isKindOfClass:[UDPSenderBlock class]]) {
		if (indexPath.row == 0) {
			return [self makeSocketCell:tableView];
		}
	}
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.block isKindOfClass:[MotionBlock class]]) {
		if (indexPath.row == 0) {
			return kFrequencyOptionCellHeight;
		}
	} else if ([self.block isKindOfClass:[SequencerBlock class]]) {
		if (indexPath.row == 0) {
			return kFrequencyOptionCellHeight;
		} else if (indexPath.row == 1) {
			return kAverageOptionCellHeight;
		}
	} else if ([self.block isKindOfClass:[SineBlock class]]) {
		if (indexPath.row == 0) {
			return kFrequencyOptionCellHeight;
		}
	} else if ([self.block isKindOfClass:[UDPSenderBlock class]]) {
		if (indexPath.row == 0) {
			return kSocketOptionCellHeight;
		}
	}
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return self.block.info;
	}
	return nil;
}

@end
