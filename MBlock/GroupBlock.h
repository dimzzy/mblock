//
//  GroupBlock.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/10/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"

@interface GroupBlock : Block

@property(readonly) NSArray *blocks; // [:Block]

- (void)addBlock:(Block *)block;
- (void)removeBlockAtIndex:(NSUInteger)index;

@end
