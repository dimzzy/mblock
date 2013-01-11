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
	NSString *_frequencyLimitsFormat;
	NSString *_currentFrequencyFormat;
}

- (void)awakeFromNib {
	_frequencyLimitsFormat = self.titleView.text;
	_currentFrequencyFormat = self.currentFrequencyView.text;
	_frequency = self.frequencyView.value;
	[self updateFrequencyLimits];
	[self updateCurrentValueText];
}

- (double)normalizedFrequency:(double)frequency {
	return nearbyint(frequency * 2.0) / 2.0;
}

- (double)normalizedFrequency {
	return [self normalizedFrequency:_frequency];
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

- (void)updateFrequencyLimits {
	self.titleView.text = [NSString stringWithFormat:_frequencyLimitsFormat,
						   self.frequencyView.minimumValue, self.frequencyView.maximumValue];
}

- (void)updateCurrentValueText {
	self.currentFrequencyView.text = [NSString stringWithFormat:_currentFrequencyFormat, self.normalizedFrequency];
}

@end
