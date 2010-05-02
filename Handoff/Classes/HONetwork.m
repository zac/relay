//
//  HONetwork.m
//  Handoff
//
//  Created by Barry Burton on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HONetwork.h"
#import "MYBonjourService.h"
#import "IPAddress.h"
#import "BLIP.h"
#import "Target.h"
#import "MYDNSService.h"
#import "MYBonjourBrowser.h"
#import "MYAddressLookup.h"
#import "CollectionUtils.h"

#import "HOItem.h"

#define kHandOffBonjourType @"_handoff-blip._tcp"
#define kHandOffPortStart 12345

@implementation HONetwork

@synthesize relayOptions;

@synthesize theServiceBrowser, theListener, theConnection, delegate;

- (id) initWithDelegate:(NSObject<HONetworkDelegate> *)theDelegate
{
	self = [super init];
    if (self != nil) {
		self.delegate = theDelegate;
		
		self.theServiceBrowser = [[MYBonjourBrowser alloc] initWithServiceType: kHandOffBonjourType];
		
		NSLog(@"Browser Start? %d", [self.theServiceBrowser start]);
		
		self.relayOptions = [NSArray array];
		
		[self.theServiceBrowser addObserver: self forKeyPath: @"services" options: NSKeyValueObservingOptionNew context: nil];
		
		self.theListener = [[BLIPListener alloc] initWithPort: kHandOffPortStart];
		self.theListener.delegate = self;
		self.theListener.pickAvailablePort = YES;
		self.theListener.bonjourServiceType = kHandOffBonjourType;
		NSLog(@"Listener Open? %d", [self.theListener open]);
 
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( $equal(keyPath,@"services") ) {
		NSLog(@"Services Change.");
        /* if( [[change objectForKey: NSKeyValueChangeKindKey] intValue]==NSKeyValueChangeInsertion ) { */
            NSSet *newServices = [change objectForKey: NSKeyValueChangeNewKey];
			
			for( MYBonjourService *service in newServices ) {
				service.addressLookup.continuous = YES;
				[service.addressLookup addObserver: self
									forKeyPath: @"addresses"
									   options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
									   context: NULL];
			}
			self.relayOptions = [[self.theServiceBrowser.services allObjects] sortedArrayUsingSelector: @selector(compare:)];
       /*} */
    }
}

- (BOOL) isConnected {
	if ( theConnection ) {
		return YES;
	}
	return NO;
}

- (BOOL) sendItem:(HOItem *)item {
	
	NSLog(@"Send Item!");
	
	if ( self.theConnection ) {
		BLIPRequest *requestToSend = [item blipRequest];
		[requestToSend setConnection:self.theConnection];
		
		BLIPResponse *response = [requestToSend send];
		if (response) {
			response.onComplete = $target(self,gotResponse:);
		}
	}
	
	return YES;
}

/* Receive the response to the BLIP request */
- (void) gotResponse: (BLIPResponse*)response
{
	if ( [self.delegate respondsToSelector:@selector(network:didReceiveResponse:)]) {
		[self.delegate network:self didReceiveResponse:response];
	}
}

#pragma mark BLIP Listener Delegate:


- (void) listenerDidOpen: (TCPListener*)listener
{
    NSLog(@"Listening on port %i",listener.port);
}

- (void) listener: (TCPListener*)listener failedToOpen: (NSError*)error
{
    NSLog(@"Failed to open listener on port %i: %@", listener.port,error);
}

- (void) listener: (TCPListener*)listener didAcceptConnection: (TCPConnection*)connection
{
    NSLog(@"Accepted connection from %@", connection.address);
    connection.delegate = self;
	self.theConnection = (BLIPConnection*)connection;
}

#pragma mark BLIP Connection Delegate

- (void) connection: (TCPConnection*)connection failedToOpen: (NSError*)error
{
    NSLog(@"Failed to open connection from %@: %@", connection.address,error);
	[self.delegate didDropConnectionOnNetwork: self];
	
}

- (BOOL) connection: (BLIPConnection*)connection receivedRequest: (BLIPRequest*)request
{
	NSArray *allItems = nil;
	NSLog(@"Received Request!");
	if ([[[[request properties] allProperties] objectForKey:@"command"] isEqualToString:HOItemCommandTypeWebpage]) {
		//do something special.
		NSLog(@"blah: %@", [[request properties] allProperties]);
		allItems = [HOItem itemsWithBLIPRequest:request];
		
		for (HOItem *item in allItems) {
			if ( self.delegate ) {
				[self.delegate network:self didReceiveItem:item];
			}
		}
		
	} else {
		HOItem *theItem = [[HOItem alloc] initWithBLIPRequest:request];
		
		if ( self.delegate ) {
			[self.delegate network:self didReceiveItem:theItem];
		}
	}
	
	return YES;
}

- (void) connectionDidClose: (TCPConnection*)connection;
{
    NSLog(@"Connection closed from %@", connection.address);
	if ( self.delegate ) {
		[self.delegate didDropConnectionOnNetwork: self];
	}
}



#pragma mark -
#pragma mark BLIPConnection support

/* Opens a BLIP connection to the given address. */
- (void)openConnection: (MYBonjourService*)service 
{
    self.theConnection = [[BLIPConnection alloc] initToBonjourService: service];

    if( self.theConnection ) {
        self.theConnection.delegate = self;
        [self.theConnection open];
    }
}

/* Closes the currently open BLIP connection. */
- (void)closeConnection
{
    [theConnection close];
	theConnection = nil;
}

/** Called after the connection successfully opens. */
- (void) connectionDidOpen: (TCPConnection*)connection {
    if (theConnection==connection) {

    }
}

@end
