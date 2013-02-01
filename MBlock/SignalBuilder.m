//
//  SignalBuilder.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/30/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SignalBuilder.h"

@implementation SignalBuilder {
@private
	NSMutableArray *_pathBuilders;
	int32_t _lastSignalTime;
}

- (id)init {
    if ((self = [super init])) {
		_pathBuilders = [[NSMutableArray alloc] init];
		_timeScale = 10.0 /* points */ / 1000.0 /* milliseconds */;
    }
    return self;
}

- (NSArray *)pathBuilders {
	return _pathBuilders;
}

- (void)ensureWidth:(NSUInteger)width {
	while (width > [_pathBuilders count]) {
		SignalPathBuilder *pathBuilder = [[SignalPathBuilder alloc] initWithValueIndex:[_pathBuilders count]];
		[pathBuilder addSignal:nil afterDX:self.x]; // initial offset
		[_pathBuilders addObject:pathBuilder];
	}
}

- (void)addSignal:(Signal *)signal {
	[self ensureWidth:signal.width];

	double dx = 0;
	if (_lastSignalTime != 0) {
		const int32_t dt = signal.time - _lastSignalTime;
		dx = dt * self.timeScale;
		_x += dx;
	}
	_lastSignalTime = signal.time;

	[_pathBuilders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SignalPathBuilder *pathBuilder = obj;
		[pathBuilder addSignal:signal afterDX:dx];
	}];
}

@end
