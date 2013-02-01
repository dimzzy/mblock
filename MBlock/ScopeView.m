//
//  ScopeView.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "ScopeView.h"
#import "SignalBuilder.h"
#import <QuartzCore/QuartzCore.h>

@interface ScopeView ()

@property(readonly) SignalBuilder *builder;

@end


@implementation ScopeView {
@private
	SignalBuilder *_builder;
	SignalCapture *_capture;
	CALayer *_pathsLayer;
}

- (SignalBuilder *)builder {
	if (!_builder) {
		_builder = [[SignalBuilder alloc] init];
	}
	return _builder;
}

- (SignalCapture *)capture {
	return _capture;
}

- (void)setCapture:(SignalCapture *)capture {
	if (capture) {
		_capture = capture;
		__weak ScopeView *weakSelf = self;
		_capture.notifier = ^{
			ScopeView *strongSelf = weakSelf;
			if (strongSelf) {
				[strongSelf captureDidChange];
			}
		};
		for (Signal *signal in capture.allSignals) {
			[self.builder addSignal:signal];
		}
	} else {
		_builder = nil;
		_capture = nil;
	}
	[self updatePathLayers];
}

- (void)captureDidChange {
	Signal *signal = [self.capture.allSignals lastObject];
	if (signal) {
		[self.builder addSignal:signal];
		[self updatePathLayers];
	}
}

- (void)updatePathLayers {
	CGRect r = self.bounds;
	if (!_pathsLayer) {
		_pathsLayer = [[CALayer alloc] init];
		_pathsLayer.frame = r;
		[self.layer addSublayer:_pathsLayer];
//		CAShapeLayer *sl = [[CAShapeLayer alloc] init];
//		CGMutablePathRef p = CGPathCreateMutable();
//		CGPathMoveToPoint(p, NULL, -100, -100);
//		CGPathAddLineToPoint(p, NULL, 100, 100);
//		CGPathAddRect(p, NULL, CGRectMake(80, 80, 40, 40));
//		CGPathMoveToPoint(p, NULL, -100, 100);
//		CGPathAddLineToPoint(p, NULL, 100, -100);
//		sl.path = p;
//		CGPathRelease(p);
//		sl.lineWidth = 1;
//		sl.strokeColor = [UIColor redColor].CGColor;
//		[_pathsLayer addSublayer:sl];
//		[self arrangePathLayers];
	}
	while ([_pathsLayer.sublayers count] > [self.builder.pathBuilders count]) {
		CALayer *pathLayer = [_pathsLayer.sublayers lastObject];
		[pathLayer removeFromSuperlayer];
	}
	while ([_pathsLayer.sublayers count] < [self.builder.pathBuilders count]) {
		CAShapeLayer *pathLayer = [[CAShapeLayer alloc] init];
		pathLayer.frame = r;
		pathLayer.affineTransform = CGAffineTransformMakeTranslation(0, r.size.height / 2);
		pathLayer.lineWidth = 1;
		pathLayer.strokeColor = [UIColor greenColor].CGColor;
		[_pathsLayer addSublayer:pathLayer];
	}
	[self.builder.pathBuilders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SignalPathBuilder *pathBuilder = obj;
		CAShapeLayer *pathLayer = [_pathsLayer.sublayers objectAtIndex:idx];
		pathLayer.path = NULL;
		pathLayer.path = pathBuilder.path;
	}];
}

- (void)arrangePathLayers {
	if (!_pathsLayer) {
		return;
	}
	CGRect r = self.bounds;
	_pathsLayer.frame = r;
	for (CALayer *pathLayer in _pathsLayer.sublayers) {
		pathLayer.frame = r;
		pathLayer.affineTransform = CGAffineTransformMakeTranslation(0, r.size.height / 2);
	}
}

- (void)setFrame:(CGRect)r {
	if (CGRectEqualToRect(r, self.frame)) {
		return;
	}
	[super setFrame:r];
	[self arrangePathLayers];
}

@end
