//
//  HandItem.h
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const HOItemPropertyKeyCommand;
NSString *const HOItemPropertyKeyTitle;
NSString *const HOItemPropertyKeyDescription;
NSString *const HOItemPropertyKeyIconData;

NSString *const HOItemCommandTypeSong;
NSString *const HOItemCommandTypeWebpage;
NSString *const HOItemCommandTypeClipboard;
NSString *const HOItemCommandTypeDocument;

#import "BLIP.h"

@interface HOItem : NSObject {
	UIImage *itemIcon;
	
	NSString *command;
	
	NSString *itemTitle;
	NSString *itemDescription;
	
	NSDictionary *properties;
	
	NSData *body;
}

- (id)initWithBLIPRequest: (BLIPRequest *)message;
- (BLIPRequest *)blipRequest;


@property (nonatomic, retain) UIImage *itemIcon;

@property (nonatomic, copy) NSString *command;

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *itemDescription;

@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic, copy) NSData *body;

@end
