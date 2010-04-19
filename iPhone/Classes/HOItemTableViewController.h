//
//  HOHandItemTableViewController.h
//  Relay
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HONetwork.h"


@interface HOItemTableViewController : UITableViewController <HONetworkDelegate> {
	NSMutableArray *builtInItems;
	NSMutableArray *items;
	
	HONetwork *networkController;
}

- (void)performActionForItem:(HOItem *)theItem;

@property (nonatomic, retain) HONetwork *networkController;
@property (nonatomic, retain) NSMutableArray *builtInItems;
@property (nonatomic, retain) NSMutableArray *items;

@end
