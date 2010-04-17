//
//  HandoffViewController.h
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandNetwork.h"

@class HOItemTableViewController;

@interface HandoffViewController : UIViewController {
	HOItemTableViewController *tableViewController;

	IBOutlet UITextField *textField;
	
	HandNetwork *network;
}

@property (nonatomic, retain) HOItemTableViewController *tableViewController;

@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, retain) HandNetwork *network;


@end

