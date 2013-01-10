//
//  LoggingBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "LoggingBlock.h"

@implementation LoggingBlock

- (NSString *)info {
	return @"Prints signal to console.";
}

- (void)sendSignal:(Signal *)signal {
	NSMutableString *str = [NSMutableString string];
	[str appendFormat:@"~ %02x [%d]", signal.type, signal.width];
	[signal enumerateWithBlock:^(double value, NSString *label, NSUInteger index, BOOL *stop) {
		[str appendFormat:@" %@:%g", label, value];
	}];
	NSLog(@"%@", str);
	[super sendSignal:signal];
}

@end
