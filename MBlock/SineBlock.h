//
//  SineBlock.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/17/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@interface SineBlock : Block <NSCoding>

@property double frequency; // Hz
@property(readonly) double minFrequency;
@property(readonly) double maxFrequency;

@end
