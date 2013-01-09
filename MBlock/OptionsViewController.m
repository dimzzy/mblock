//
//  OptionsViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "OptionsViewController.h"
#import "UITableView+BALoading.h"
#import "ContinuousOptionCell.h"
#import "FrequencyOptionCell.h"
#import "MotionSignalService.h"
#import "LocationSignalService.h"
#import "ProximitySignalService.h"
#import "TouchSignalService.h"
#import "MUserPreferences.h"

@implementation OptionsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.signalService isKindOfClass:[MotionSignalService class]]) {
		return 1;
	} else if ([self.signalService isKindOfClass:[LocationSignalService class]]) {
		return 2;
	} else if ([self.signalService isKindOfClass:[ProximitySignalService class]]) {
		return 2;
	} else if ([self.signalService isKindOfClass:[TouchSignalService class]]) {
		return 2;
	}
    return 0;
}

- (ContinuousOptionCell *)makeContinuousOptionCell:(UITableView *)tableView {
	BOOL loaded = NO;
	ContinuousOptionCell *cell = (ContinuousOptionCell *)[tableView dequeueOrLoadReusableCellWithClass:[ContinuousOptionCell class]
																								loaded:&loaded];
	EventfulSignalService *eservice = (EventfulSignalService *)self.signalService;
	cell.continuous = eservice.continuous;
	cell.updater = ^(BOOL continuous) {
		eservice.continuous = continuous;
		if ([self.signalService isKindOfClass:[LocationSignalService class]]) {
			[MUserPreferences instance].locationContinuous = continuous;
		} else if ([self.signalService isKindOfClass:[ProximitySignalService class]]) {
			[MUserPreferences instance].proximityContinuous = continuous;
		} else if ([self.signalService isKindOfClass:[TouchSignalService class]]) {
			[MUserPreferences instance].touchContinuous = continuous;
		}
	};
	return cell;
}

- (FrequencyOptionCell *)makeFrequencyOptionCell:(UITableView *)tableView {
	BOOL loaded = NO;
	FrequencyOptionCell *cell = (FrequencyOptionCell *)[tableView dequeueOrLoadReusableCellWithClass:[FrequencyOptionCell class]
																							  loaded:&loaded];
	cell.frequency = self.signalService.frequency;
	cell.updater = ^(double frequency) {
		self.signalService.frequency = frequency;
		if ([self.signalService isKindOfClass:[MotionSignalService class]]) {
			[MUserPreferences instance].motionFrequency = frequency;
		} else if ([self.signalService isKindOfClass:[LocationSignalService class]]) {
			[MUserPreferences instance].locationFrequency = frequency;
		} else if ([self.signalService isKindOfClass:[ProximitySignalService class]]) {
			[MUserPreferences instance].proximityFrequency = frequency;
		} else if ([self.signalService isKindOfClass:[TouchSignalService class]]) {
			[MUserPreferences instance].touchFrequency = frequency;
		}
	};
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.signalService isKindOfClass:[MotionSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return [self makeFrequencyOptionCell:tableView];
			}
		}
		return nil;
	} else if ([self.signalService isKindOfClass:[LocationSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return [self makeContinuousOptionCell:tableView];
			} else if (indexPath.row == 1) {
				return [self makeFrequencyOptionCell:tableView];
			}
		}
		return nil;
	} else if ([self.signalService isKindOfClass:[ProximitySignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return [self makeContinuousOptionCell:tableView];
			} else if (indexPath.row == 1) {
				return [self makeFrequencyOptionCell:tableView];
			}
		}
		return nil;
	} else if ([self.signalService isKindOfClass:[TouchSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return [self makeContinuousOptionCell:tableView];
			} else if (indexPath.row == 1) {
				return [self makeFrequencyOptionCell:tableView];
			}
		}
		return nil;
	}
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.signalService isKindOfClass:[MotionSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return kFrequencyOptionCellHeight;
			}
		}
		return 0;
	} else if ([self.signalService isKindOfClass:[LocationSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return kContinuousOptionCellHeight;
			} else if (indexPath.row == 1) {
				return kFrequencyOptionCellHeight;
			}
		}
		return 0;
	} else if ([self.signalService isKindOfClass:[ProximitySignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return kContinuousOptionCellHeight;
			} else if (indexPath.row == 1) {
				return kFrequencyOptionCellHeight;
			}
		}
		return 0;
	} else if ([self.signalService isKindOfClass:[TouchSignalService class]]) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				return kContinuousOptionCellHeight;
			} else if (indexPath.row == 1) {
				return kFrequencyOptionCellHeight;
			}
		}
		return 0;
	}
	return 0;
}

@end
