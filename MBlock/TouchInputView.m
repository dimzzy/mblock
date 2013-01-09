//
//  TouchInputView.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "TouchInputView.h"

NSString * const TouchesDidChangeNotification = @"TouchesDidChange";

static const CGFloat kMarksStep = 40.0;
static const CGFloat kMarksWidth = 3.0;
static const CGFloat kTouchesWidth = 40.0;

static int32_t nextTouchInfoIdentifier = 1;

@interface TouchInfo ()

- (void)moveTo:(CGPoint)point;
- (CGFloat)distanceToPoint2:(CGPoint)point;

@end

@implementation TouchInfo

- (id)init {
    if ((self = [super init])) {
		_identifier = nextTouchInfoIdentifier++;
    }
    return self;
}

- (void)moveTo:(CGPoint)point {
	_x = point.x;
	_y = point.y;
}

- (CGFloat)distanceToPoint2:(CGPoint)point {
	CGFloat dx = _x - point.x;
	CGFloat dy = _y - point.y;
	return dx * dx + dy * dy;
}

@end


@implementation TouchInputView {
@private
	NSMutableArray *_touchInfos;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_touchInfos = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)touchInfos {
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
	for (TouchInfo *touchInfo in _touchInfos) {
		[str appendFormat:@" <%d %g,%g>", touchInfo.identifier, touchInfo.x, touchInfo.y];
	}
	NSLog(@"%@", str);
	 */
}

- (void)addTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [[TouchInfo alloc] init];
		[touchInfo moveTo:[touch locationInView:self]];
		[_touchInfos addObject:touchInfo];
	}
	[self printTouchInfos];
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:TouchesDidChangeNotification object:self];
}

- (TouchInfo *)closestTouchInfo:(UITouch *)touch {
	const CGPoint ploc = [touch previousLocationInView:self];
	TouchInfo *closestTouchInfo = nil;
	CGFloat closestDistance = CGFLOAT_MAX;
	for (TouchInfo *touchInfo in _touchInfos) {
		CGFloat distance = [touchInfo distanceToPoint2:ploc];
		if (distance < closestDistance) {
			closestDistance = distance;
			closestTouchInfo = touchInfo;
		}
	}
	return closestTouchInfo;
}

- (void)updateTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [self closestTouchInfo:touch];
		if (touchInfo) {
			[touchInfo moveTo:[touch locationInView:self]];
		}
	}
	[self printTouchInfos];
	[self setNeedsDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:TouchesDidChangeNotification object:self];
}

- (void)removeTouches:(NSSet *)touches {
	for (UITouch *touch in touches) {
		TouchInfo *touchInfo = [self closestTouchInfo:touch];
		if (touchInfo) {
			[_touchInfos removeObject:touchInfo];
		}
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
