//
//  SignalService.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "SignalService.h"

static const int kPacketHeaderWidth = sizeof(uint8_t) * 7;

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

- (void)sendSignal:(uint8_t)signalType withData:(NSData *)data {
	const int packetLength = kPacketHeaderWidth + [data length];
	uint8_t *packet = malloc(packetLength);
	packet[0] = 0x60;
	packet[1] = 0x0d;
	packet[2] = 0xf0;
	packet[3] = 0x0d;
	packet[4] = signalType;
	uint16_t *dataLength = (uint16_t *)&packet[5];
	*dataLength = (uint16_t)[data length];
	memcpy(&packet[7], [data bytes], [data length]);
	NSData *packetData = [NSData dataWithBytes:packet length:packetLength];
	free(packet);
	[self.dataClient sendData:packetData];
	//[self logPacket:packetData];
}

- (BOOL)acceptsPacket:(NSData *)packetData {
	if ([packetData length] < kPacketHeaderWidth) {
		return NO;
	}
	const uint8_t *packet = (uint8_t *)[packetData bytes];
	const BOOL magic = packet[0] == 0x60 && packet[1] == 0x0d && packet[2] == 0xf0 && packet[3] == 0x0d;
	if (!magic) {
		return NO;
	}
	if (![self acceptsSignalType:packet[4]]) {
		return NO;
	}
	const uint16_t *dataLength = (uint16_t *)&packet[5];
	if (*dataLength != ([packetData length] - kPacketHeaderWidth)) {
		return NO;
	}
	return YES;
}

- (void)logPacket:(NSData *)packetData {
	if ([self acceptsPacket:packetData]) {
		const uint8_t *packet = (uint8_t *)[packetData bytes];
		NSData *data = [NSData dataWithBytes:&packet[7] length:([packetData length] - kPacketHeaderWidth)];
		[self logData:data];
	}
}

- (BOOL)acceptsSignalType:(int8_t)signalType {
	return NO;
}

- (void)logData:(NSData *)data {
}

@end
