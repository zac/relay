//
//  HOItemTableViewCell.h
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOItem;

@interface HOItemTableViewCell : UITableViewCell {
	HOItem *item;
}

@property (nonatomic, retain) HOItem *item;

- (void)setItem:(HOItem *)theItem;
- (UIWindow *)windowForCell;

@end
