//
//  Block.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"
#import "BlockCategory.h"

static const double kSignalAmplification = 1000.0; // signals are multiplied by this value and sent as ints
static const int kPacketHeaderWidth = 4;

@protocol SignalReceiver <NSObject>

- (void)receiveSignal:(Signal *)signal;

@end


@protocol Actionable <NSObject>

- (void)performAction;

@end


@class Workspace;

@interface Block : NSObject <SignalReceiver, NSCoding>

@property(weak) Workspace *workspace;
@property id<SignalReceiver> signalReceiver;
@property(readonly) BOOL unique; // only a single instance is allowed
@property(readonly) NSString *name;
@property(readonly) NSString *info;
@property(readonly) BlockCategory *category;
@property(readonly) BOOL running;
@property NSString *startFailure;

- (void)start;
- (void)stop;



// private

- (void)sendSignal:(Signal *)signal;
- (void)blockDidChange;
- (void)addObserverForProperty:(NSString *)propertyName;
- (void)removeObserverForProperty:(NSString *)propertyName;

@end
