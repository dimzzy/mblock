//
//  SignalPathBuilder.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/30/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"

@interface SignalPathBuilder : NSObject

@property(readonly) NSUInteger valueIndex; // index of value in signal
@property(readonly) CGPathRef path;
@property(readonly) double x;
@property double valueScale; // multiplier to get y value for signal value

- (id)initWithValueIndex:(NSUInteger)valueIndex;
- (void)addSignal:(Signal *)signal afterDX:(double)dx;

@end
