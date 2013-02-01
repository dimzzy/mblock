//
//  SignalPathBuilder.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/30/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SignalPathBuilder.h"

@implementation SignalPathBuilder {
@private
	CGMutablePathRef _pathRef;
}

- (void)dealloc {
	if (_pathRef) {
		CGPathRelease(_pathRef);
		_pathRef = NULL;
	}
}

- (id)initWithValueIndex:(NSUInteger)valueIndex {
	if ((self = [super init])) {
		_valueIndex = valueIndex;
		_pathRef = CGPathCreateMutable();
		_valueScale = 10.0;
	}
	return self;
}

- (CGPathRef)path {
	return _pathRef;
}

- (void)addSignal:(Signal *)signal afterDX:(double)dx {
	_x += dx;
	if (!signal || signal.width <= self.valueIndex) {
		return;
	}
	const double value = [signal valueAtIndex:self.valueIndex];
	const double y = value * self.valueScale;
	const double x = self.x;
	if (CGPathIsEmpty(_pathRef)) {
		//NSLog(@"m %g, %g", x, y);
		CGPathMoveToPoint(_pathRef, NULL, x, y);
	} else {
		//NSLog(@"l %g, %g", x, y);
		CGPathAddLineToPoint(_pathRef, NULL, x, y);
	}
}

@end
