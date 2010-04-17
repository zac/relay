//
//  HandoffAppDelegate.h
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandoffViewController;

@interface HandoffAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HandoffViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HandoffViewController *viewController;

@end

