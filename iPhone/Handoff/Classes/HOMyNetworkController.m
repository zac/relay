//
//  hoMyNetworkController.m
//  Handoff
//
//  Created by Haseman on 4/16/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "hoMyNetworkController.h"
#import "BLIP.h"
#import "MYBonjourBrowser.h"


@implementation HOMyNetworkController

@synthesize delegate;

- (void)processIncomingData:(NSData*)data type:(NSString *)contentType
{
	NSMutableDictionary *dataSet = [[NSSet alloc]init];
	NSString *scrubData = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
	
	NSArray *chunks = [scrubData componentsSeparatedByString: @"\n"];
	for(int i=0; i<[chunks count]; i++)
	{
		NSString *line = [chunks objectAtIndex:i];
		NSArray *keyVal = [line componentsSeparatedByString: @":"];
		int count = [keyVal count];
		if(keyVal && [keyVal count] > 1)
		{
			NSString *key = (NSString*)[keyVal objectAtIndex:1];
			NSObject *obj = [self getData:key,contentType];
			[dataSet setValue:obj forKey:[keyVal objectAtIndex:0]];
		}
	}
	if(self.delegate)
	{
		[delegate gotDataPayload:dataSet];
	}
	[dataSet release];
	[scrubData release];
}


- (NSString *)processOutgoingData: (NSDictionary *)data type:(NSString *)contentType
{
	NSMutableString *outBuffer = [[NSMutableString alloc]init];
	for(id key in data)
	{
		NSString *dataString;
		if(contentType == @"text/plain")
		{
			dataString = [data objectForKey:key];
		}
		//Other content types here
		else {
			
		}
		
		//Base 64 encode it here
		
		[outBuffer appendString:key];
		[outBuffer appendString:@":"];
		[outBuffer appendString:dataString];
		[outBuffer appendString:@"\n"];
	}
	return outBuffer;
}


- (void) initConnection
{
	_listener = [[BLIPListener alloc] initWithPort: 31337];
    _listener.delegate = self;
    _listener.pickAvailablePort = YES;
    _listener.bonjourServiceType = @"_handoffecho._tcp";
    [_listener open];
	
	NSMutableDictionary *send = [[NSMutableDictionary alloc]init];
	NSString *key = @"url";
	NSString *value = @"http://cnn.com/";
	
	[send setValue:value forKey:key];
	NSString *data = [self processOutgoingData: send type:@"text/plain"];
	NSData *inData = [data dataUsingEncoding: NSUTF8StringEncoding];
	[self processIncomingData:inData type:@"text/plain"];
	
}

- (NSArray *)getAvailableDevices{
	
//NoOp for now.  I think we'll start by hardcoding the ip Addresses
}

- (void)dealloc
{
	[_listener close];
    [_listener release];
	[super dealloc];
}
-(NSObject *)getData:(NSString *)data: (NSString *)contentType
{
	if([contentType compare:@"text/plain"])
	{
		return data;
	}
	else {
		
	}

	return NULL;
}



#pragma mark BLIP Listener Delegate:

- (void) sendData:(NSString *)data
{
}
- (void) sendString:(NSString *)data
{
}
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
	[self processIncomingData:request.body,request.contentType];
}

- (void) connectionDidClose: (TCPConnection*)connection;
{
	//label.text = [NSString stringWithFormat: @"Connection closed from %@",
				  //connection.address];
}
@end
