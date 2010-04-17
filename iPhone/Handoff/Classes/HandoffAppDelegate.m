//
//  HandoffAppDelegate.m
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import "HandoffAppDelegate.h"
#import "HandoffViewController.h"

@implementation HandoffAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
