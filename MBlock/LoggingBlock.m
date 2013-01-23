//
//  LoggingBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "LoggingBlock.h"

@implementation LoggingBlock

- (NSString *)name {
	return @"Console";
}

- (NSString *)info {
	return @"Prints signal to console.";
}

- (BlockCategory *)category {
	return [BlockCategory io];
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
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
