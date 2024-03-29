//
//  SequencerBlock.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@interface SequencerBlock : Block <NSCoding>

@property double frequency; // Hz
@property(readonly) double minFrequency;
@property(readonly) double maxFrequency;

@property BOOL average;

@end
