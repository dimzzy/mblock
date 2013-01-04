//
//  EventfulSignalService.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SignalService.h"

@interface EventfulSignalService : SignalService

@property BOOL continuous;
@property double frequency; // Hz

- (void)sendTimedSignal:(NSTimer *)timer;

@end
