//
//  UDPServer.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/16/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "UDPServer.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation UDPServer {
@private
	int _socket;
}

- (id)initWithPort:(int)port {
	if ((self = [super init])) {
		_port = port;
		_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		if (_socket >= 0 && port > 0) {
			struct sockaddr_in destination;
			memset(&destination, 0, sizeof(destination));
			destination.sin_family = AF_INET;
			destination.sin_addr.s_addr = htonl(INADDR_ANY);
			destination.sin_port = htons(self.port);
			if (bind(_socket, (struct sockaddr *)&destination, sizeof(destination) < 0)) {
				close(_socket);
				_socket = -1;
			}
		}
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
	if (_socket < 0 || self.port <= 0) {
		return NO;
	}
	return YES;
}

- (BOOL)receive {
	if (![self connected]) {
		return NO;
	}

	struct sockaddr_in destination;
	memset(&destination, 0, sizeof(destination));
	destination.sin_family = AF_INET;
	destination.sin_addr.s_addr = htonl(INADDR_ANY);
	destination.sin_port = htons(self.port);
	socklen_t dlength = sizeof(destination);

	static const int BUFLEN = 1024;
	char buf[BUFLEN];
	while(1) {
        if (recvfrom(_socket, buf, BUFLEN, 0, (struct sockaddr *)&destination, &dlength) < 0) {
			break;
        }
        printf("Received packet from %s:%d\n", inet_ntoa(destination.sin_addr), ntohs(destination.sin_port));
        printf("Data: %s\n" , buf);
    }
	return YES;
}

@end
