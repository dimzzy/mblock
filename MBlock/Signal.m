//
//  Signal.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Signal.h"

@implementation Signal

- (id)initWithType:(int32_t)type values:(NSArray *)values labels:(NSArray *)labels {
	if ((self = [super init])) {
		_values = [NSArray arrayWithArray:values];
		_labels = labels ? [NSArray arrayWithArray:labels] : [NSArray array];
	}
	return self;
}

- (id)initWithType:(int32_t)type values:(NSArray *)values {
	return [self initWithType:type values:values labels:nil];
}

- (NSUInteger)width {
	return [_values count];
}

- (double)valueAtIndex:(NSInteger)index {
	NSNumber *value = [_values objectAtIndex:index];
	return [value doubleValue];
}

- (NSString *)labelAtIndex:(NSInteger)index {
	if (index < [_values count] && index >= [_labels count]) {
		return @"";
	}
	return (NSString *)[_labels objectAtIndex:index];
}

- (void)enumerateWithBlock:(void (^)(double value, NSString *label, NSUInteger index, BOOL *stop))block {
	BOOL stop = NO;
	for (NSUInteger i = 0; i < self.width; i++) {
		double value = [self valueAtIndex:i];
		NSString *label = [self labelAtIndex:i];
		block(value, label, i, &stop);
		if (stop) {
			break;
		}
	}
}

@end
