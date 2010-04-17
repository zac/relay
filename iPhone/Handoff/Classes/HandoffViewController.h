//
//  HandoffViewController.h
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandoffViewController : UIViewController <UITableViewDataSource> {
	IBOutlet UITableView *leftTableView;
	IBOutlet UITableView *rightTableView;
}

@property (nonatomic, retain) UITableView *leftTableView;
@property (nonatomic, retain) UITableView *rightTableView;

@end

