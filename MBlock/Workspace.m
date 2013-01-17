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
		_mainBlock = [[GroupBlock alloc] init];
		_mainBlock.workspace = self;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		_mainBlock = [coder decodeObjectForKey:@"block"];
		_mainBlock.workspace = self;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_mainBlock forKey:@"block"];
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

@end
