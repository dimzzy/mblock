//
//  DataClient.h
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataClient <NSObject>

- (BOOL)connected;
- (BOOL)sendData:(NSData *)data;

@end
