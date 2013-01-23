//
//  BlockCategory.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/23/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "BlockCategory.h"

@interface BlockCategory ()

@property(readwrite) NSString *name;

@end

@implementation BlockCategory

+ (BlockCategory *)generators {
	BlockCategory *_generators;
	if (!_generators) {
		_generators = [[BlockCategory alloc] init];
		_generators.name = @"Generators";
	}
	return _generators;
}

+ (BlockCategory *)io {
	BlockCategory *_io;
	if (!_io) {
		_io = [[BlockCategory alloc] init];
		_io.name = @"Input & Output";
	}
	return _io;
}

+ (BlockCategory *)other {
	BlockCategory *_other;
	if (!_other) {
		_other = [[BlockCategory alloc] init];
		_other.name = @"Other";
	}
	return _other;
}

+ (NSArray *)allCategories {
	NSArray *_cats;
	if (!_cats) {
		_cats = @[
		[self generators],
		[self io],
		[self other]
		];
	}
	return _cats;
}

@end
