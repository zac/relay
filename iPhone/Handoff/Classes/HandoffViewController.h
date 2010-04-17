//
//  HandoffViewController.h
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HONetwork.h"

@class HOItemTableViewController;

@interface HandoffViewController : UIViewController {
	HOItemTableViewController *tableViewController;
	
	IBOutlet UITextField *textField;
	
	HONetwork *network;
}

@property (nonatomic, retain) HOItemTableViewController *tableViewController;

@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, retain) HONetwork *network;


@end

