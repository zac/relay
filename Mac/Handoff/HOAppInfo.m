//
//  HOAppInfo.m
//  Handoff
//
//  Created by Daniel DeCovnick on 4/17/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import "HOAppInfo.h"

NSString *const kDraggedAppName = @"HODraggedAppName";
NSString *const kDraggedAppIdentifier = @"HODraggedAppIdentifier";
@implementation HOAppInfo
+(NSDictionary *)draggedAppInfo
{
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];
	NSDictionary *activeAppDict = [[NSWorkspace sharedWorkspace] activeApplication];
	NSString *strApplication = [activeAppDict objectForKey:@"NSApplicationName"];
	NSString *strApplicationBundleIdentifier = [activeAppDict objectForKey:@"NSApplicationBundleIdentifier"];
	[ret setObject:strApplicationBundleIdentifier forKey:kDraggedAppIdentifier];
	[ret setObject:strApplication forKey:kDraggedAppName];
	return ret;
}
@end
