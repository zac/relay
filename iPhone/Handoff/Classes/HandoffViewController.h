//
//  HandoffViewController.h
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandNetwork.h"

@interface HandoffViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate> {
	IBOutlet UITableView *leftTableView;
	IBOutlet UITableView *rightTableView;
	
	IBOutlet UITextField *textField;
	
	HandNetwork *network;
	
}

@property (nonatomic, retain) UITableView *leftTableView;
@property (nonatomic, retain) UITableView *rightTableView;

@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, retain) HandNetwork *network;

@end

