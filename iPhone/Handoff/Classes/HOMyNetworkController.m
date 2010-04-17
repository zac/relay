//
//  hoMyNetworkController.m
//  Handoff
//
//  Created by Haseman on 4/16/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "hoMyNetworkController.h"


@implementation hoMyNetworkController



#pragma mark BLIP Listener Delegate:

- (void) listenerDidOpen: (TCPListener*)listener
{
	//label.text = [NSString stringWithFormat: @"Listening on port %i",listener.port];
}

- (void) listener: (TCPListener*)listener failedToOpen: (NSError*)error
{
	//label.text = [NSString stringWithFormat: @"Failed to open listener on port %i: %@",
	//			  listener.port,error];
}

- (void) listener: (TCPListener*)listener didAcceptConnection: (TCPConnection*)connection
{
	//label.text = [NSString stringWithFormat: @"Accepted connection from %@",
	//			  connection.address];
	//connection.delegate = self;
}

- (void) connection: (TCPConnection*)connection failedToOpen: (NSError*)error
{
	//label.text = [NSString stringWithFormat: @"Failed to open connection from %@: %@",
	//			  connection.address,error];
}

- (void) connection: (BLIPConnection*)connection receivedRequest: (BLIPRequest*)request
{
	//NSString *message = [[NSString alloc] initWithData: request.body encoding: NSUTF8StringEncoding];
	//label.text = [NSString stringWithFormat: @"Echoed:\n“%@”",message];
	//[request respondWithData: request.body contentType: request.contentType];
	//[message release];
}

- (void) connectionDidClose: (TCPConnection*)connection;
{
	//label.text = [NSString stringWithFormat: @"Connection closed from %@",
				  //connection.address];
}
@end
