//
//  BlockCategory.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/23/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockCategory : NSObject

@property(readonly) NSString *name;

+ (BlockCategory *)generators;
+ (BlockCategory *)io;
+ (BlockCategory *)other;

+ (NSArray *)allCategories;

@end
