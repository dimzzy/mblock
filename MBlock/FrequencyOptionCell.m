//
//  FrequencyOptionCell.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "FrequencyOptionCell.h"

@implementation FrequencyOptionCell {
@private
	double _frequency;
	NSString *_prefix;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	_prefix = self.currentFrequencyView.text;
	_frequency = self.frequencyView.value;
	[self updateCurrentValueText];
}

- (double)normalizedFrequency {
	return nearbyint(_frequency * 2.0) / 2.0;
}

- (double)frequency {
	return _frequency;
}

- (void)setFrequency:(double)frequency {
	frequency = MAX(frequency, self.frequencyView.minimumValue);
	frequency = MIN(frequency, self.frequencyView.maximumValue);
	if (_frequency == frequency) {
		return;
	}
	_frequency = frequency;
	self.frequencyView.value = frequency;
	[self updateCurrentValueText];
}

- (IBAction)frequencyViewDidChange:(UISlider *)source {
	_frequency = self.frequencyView.value;
	[self updateCurrentValueText];
	_updater(self.normalizedFrequency);
}

- (void)updateCurrentValueText {
	self.currentFrequencyView.text = [NSString stringWithFormat:@"%@ %g Hz", _prefix, self.normalizedFrequency];
}

@end
