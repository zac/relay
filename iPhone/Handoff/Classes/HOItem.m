//
//  HandItem.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItem.h"

NSString *const HOItemCommandTypeSong = @"song";
NSString *const HOItemCommandTypeWebpage = @"webpage";
NSString *const HOItemCommandTypeClipboard = @"clipboard";
NSString *const HOItemCommandTypeDocument = @"document";

@implementation HOItem

@synthesize command, itemIcon, itemTitle, itemDescription, properties, body;

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
