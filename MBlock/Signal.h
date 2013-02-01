//
//  Signal.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int32_t kMotionSignalType = 0x10;
static const int32_t kLocationSignalType = 0x20;
static const int32_t kProximitySignalType = 0x30;
static const int32_t kTouchInputSignalType = 0x40;
static const int32_t kSineSignalType = 0x50;

@interface Signal : NSObject

- (id)initWithType:(int32_t)type time:(int32_t)time values:(NSArray *)values labels:(NSArray *)labels;
- (id)initWithType:(int32_t)type time:(int32_t)time values:(NSArray *)values;
- (id)initWithType:(int32_t)type values:(NSArray *)values labels:(NSArray *)labels;
- (id)initWithType:(int32_t)type values:(NSArray *)values;

@property(readonly) int32_t type;
@property(readonly) int32_t time; // milliseconds, unix time
@property(readonly) NSArray *values; // [:double]
@property(readonly) NSArray *labels; // [:NSString *]
@property(readonly) NSUInteger width;
- (double)valueAtIndex:(NSInteger)index;
- (NSString *)labelAtIndex:(NSInteger)index;
- (void)enumerateWithBlock:(void (^)(double value, NSString *label, NSUInteger index, BOOL *stop))block;

@end
