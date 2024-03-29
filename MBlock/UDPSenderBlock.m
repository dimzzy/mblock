//
//  UDPSenderBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "UDPSenderBlock.h"
#import "GCDAsyncUdpSocket.h"
#import "Workspace.h"

static const int kPacketMinWidth = 6;

@implementation UDPSenderBlock {
@private
	GCDAsyncUdpSocket *_connection;
}

- (NSString *)name {
	return @"UDP Out";
}

- (NSString *)info {
	return @"Sends signal via UDP socket.";
}

- (BlockCategory *)category {
	return [BlockCategory io];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"IPAddress"];
	[self removeObserver:self forKeyPath:@"port"];
}

- (id)init {
	if ((self = [super init])) {
		_IPAddress = @"127.0.0.1";
		_port = 25000;
		[self addObserverForProperty:@"IPAddress"];
		[self addObserverForProperty:@"port"];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_IPAddress = [coder decodeObjectForKey:@"ip_address"];
		_port = [coder decodeIntForKey:@"port"];
		[self addObserverForProperty:@"IPAddress"];
		[self addObserverForProperty:@"port"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_IPAddress forKey:@"ip_address"];
	[coder encodeInt:_port forKey:@"port"];
	[super encodeWithCoder:coder];
}

- (void)start {
	if (self.running) {
		return;
	}
	_connection = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	NSError *error = nil;
	if (![_connection connectToHost:self.IPAddress onPort:self.port error:&error]) {
		self.startFailure = @"Unable to setup UDP connection";
		[_connection close];
		_connection = nil;
		return;
	}
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	[_connection close];
	_connection = nil;
	[super stop];
}

- (void)sendSignal:(Signal *)signal {
	const size_t packetLength = (kPacketHeaderWidth + MAX(signal.width, kPacketMinWidth)) * sizeof(int32_t);
	int32_t *packet = malloc(packetLength);
	packet[0] = 0x600df00d;
	packet[1] = signal.time;
	packet[2] = signal.type;
	packet[3] = signal.width;
	[signal enumerateWithBlock:^(double value, NSString *label, NSUInteger index, BOOL *stop) {
		packet[kPacketHeaderWidth + index] = (int32_t)(value * kSignalAmplification);
	}];
	for (int i = kPacketHeaderWidth + signal.width; i < kPacketHeaderWidth + kPacketMinWidth; i++) {
		packet[i] = 0;
	}
	NSData *data = [NSData dataWithBytes:packet length:packetLength];
	[_connection sendData:data withTimeout:5 tag:0];
	free(packet);

	[super sendSignal:signal];
}

@end
