//
//  MUserPreferences.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/19/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUserPreferences : NSObject

+ (MUserPreferences *)instance;

@property(copy) NSString *IPAddress;
@property int port;

@property double motionFrequency;
@property BOOL locationContinuous;
@property double locationFrequency;
@property BOOL proximityContinuous;
@property double proximityFrequency;

@end
