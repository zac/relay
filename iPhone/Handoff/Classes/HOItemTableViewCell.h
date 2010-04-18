//
//  HOItemTableViewCell.h
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOItem, HOItemTableViewController;

@interface HOItemTableViewCell : UITableViewCell {
	HOItem *item;
	
	HOItemTableViewController *parentController;
	
	UIButton *actionButton;
}

@property (nonatomic, assign) HOItemTableViewController *parentController;

@property (nonatomic, retain) HOItem *item;
@property (nonatomic, retain) UIButton *actionButton;

- (void)hideContents;
- (void)showContents;

- (void)setItem:(HOItem *)theItem;
- (UIWindow *)windowForCell;

@end
