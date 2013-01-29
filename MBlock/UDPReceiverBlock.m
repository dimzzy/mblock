//
//  UDPReceiverBlock.m
//  MBlock
//
//  Created by Dmitry Stadnik on 1/29/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import "UDPReceiverBlock.h"
#import "GCDAsyncUdpSocket.h"
#import "Workspace.h"

@implementation UDPReceiverBlock {
@private
	GCDAsyncUdpSocket *_connection;
}

- (NSString *)name {
	return @"UDP In";
}

- (NSString *)info {
	return @"Receives signal via UDP socket.";
}

- (BlockCategory *)category {
	return [BlockCategory io];
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"port"];
}

- (id)init {
	if ((self = [super init])) {
		_port = 25001;
		[self addObserverForProperty:@"port"];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		_port = [coder decodeIntForKey:@"port"];
		[self addObserverForProperty:@"port"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInt:_port forKey:@"port"];
	[super encodeWithCoder:coder];
}

- (void)start {
	if (self.running) {
		return;
	}
	_connection = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	NSError *error = nil;
	if (![_connection bindToPort:self.port error:&error]) {
		self.workspace.lastFailedBlock = self;
		self.workspace.lastStartFailure = @"Unable to setup UDP connection";
		[_connection close];
		_connection = nil;
		return;
	}
	if (![_connection beginReceiving:&error]) {
		self.workspace.lastFailedBlock = self;
		self.workspace.lastStartFailure = @"Unable to setup UDP connection";
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

- (void)udpSocket:(GCDAsyncUdpSocket *)socket
   didReceiveData:(NSData *)data
	  fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	const size_t packetLength = [data length];
	if (packetLength <= kPacketHeaderWidth * sizeof(int32_t)) {
		return; // too short
	}
	int32_t *packet = (int32_t *)[data bytes];
	if (packet[0] != 0x600df00d) {
		return; // not for us
	}
	//const int timestamp = packet[1];
	const int32_t signalType = packet[2];
	const int32_t signalWidth = packet[3];
	const size_t dataSize = packetLength - kPacketHeaderWidth * sizeof(int32_t);
	if (signalWidth * sizeof(int32_t) > dataSize) {
		return; // wrong data size
	}
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:signalWidth];
	for (int i = kPacketHeaderWidth; i < kPacketHeaderWidth + signalWidth; i++) {
		double value = (double)packet[i] / kSignalAmplification;
		[values addObject:[NSNumber numberWithDouble:value]];
	}
	Signal *signal = [[Signal alloc] initWithType:signalType values:values];
	[self sendSignal:signal];
}

@end
