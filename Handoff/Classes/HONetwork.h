//
//  HONetwork.h
//  Handoff
//
//  Created by Barry Burton on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLIPConnection.h"
#import "MYBonjourBrowser.h"

@class HONetwork, HOItem;

@protocol HONetworkDelegate

- (void)network:(HONetwork *)theNetwork didReceiveItem:(HOItem *)theItem;

- (void)didDropConnectionOnNetwork:(HONetwork *)theNetwork;

- (void)network:(HONetwork *)theNetwork didReceiveResponse:(BLIPResponse *)theResponse;

@end


@interface HONetwork : NSObject <TCPListenerDelegate, BLIPConnectionDelegate> {
	
	NSArray *relayOptions;
	
	MYBonjourBrowser *theServiceBrowser;
    BLIPListener *theListener;
    BLIPConnection *theConnection;
	
	NSObject<HONetworkDelegate> *delegate;
}

@property (nonatomic, retain) NSArray *relayOptions;

@property (nonatomic, retain) MYBonjourBrowser *theServiceBrowser;

@property (nonatomic, retain) BLIPListener *theListener;

@property (nonatomic, retain) BLIPConnection *theConnection;

@property (nonatomic, retain) NSObject<HONetworkDelegate> *delegate;

- (id) initWithDelegate:(NSObject<HONetworkDelegate> *)delegate;

- (BOOL) isConnected;

- (BOOL) sendItem:(HOItem *)item;

- (void) gotResponse: (BLIPResponse*)response;

/* Opens a BLIP connection to the given address. */
- (void)openConnection: (MYBonjourService*)service;

/* Closes the currently open BLIP connection. */
- (void)closeConnection;

/** Called after the connection successfully opens. */
- (void) connectionDidOpen: (TCPConnection*)connection;

/** Called after the connection fails to open due to an error. */
- (void) connection: (TCPConnection*)connection failedToOpen: (NSError*)error;

/** Called after the connection closes. */
- (void) connectionDidClose: (TCPConnection*)connection;


@end
