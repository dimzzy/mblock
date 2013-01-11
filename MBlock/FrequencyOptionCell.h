//
//  FrequencyOptionCell.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kFrequencyOptionCellHeight = 100;

typedef void (^FrequencyOptionUpdater)(double frequency);

@interface FrequencyOptionCell : UITableViewCell

@property IBOutlet UILabel *titleView;
@property IBOutlet UISlider *frequencyView;
@property IBOutlet UILabel *currentFrequencyView;
@property(strong) FrequencyOptionUpdater updater;
@property double frequency;
@property(readonly) double normalizedFrequency;

- (void)updateFrequencyLimits;
- (IBAction)frequencyViewDidChange:(UISlider *)source;

@end
