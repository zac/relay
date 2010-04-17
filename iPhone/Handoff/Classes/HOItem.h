//
//  HandItem.h
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HOItem : NSObject {
	UIImage *itemIcon;
	NSString *itemTitle;
	NSString *itemDescription;
	
	NSURL *actionURL;
	NSData *context;
}

@property (nonatomic, retain) UIImage *itemIcon;
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *itemDescription;

@property (nonatomic, retain) NSURL *actionURL;
@property (nonatomic, copy) NSData *context;

@end
