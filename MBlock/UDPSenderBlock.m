//
//  UDPSenderBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/9/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "UDPSenderBlock.h"
#import "UDPClient.h"
#include <sys/time.h>

static const double kSignalAmplification = 1000.0; // signals are multiplied by this value and sent as ints
static const int kPacketHeaderWidth = 4;
static const int kPacketMinWidth = 6;

@implementation UDPSenderBlock {
@private
	UDPClient *_connection;
}

- (NSString *)info {
	return @"Sends signal via UDP socket.";
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_IPAddress = [coder decodeObjectForKey:@"ip_address"];
		_port = [coder decodeIntForKey:@"port"];
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
	_connection = [[UDPClient alloc] initWithIPAddress:self.IPAddress port:self.port];
	if (!_connection.connected) {
		return;
	}
	[super start];
}

- (void)stop {
	if (!self.running) {
		return;
	}
	_connection = nil;
	[super stop];
}

- (void)sendSignal:(Signal *)signal {
	const size_t packetLength = (kPacketHeaderWidth + MAX(signal.width, kPacketMinWidth)) * sizeof(int32_t);
	int32_t *packet = malloc(packetLength);
	packet[0] = 0x600df00d;
	packet[1] = [self currentTimeMillis];
	packet[2] = signal.type;
	packet[3] = signal.width;
	[signal enumerateWithBlock:^(double value, NSString *label, NSUInteger index, BOOL *stop) {
		packet[kPacketHeaderWidth + index] = (int32_t)(value * kSignalAmplification);
	}];
	for (int i = kPacketHeaderWidth + signal.width; i < kPacketHeaderWidth + kPacketMinWidth; i++) {
		packet[i] = 0;
	}
	[_connection sendData:packet length:packetLength];
	free(packet);

	[super sendSignal:signal];
}

- (int)currentTimeMillis {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return (tv.tv_sec) * 1000 + (tv.tv_usec) / 1000;
}

@end
