//
//  RelayViewController.h
//  Relay
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOItemTableViewController;

@interface RelayViewController : UIViewController {
	HOItemTableViewController *tableViewController;

	UITextField *textField;
}

@property (nonatomic, retain) HOItemTableViewController *tableViewController;

@property (nonatomic, retain) UITextField *textField;

@end

