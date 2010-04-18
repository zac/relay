//
//  HOConnectionChooser.h
//  Handoff
//
//  Created by Barry Burton on 4/18/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HONetwork.h"

@interface HOConnectionChooser : UITableViewController {
	HONetwork *network;
	NSArray *items;
}

@property (nonatomic, retain) HONetwork *network;
@property (nonatomic, retain) NSArray *items;

- (id) initWithNetwork: (HONetwork*)theNetwork;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
