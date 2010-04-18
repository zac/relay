//
//  HandItem.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItem.h"

#import "Base64.h"

NSString *const HOTypeCommand = @"command";
NSString *const HOTypeActionUrl = @"webpage";
NSString *const HOTypeTitle = @"title";
NSString *const HOTypeDescription = @"description";
NSString *const HOTypeIconData = @"icon";

NSString *const HOItemCommandTypeSong = @"song";
NSString *const HOItemCommandTypeWebpage = @"webpage";
NSString *const HOItemCommandTypeClipboard = @"clipboard";
NSString *const HOItemCommandTypeDocument = @"document";

@implementation HOItem

@synthesize command, itemIcon, itemTitle, itemDescription, properties, body;



- (id)initWithBLIPRequest:(BLIPRequest *)request
{
	if (!(self = [super init])) return nil;
	
	BLIPProperties *props = [request properties];
	
	self.body = request.body;
	
	self.command = [props valueOfProperty:HOTypeCommand];
	
	NSString *iconDataString = [props valueOfProperty:HOTypeIconData];
	NSData *decodedData = [Base64 decode:iconDataString];
	self.itemIcon = [UIImage imageWithData:decodedData];
	
	self.itemTitle = [props valueOfProperty:HOTypeTitle];
	self.itemDescription = [props valueOfProperty:HOTypeDescription];
	
	NSMutableDictionary *restOfProperties = [[NSMutableDictionary alloc] initWithDictionary:[props allProperties]];
	[restOfProperties removeObjectsForKeys:[NSArray arrayWithObjects:HOTypeCommand, HOTypeTitle, HOTypeDescription, HOTypeIconData, nil]];
	self.properties = restOfProperties;
	return self;
}
- (id)initWithBLIPMessage:(BLIPMessage *)message
{		
	if (!(self = [super init])) return nil;
	
	BLIPProperties *props = [message properties];
	
	self.body = message.body;
	
	self.command = [props valueOfProperty:HOTypeCommand];
	
	NSString *iconDataString = [props valueOfProperty:HOTypeIconData];
	NSData *decodedData = [Base64 decode:iconDataString];
	self.itemIcon = [UIImage imageWithData:decodedData];
	
	self.itemTitle = [props valueOfProperty:HOTypeIconData];
	self.itemDescription = [props valueOfProperty:HOTypeDescription];
	
	NSMutableDictionary *restOfProperties = [[NSMutableDictionary alloc] initWithDictionary:[props allProperties]];
	[restOfProperties removeObjectsForKeys:[NSArray arrayWithObjects:HOTypeCommand, HOTypeTitle, HOTypeDescription, HOTypeIconData, nil]];
	
	return self;
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


- (BLIPProperties *)getBLIPProperties
{
	return nil;
}

@end
