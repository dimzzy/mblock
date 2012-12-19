//
//  UDPServer.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDPServer : NSObject

@property(readonly) int port;

- (id)initWithPort:(int)port;
- (BOOL)connected;
- (BOOL)receive;

@end
