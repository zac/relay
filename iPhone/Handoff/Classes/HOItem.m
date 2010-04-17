//
//  HandItem.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItem.h"


@implementation HOItem

@synthesize itemIcon, itemTitle, itemDescription, actionURL, context;

- (void)dealloc {
	
	self.itemIcon = nil;
	self.itemTitle = nil;
	self.itemDescription = nil;
	self.actionURL = nil;
	self.context = nil;
	
	[super dealloc];
}

@end
