//
//  HOHandItemTableViewController.h
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HOItemTableViewController : UITableViewController {
	NSMutableArray *items;
}

@property (nonatomic, retain) NSMutableArray *items;

@end
