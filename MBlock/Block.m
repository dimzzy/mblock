//
//  Block.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "Block.h"
#import "Workspace.h"

@implementation Block

- (void)dealloc {
	[self stop];
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		_signalReceiver = [coder decodeObjectForKey:@"signalReceiver"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	if ([self.signalReceiver conformsToProtocol:@protocol(NSCoding)]) {
		[coder encodeObject:_signalReceiver forKey:@"signalReceiver"];
	}
}

- (void)receiveSignal:(Signal *)signal {
	[self sendSignal:signal];
}

- (void)sendSignal:(Signal *)signal {
	[self.signalReceiver receiveSignal:signal];
}

- (void)start {
	_running = YES;
}

- (void)stop {
	_running = NO;
}

- (void)blockDidChange {
	if (self.workspace) {
		[self.workspace blockDidChange:self];
	}
}

- (void)addObserverForProperty:(NSString *)propertyName {
	[self addObserver:self
		   forKeyPath:propertyName
			  options:0
			  context:(__bridge void *)[self blockObservationContext]];
}

- (void)removeObserverForProperty:(NSString *)propertyName {
	[self removeObserver:self
			  forKeyPath:propertyName
				 context:(__bridge void *)[self blockObservationContext]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == self && context == (__bridge void *)[self blockObservationContext]) {
		[self blockDidChange];
	}
}

- (id)blockObservationContext {
	static id context = nil;
	if (!context) {
		context = [[NSObject alloc] init];
	}
	return context;
}

@end
