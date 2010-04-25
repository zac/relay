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

@implementation HONetwork

@synthesize theServiceList, theServiceBrowser, theListener, theConnection;

- (id) initWithDelegate:(NSObject<HONetworkDelegate> *)theDelegate
{
	self = [super init];
    if (self != nil) {
		self.delegate = theDelegate;
		
		myListener = [[[BLIPListener alloc] initWithPort: 12345] autorelease];
		myListener.delegate = self;
		myListener.pickAvailablePort = YES;
		myListener.bonjourServiceType = @"_handoffblip._tcp";
		[myListener open];
		
		self.theServiceBrowser = [[[MYBonjourBrowser alloc] initWithServiceType: @"__handoffblip._tcp."] autorelease];
		
		[self.theServiceBrowser addObserver: self forKeyPath: @"services" options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context: NULL];
		
		[self.theServiceBrowser start];
		
		self.theServiceList = [NSArray array];
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( $equal(keyPath,@"services") ) {
        if( [[change objectForKey: NSKeyValueChangeKindKey] intValue]==NSKeyValueChangeInsertion ) {
            NSSet *newServices = [change objectForKey: NSKeyValueChangeNewKey];
            for( MYBonjourService *service in newServices ) {
                NSLog(@"##### %@ : at %@:%hu, TXT=%@", 
					service, service.hostname, service.port, service.txtRecord);
                service.addressLookup.continuous = YES;
                [service.addressLookup addObserver: self
                                        forKeyPath: @"addresses"
                                           options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                           context: NULL];
                //[service queryForRecord: kDNSServiceType_NULL];
            }
			self.theServiceList = [[newServices.allObjects sortedArrayUsingSelector: @selector(compare:)] copy];
        }
    }
}

- (BOOL) isConnected {
	if ( myConnection ) {
		return YES;
	}
	return NO;
}

- (BOOL) sendItem:(HOItem *)item {
	
	BLIPRequest *requestToSend = [item blipRequest];
	[requestToSend setConnection:myConnection];
	
    BLIPResponse *response = [requestToSend send];
    if (response) {
		response.onComplete = $target(self,gotResponse:);
		
    }
	
	[self closeConnection];
	
	return YES;
}

/* Receive the response to the BLIP request */
- (void) gotResponse: (BLIPResponse*)response
{
	if ( [self.delegate respondsToSelector:@selector(network:didReceiveResponse:)]) {
		[self.delegate network:self didReceiveResponse:response];
	}
}

+ (NSArray*) keyPathsForValuesAffectingServiceList {
    return [NSArray arrayWithObject: @"serviceBrowser.services"];
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
    //myConnection = [[BLIPConnection alloc] initToBonjourService: service];
	myConnection = [[BLIPConnection alloc] initToAddress:[[IPAddress alloc] initWithHostname:@"192.168.99.214" port:12345]];
    if( myConnection ) {
        myConnection.delegate = self;
        [myConnection open];
    }
}

/* Closes the currently open BLIP connection. */
- (void)closeConnection
{
    [myConnection close];
	myConnection = nil;
}

/** Called after the connection successfully opens. */
- (void) connectionDidOpen: (TCPConnection*)connection {
    if (myConnection==connection) {

    }
}

@end
