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


@implementation HONetwork

@synthesize string, delegate, myServiceBrowser, serviceList;

- (id) initWithDelegate:(id <HONetworkDelegate>)theDelegate
{
	self = [super init];
    if (self != nil) {
		self.string = @"Opening listener socket...";
		
		myListener = [[BLIPListener alloc] initWithPort: 12345];
		myListener.delegate = self;
		myListener.pickAvailablePort = YES;
		myListener.bonjourServiceType = @"_blipecho._tcp";
		[myListener open];
		
		[self.myServiceBrowser start];
		
		self.delegate = theDelegate;
	}
	return self;
}

- (BOOL) sendMessage:(NSString*)message {
	if ( !myConnection ) {
		[self makeConnection];
	}
	
	BLIPRequest *r = [myConnection request];
    r.bodyString = message;
    BLIPResponse *response = [r send];
    if (response) {
		response.onComplete = $target(self,gotResponse:);
		
    }
	
	return YES;
}

/* Receive the response to the BLIP request */
- (void) gotResponse: (BLIPResponse*)response
{
	
}

- (MYBonjourBrowser*) myServiceBrowser {
    if (!myServiceBrowser)
        myServiceBrowser = [[MYBonjourBrowser alloc] initWithServiceType: @"_blipecho._tcp."];
    return myServiceBrowser;
}

- (NSArray*) serviceList {
    return [myServiceBrowser.services.allObjects sortedArrayUsingSelector: @selector(compare:)];
}

+ (NSArray*) keyPathsForValuesAffectingServiceList {
    return [NSArray arrayWithObject: @"serviceBrowser.services"];
}

- (void) makeConnection {
	if ( self.serviceList ) {
		MYBonjourService *service = [self.serviceList objectAtIndex:0];
		if ( service ) {
			[self openConnection: service];
			NSLog(@"%@", service.fullName);
		} else {
			NSLog(@"No Bonjour Found.");
		}
	} else {
		NSLog(@"No Bonjour Started.");
	}
}


#pragma mark BLIP Listener Delegate:


- (void) listenerDidOpen: (TCPListener*)listener
{
    self.string = [NSString stringWithFormat: @"Listening on port %i",listener.port];
}

- (void) listener: (TCPListener*)listener failedToOpen: (NSError*)error
{
    self.string = [NSString stringWithFormat: @"Failed to open listener on port %i: %@",
                  listener.port,error];
}

- (void) listener: (TCPListener*)listener didAcceptConnection: (TCPConnection*)connection
{
    self.string = [NSString stringWithFormat: @"Accepted connection from %@",
                  connection.address];
    connection.delegate = self;
}

#pragma mark BLIP Connection Delegate

- (void) connection: (TCPConnection*)connection failedToOpen: (NSError*)error
{
    self.string = [NSString stringWithFormat: @"Failed to open connection from %@: %@",
                  connection.address,error];
}

- (BOOL) connection: (BLIPConnection*)connection receivedRequest: (BLIPRequest*)request
{
    NSString *message = [[NSString alloc] initWithData: request.body encoding: NSUTF8StringEncoding];
    self.string = [NSString stringWithFormat: @"Echoed:\n“%@”",message];
	if ( self.delegate ) {
		[self.delegate messageReceived: self.string];
	}
    [request respondWithData: request.body contentType: request.contentType];
	return YES;
}

- (void) connectionDidClose: (TCPConnection*)connection;
{
    self.string = [NSString stringWithFormat: @"Connection closed from %@",
                  connection.address];
}



#pragma mark -
#pragma mark BLIPConnection support

/* Opens a BLIP connection to the given address. */
- (void)openConnection: (MYBonjourService*)service 
{
    //myConnection = [[BLIPConnection alloc] initToBonjourService: service];
	myConnection = [[BLIPConnection alloc] initToAddress:[[IPAddress alloc] initWithHostname:@"192.168.97.164" port:12345]];
    if( myConnection ) {
        myConnection.delegate = self;
        [myConnection open];
    }
}

/* Closes the currently open BLIP connection. */
- (void)closeConnection
{
    [myConnection close];
}

/** Called after the connection successfully opens. */
- (void) connectionDidOpen: (TCPConnection*)connection {
    if (myConnection==connection) {

    }
}

@end
