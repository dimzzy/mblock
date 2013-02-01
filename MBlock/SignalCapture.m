//
//  SignalCapture.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "SignalCapture.h"

@interface SignalCapture ()

@property(readonly) NSMutableArray *signals;

@end


@implementation SignalCapture {
@private
	NSMutableArray *_signals;
}

- (NSMutableArray *)signals {
	if (!_signals) {
		_signals = [[NSMutableArray alloc] init];
	}
	return _signals;
}

- (NSArray *)allSignals {
	return self.signals;
}

- (void)addSignal:(Signal *)signal {
	[self.signals addObject:signal];
	if (self.notifier) {
		self.notifier();
	}
}

@end
