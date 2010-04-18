//
//  HandItem.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItem.h"

#import "Base64.h"

NSString *const HOItemPropertyKeyCommand = @"command";
NSString *const HOItemPropertyKeyTitle = @"title";
NSString *const HOItemPropertyKeyDescription = @"description";
NSString *const HOItemPropertyKeyIconData = @"icon";

NSString *const HOItemCommandTypeSong = @"song";
NSString *const HOItemCommandTypeWebpage = @"webpage";
NSString *const HOItemCommandTypeClipboard = @"clipboard";
NSString *const HOItemCommandTypeDocument = @"document";

@implementation HOItem

@synthesize command, itemIcon, itemTitle, itemDescription, properties, body;

- (id)initWithBLIPRequest:(BLIPRequest *)message
{		
	if (!(self = [super init])) return nil;
	
	BLIPProperties *props = [message properties];
	
	self.body = message.body;
	
	self.command = [props valueOfProperty:HOItemPropertyKeyCommand];
	
	NSString *iconDataString = [props valueOfProperty:HOItemPropertyKeyIconData];
	NSData *decodedData = [Base64 decode:iconDataString];
	self.itemIcon = [UIImage imageWithData:decodedData];
	
	self.itemTitle = [props valueOfProperty:HOItemPropertyKeyIconData];
	self.itemDescription = [props valueOfProperty:HOItemPropertyKeyDescription];
	
	NSMutableDictionary *restOfProperties = [[NSMutableDictionary alloc] initWithDictionary:[props allProperties]];
	[restOfProperties removeObjectsForKeys:[NSArray arrayWithObjects:HOItemPropertyKeyCommand,
											HOItemPropertyKeyTitle,
											HOItemPropertyKeyDescription,
											HOItemPropertyKeyIconData,
											nil]];
	
	return self;
}

- (BLIPRequest *)blipRequest {
	
	NSMutableDictionary *requestProperties = [NSMutableDictionary dictionary];
	[requestProperties setObject:self.command forKey:HOItemPropertyKeyCommand];
	[requestProperties setObject:self.itemTitle forKey:HOItemPropertyKeyTitle];
	[requestProperties setObject:self.itemDescription forKey:HOItemPropertyKeyDescription];
	[requestProperties setObject:self.itemIcon forKey:HOItemPropertyKeyIconData];
	[requestProperties addEntriesFromDictionary:self.properties];
	
	BLIPRequest *message = [BLIPRequest requestWithBody:self.body properties:requestProperties];
	
	return message;
}

- (void)dealloc {
	
	self.command = nil;
	self.itemIcon = nil;
	self.itemTitle = nil;
	self.itemDescription = nil;
	self.properties = nil;
	self.body = nil;
	
	[super dealloc];
}

@end
