//
//  SignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "SignalService.h"
#include <sys/time.h>

static const int kPacketHeaderWidth = sizeof(int32_t) * 4;

@implementation SignalService

- (NSString *)info {
	return @"";
}

- (void)dealloc {
	[self stop];
}

- (void)start {
	_running = YES;
}

- (void)stop {
	_running = NO;
}

- (int)currentTimeMillis {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return (tv.tv_sec) * 1000 + (tv.tv_usec) / 1000;
}

- (void)sendSignal:(int32_t)signalType withData:(NSData *)data {
	const int packetLength = kPacketHeaderWidth + [data length];
	int32_t *packet = malloc(packetLength);
	packet[0] = 0x600df00d;
	packet[1] = [self currentTimeMillis];
	packet[2] = signalType;
	packet[3] = [data length] / sizeof(int32_t);
	memcpy(&packet[4], [data bytes], [data length]);
	NSData *packetData = [NSData dataWithBytes:packet length:packetLength];
	free(packet);
	[self.dataClient sendData:packetData];
	[self logPacket:packetData];
}

- (BOOL)acceptsPacket:(NSData *)packetData {
	if ([packetData length] < kPacketHeaderWidth) {
		return NO;
	}
	const int32_t *packet = (int32_t *)[packetData bytes];
	if (packet[0] != 0x600df00d) {
		return NO;
	}
	if (![self acceptsSignalType:packet[2]]) {
		return NO;
	}
	const int dataLength = packet[3] * sizeof(int32_t);
	if (dataLength != ([packetData length] - kPacketHeaderWidth)) {
		return NO;
	}
	return YES;
}

- (void)logPacket:(NSData *)packetData {
	if ([self acceptsPacket:packetData]) {
		const int32_t *packet = (int32_t *)[packetData bytes];
		NSLog(@"Packet: at %d msec, type %02x, %d bytes", packet[1], packet[2], packet[3]);
		NSData *data = [NSData dataWithBytes:&packet[4] length:([packetData length] - kPacketHeaderWidth)];
		[self logData:data];
	}
}

- (BOOL)acceptsSignalType:(int32_t)signalType {
	return NO;
}

- (void)logData:(NSData *)data {
}

@end
