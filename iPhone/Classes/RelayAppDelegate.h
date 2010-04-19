//
//  RelayAppDelegate.h
//  Relay
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RelayViewController;

@interface RelayAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RelayViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RelayViewController *viewController;

@end

