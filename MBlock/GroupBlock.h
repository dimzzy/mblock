//
//  GroupBlock.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@interface GroupBlock : Block <NSCoding>

@property(readonly) NSArray *blocks; // [:Block]

- (void)addBlock:(Block *)block;
- (void)insertBlock:(Block *)block atIndex:(NSUInteger)index;
- (void)removeBlockAtIndex:(NSUInteger)index;
- (void)moveBlockAtIndex:(NSUInteger)index toIndex:(NSUInteger)index;

- (NSString *)firstStartFailure;

@end
