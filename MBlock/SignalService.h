//
//  SignalService.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataClient.h"

static const double kSignalAmplification = 1000.0; // signals are multiplied by this value and sent as ints

@interface SignalService : NSObject

@property(assign) id<DataClient> dataClient;
@property(readonly) BOOL running;
@property(readonly) NSString *info;

- (void)start;
- (void)stop;

- (BOOL)acceptsPacket:(NSData *)packetData;
- (void)logPacket:(NSData *)packetData;

// Helpers

- (void)sendSignal:(int32_t)signalType withData:(NSData *)data;
- (BOOL)acceptsSignalType:(int32_t)signalType;
- (void)logData:(NSData *)data;

@end
