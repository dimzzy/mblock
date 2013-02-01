//
//  SignalCapture.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"

typedef void (^SignalCaptureNotifier)();

@interface SignalCapture : NSObject

@property(readonly) NSArray *allSignals;
@property(strong) SignalCaptureNotifier notifier;

- (void)addSignal:(Signal *)signal;

@end
