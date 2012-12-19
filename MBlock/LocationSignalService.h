//
//  LocationSignalService.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/17/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SignalService.h"

@interface LocationSignalService : SignalService <CLLocationManagerDelegate>

@end
