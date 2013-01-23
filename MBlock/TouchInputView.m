//
//  TouchInputView.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "TouchInputView.h"

NSString * const TouchesDidChangeNotification = @"TouchesDidChange";

static const int32_t kInvalidTouchInfoId = 0;

static const CGFloat kMarksStep = 40.0;
static const CGFloat kMarksWidth = 3.0;
static const CGFloat kTouchesWidth = 40.0;

static int32_t nextTouchInfoIdentifier = 1;

@interface TouchInfo ()

- (void)startMove;
- (void)moveTo:(CGPoint)point;
- (void)endMove;
- (CGFloat)distanceToPoint2:(CGPoint)point;

@end

@implementation TouchInfo

- (id)init {
    if ((self = [super init])) {
		_identifier = kInvalidTouchInfoId;
    }
    return self;
}

- (void)startMove {
	_identifier = nextTouchInfoIdentifier++;
}

- (void)moveTo:(CGPoint)point {
	_x = point.x;
	_y = point.y;
}

- (void)endMove {
	_identifier = kInvalidTouchInfoId;
	_x = 0;
	_y = 0;
}

- (CGFloat)distanceToPoint2:(CGPoint)point {
	CGFloat dx = _x - point.x;
	CGFloat dy = _y - point.y;
	return dx * dx + dy * dy;
}

- (BOOL)valid {
	return _identifier != kInvalidTouchInfoId;
}

@end


@implementation TouchInputView {
@private
	NSMutableArray *_touchInfos;
}

- (NSArray *)touchInfos {
	if (!_touchInfos) {
		_touchInfos = [NSMutableArray arrayWithCapacity:5];
		for (int i = 0; i < 5; i++) {
			[_touchInfos addObject:[[TouchInfo alloc] init]];
		}
	}
	return _touchInfos;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (self.marksColor) {
		[self.marksColor set];
		CGContextSetLineWidth(ctx, 1);
		CGMutablePathRef path = CGPathCreateMutable();
		for (CGFloat x = 0; x <= self.bounds.size.width; x += kMarksStep) {
			for (CGFloat y = 0; y <= self.bounds.size.height; y += kMarksStep) {
				CGPathMoveToPoint(path, NULL, x - kMarksWidth, y);
				CGPathAddLineToPoint(path, NULL, x + kMarksWidth, y);
				CGPathMoveToPoint(path, NULL, x, y - kMarksWidth);
				CGPathAddLineToPoint(path, NULL, x, y + kMarksWidth);
			}
		}
		CGContextAddPath(ctx, path);
		CGContextStrokePath(ctx);
		CGPathRelease(path);
	}
	if (self.touchesColor) {
		[self.touchesColor set];
		CGContextSetLineWidth(ctx, 1);
		for (TouchInfo *touchInfo in self.touchInfos) {
			if (!touchInfo.valid) {
				continue;
			}
			CGContextStrokeEllipseInRect(ctx, CGRectMake(touchInfo.x - kTouchesWidth,
														 touchInfo.y - kTouchesWidth,
														 kTouchesWidth * 2,
														 kTouchesWidth * 2));
		}
	}
}

- (void)printEvent:(NSString *)eventName withTouches:(NSSet *)touches {
	/*
	NSMutableString *str = [NSMutableString stringWithString:eventName];
	for (UITouch *touch in touches) {
		const CGPoint ploc = [touch previousLocationInView:self];
		const CGPoint cloc = [touch locationInView:self];
		char phase = '?';
		switch (touch.phase) {
			case UITouchPhaseBegan:      phase = 'b'; break;
			case UITouchPhaseCancelled:  phase = 'c'; break;
			case UITouchPhaseEnded:      phase = 'e'; break;
			case UITouchPhaseMoved:      phase = 'm'; break;
			case UITouchPhaseStationary: phase = 's'; break;
		}
		[str appendFormat:@" <%c (%g, %g) -> (%g, %g)>", phase, ploc.x, ploc.y, cloc.x, cloc.y];
	}
	NSLog(@"%@", str);
	 */
}

- (void)printTouchInfos {
	/*
	NSMutableString *str = [NSMutableString stringWithString:@"Touch Infos:"];
	for (TouchInfo *touchInfo in self.touchInfos) {
		[str appendFormat:@" <%d %g,%g>", touchInfo.identifier, touchInfo.x, touchInfo.y];
	}
	NSLog(@"%@", str);
	 */
}

- (TouchInfo *)firstAvailableTouchInfo {
	for (TouchInfo *touchInfo in self.touchInfos) {
		if (!touchInfo.valid) {
			return touchInfo;
		}
	}
	return nil;
}

- (TouchInfo *)closestTouchInfo:(UITouch *)touch {
	const CGPoint ploc = [touch previousLocationInView:self];
	TouchInfo *closestTouchInfo = nil;
	CGFloat closestDistance = CGFLOAT_MAX;
	for (TouchInfo *touchInfo in self.touchInfos) {
		if (!touchInfo.valid) {
			continue;
		}
		CGFloat distance = [touchInfo distanceToPoint2:ploc];
		if (distance < closestDistance) {
			closestDistance = distance;
			closestTouchInfo = touchInfo;
		}
	}
	return closestTouchInfo;
}

- (void)addTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [self firstAvailableTouchInfo];
		[touchInfo startMove];
		[touchInfo moveTo:[touch locationInView:self]];
	}
	[self printTouchInfos];
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:TouchesDidChangeNotification object:self];
}

- (void)updateTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [self closestTouchInfo:touch];
		[touchInfo moveTo:[touch locationInView:self]];
	}
	[self printTouchInfos];
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:TouchesDidChangeNotification object:self];
}

- (void)removeTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [self closestTouchInfo:touch];
		[touchInfo endMove];
	}
	[self printTouchInfos];
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:TouchesDidChangeNotification object:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self printEvent:@"Began" withTouches:touches];
	[self addTouches:touches];
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self printEvent:@"Moved" withTouches:touches];
	[self updateTouches:touches];
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self printEvent:@"Ended" withTouches:touches];
	[self removeTouches:touches];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self printEvent:@"Cancd" withTouches:touches];
	[self removeTouches:touches];
	[super touchesCancelled:touches withEvent:event];
}

@end
