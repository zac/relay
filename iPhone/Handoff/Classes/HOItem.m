//
//  HandItem.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItem.h"

NSString *const HOTypeCommand = @"command";
NSString *const HOTypeActionUrl = @"webpage";
NSString *const HOTypeIconData = @"iconData";

NSString *const HOItemCommandTypeSong = @"song";
NSString *const HOItemCommandTypeWebpage = @"webpage";
NSString *const HOItemCommandTypeClipboard = @"clipboard";
NSString *const HOItemCommandTypeDocument = @"document";

@implementation HOItem

@synthesize command, itemIcon, itemTitle, itemDescription, properties, body, actionUrl;

- (void)dealloc {
	
	self.command = nil;
	self.itemIcon = nil;
	self.itemTitle = nil;
	self.itemDescription = nil;
	self.properties = nil;
	self.body = nil;
	self.actionUrl = nil;
	
	[super dealloc];
}
- (id)initWithBLIPMessage:(BLIPMessage *)message
{
	BLIPProperties *props = [message properties];
	
	self.body = message.body;
	
	self.command = [props valueOfProperty:HOTypeCommand];
	
	//String iconData = [props valueOfProperty:HOTypeIconData];
	//self.itemIcon = 
	
	if(self.command == HOItemCommandTypeSong)
	{
		
	}
	else if(command == HOItemCommandTypeWebpage)
	{
		self.actionUrl = [props valueOfProperty:HOTypeActionUrl];
	}
}

@end
