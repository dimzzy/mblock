//
//  LocationBlock.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "EventfulBlock.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationBlock : EventfulBlock <CLLocationManagerDelegate>

@end
