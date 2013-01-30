//
//  Workspace.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/14/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupBlock.h"

@interface Workspace : NSObject <NSCoding>

@property(readonly) NSMutableArray *groupBlocks;

- (BOOL)containsBlockOfType:(Class)type;

- (void)write;
+ (Workspace *)readGlobal;

- (void)blockDidChange:(Block *)block;

@end
