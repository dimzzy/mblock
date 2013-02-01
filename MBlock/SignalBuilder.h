//
//  SignalBuilder.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/30/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalPathBuilder.h"

@interface SignalBuilder : NSObject

@property(readonly) NSArray *pathBuilders;
@property(readonly) double x;
@property double timeScale; // multiplier to get x delta for time interval between signals

- (void)ensureWidth:(NSUInteger)width;
- (void)addSignal:(Signal *)signal;

@end
