//
//  Workspace.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/14/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Workspace.h"
#include <sys/xattr.h>

@implementation Workspace

- (id)init {
	if ((self = [super init])) {
		_groupBlocks = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		_groupBlocks = [[NSMutableArray alloc] init];
		NSArray *groupBlocks = [coder decodeObjectForKey:@"blocks"];
		for (GroupBlock *groupBlock in groupBlocks) {
			groupBlock.workspace = self;
			[_groupBlocks addObject:groupBlock];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_groupBlocks forKey:@"blocks"];
}

- (void)blockDidChange:(Block *)block {
	[self write];
}

+ (NSString *)workspacePath {
	return [@"~/Documents/workspace.plist" stringByExpandingTildeInPath];
}

- (void)write {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		[NSKeyedArchiver archiveRootObject:self toFile:[[self class] workspacePath]];
		[self addSkipBackupAttributeToFile:[NSURL fileURLWithPath:[[self class] workspacePath]]];
	});
}

+ (Workspace *)readGlobal {
	Workspace *workspace = nil;
	@try {
		workspace = [NSKeyedUnarchiver unarchiveObjectWithFile:[self workspacePath]];
	}
	@catch (NSException *e) {
		NSLog(@"Error reading workspace: %@", [e description]);
	}
	return workspace;
}

- (void)addSkipBackupAttributeToFile:(NSURL*)URL {
    u_int8_t b = 1;
    setxattr([[URL path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

- (BOOL)groupBlock:(GroupBlock *)groupBlock containsBlockOfType:(Class)type {
	if ([groupBlock isKindOfClass:type]) {
		return YES;
	}
	for (Block *block in groupBlock.blocks) {
		if ([block isKindOfClass:[GroupBlock class]]) {
			BOOL contains = [self groupBlock:(GroupBlock *)block containsBlockOfType:type];
			if (contains) {
				return YES;
			}
		} else if ([block isKindOfClass:type]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)containsBlockOfType:(Class)type {
	for (GroupBlock *groupBlock in self.groupBlocks) {
		if ([self groupBlock:groupBlock containsBlockOfType:type]) {
			return YES;
		}
	}
	return NO;
}

@end
