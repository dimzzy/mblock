//
//  ViewController.m
//  MBlock
//
//  Created by Dmitry Stadnik on 12/14/12.
//  Copyright (c) 2012 Dmitry Stadnik. All rights reserved.
//

#import "ViewController.h"
#import "UDPClientCell.h"
#import "SignalServiceCell.h"
#import "UITableView+BALoading.h"
#import "BAKeyboardTracker.h"
#import "AppDelegate.h"
#import "MUserPreferences.h"

static const NSInteger kIPAddressViewTag = 101;
static const NSInteger kPortViewTag = 102;

@interface ViewController ()

@property(readonly) NSArray *signalServices;

@end

@implementation ViewController {
@private
	BAKeyboardTracker *_keyboardTracker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.IPAddress = [MUserPreferences instance].IPAddress;
	self.port = [MUserPreferences instance].port;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_keyboardTracker = [[BAKeyboardTracker alloc] init];
	_keyboardTracker.scrollView = self.tableView;
}

- (void)viewDidDisappear:(BOOL)animated {
	_keyboardTracker = nil;
	[super viewDidDisappear:animated];
}

- (NSArray *)signalServices {
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return appd.signalServices;
}

- (void)textDidChange:(UITextField *)textField {
	if (textField.tag == kIPAddressViewTag) {
		self.IPAddress = textField.text;
		[MUserPreferences instance].IPAddress = self.IPAddress;
	} else if (textField.tag == kPortViewTag) {
		self.port = [textField.text intValue];
		[MUserPreferences instance].port = self.port;
	}
}

- (IBAction)connect:(UISwitch *)sender {
	AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
	if (sender.on) {
		UDPClient *client = [[UDPClient alloc] initWithIPAddress:self.IPAddress port:self.port];
		if (!client.connected) {
			sender.on = NO;
			return;
		}
		appd.dataClient = client;
	} else {
		appd.dataClient = nil;
	}
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)startStopSignalService:(UISwitch *)sender {
	SignalService *signalService = [self.signalServices objectAtIndex:sender.tag];
	if (sender.on) {
		[signalService start];
	} else {
		[signalService stop];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else if (section == 1) {
		return [self.signalServices count];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			BOOL loaded = NO;
			UDPClientCell *cell = (UDPClientCell *)[tableView dequeueOrLoadReusableCellWithClass:[UDPClientCell class]
																						  loaded:&loaded];
			if (loaded) {
				cell.IPAddressView.tag = kIPAddressViewTag;
				[cell.IPAddressView addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
				cell.portView.tag = kPortViewTag;
				[cell.portView addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
				[cell.connectedView addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
			}
			cell.IPAddressView.text = self.IPAddress;
			cell.portView.text = [NSString stringWithFormat:@"%d", self.port];
			AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
			cell.connectedView.on = appd.dataClient.connected;
			return cell;
		}
	} else if (indexPath.section == 1) {
		SignalService *signalService = [self.signalServices objectAtIndex:indexPath.row];
		BOOL loaded = NO;
		SignalServiceCell *cell = (SignalServiceCell *)[tableView dequeueOrLoadReusableCellWithClass:[SignalServiceCell class]
																							  loaded:&loaded];
		if (loaded) {
			[cell.runningView addTarget:self action:@selector(startStopSignalService:) forControlEvents:UIControlEventTouchUpInside];
		}
		cell.titleView.text = signalService.info;
		cell.runningView.tag = indexPath.row;
		cell.runningView.on = signalService.running;
		AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
		cell.runningView.enabled = appd.dataClient.connected;
		return cell;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return kUDPClientCellHeight;
		}
	} else if (indexPath.section == 1) {
		return kSignalServiceCellHeight;
	}
	return 0;
}

@end
