//
//  MotionSignalService.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalService.h"

@interface MotionSignalService : SignalService

@property double frequency; // default is 10 which means 10 samples per second

@end