//
//  UDPClient.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "UDPClient.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation UDPClient {
@private
	int _socket;
}

- (id)initWithIPAddress:(NSString *)IPAddress port:(int)port {
	if ((self = [super init])) {
		_IPAddress = [IPAddress copy];
		_port = port;
		_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	}
	return self;
}

- (void)dealloc {
	if (_socket >= 0) {
		close(_socket);
		_socket = -1;
	}
}

- (BOOL)connected {
	if (_socket < 0 || [self.IPAddress length] == 0 || self.port <= 0) {
		return NO;
	}
	struct sockaddr_in destination;
	memset(&destination, 0, sizeof(destination));
	if (inet_aton([self.IPAddress UTF8String] , &destination.sin_addr) == 0) {
		return NO;
	}
	return YES;
}

- (BOOL)sendData:(NSData *)data {
	return [self sendData:[data bytes] length:[data length]];
}

- (BOOL)sendData:(const void *)data length:(size_t)length {
	if (![self connected]) {
		return NO;
	}

	struct sockaddr_in destination;
	memset(&destination, 0, sizeof(destination));
	destination.sin_family = AF_INET;
	inet_aton([self.IPAddress UTF8String] , &destination.sin_addr);
	destination.sin_port = htons(self.port);
	return sendto(_socket, data, length, 0, (struct sockaddr *)&destination, sizeof(destination)) == length;
}

@end
