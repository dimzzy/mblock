//
//  UDPClient.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataClient.h"

@interface UDPClient : NSObject <DataClient>

@property(readonly) NSString *IPAddress;
@property(readonly) int port;

- (id)initWithIPAddress:(NSString *)IPAddress port:(int)port;

@end
