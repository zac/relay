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

@end


@interface HONetwork : NSObject <TCPListenerDelegate, BLIPConnectionDelegate> {

	NSString *string;
	
    BLIPListener *myListener;
    MYBonjourBrowser *myServiceBrowser;
    BLIPConnection *myConnection;
	
	NSArray *serviceList;
	
	id <HONetworkDelegate> delegate;
	
}

@property (nonatomic, copy) NSString *string;

@property (nonatomic, retain) id <HONetworkDelegate> delegate;

@property (readonly) MYBonjourBrowser *myServiceBrowser;

@property (readonly) NSArray *serviceList;

- (id) initWithDelegate:(id <HONetworkDelegate>)delegate;

- (BOOL) sendItem:(HOItem *)item;

- (void) gotResponse: (BLIPResponse*)response;

- (void) makeConnection;

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
