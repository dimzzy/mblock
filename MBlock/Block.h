//
//  Block.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"

@protocol SignalReceiver <NSObject>

- (void)receiveSignal:(Signal *)signal;

@end


@protocol Actionable <NSObject>

- (NSString *)actionTitle;
- (void)performAction;

@end


@interface Block : NSObject <SignalReceiver>

@property(readonly) NSMutableSet *signalReceivers;
@property(readonly) BOOL unique; // only a single instance is allowed
@property(readonly) NSString *info;
@property(readonly) BOOL running;

- (void)start;
- (void)stop;



// private

- (void)sendSignal:(Signal *)signal;

@end
