//
//  HOAppInfo.m
//  Handoff
//
//  Created by Daniel DeCovnick on 4/17/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import "HOAppInfo.h"
#import "Safari.h"
#import "iTunes.h"
#import "HOItem.h"
#import <ScriptingBridge/ScriptingBridge.h>

NSString *const kDraggedAppName = @"HODraggedAppName";
NSString *const kDraggedAppIdentifier = @"HODraggedAppIdentifier";
@implementation HOAppInfo
+(HOItem *)draggedAppInfo
{
	HOItem *ret = [[HOItem alloc] init];
	NSMutableDictionary *properties = [NSMutableDictionary dictionary];
	NSDictionary *activeAppDict = [[NSWorkspace sharedWorkspace] activeApplication];
	//NSString *strApplication = [activeAppDict objectForKey:@"NSApplicationName"];
	NSString *strApplicationBundleIdentifier = [activeAppDict objectForKey:@"NSApplicationBundleIdentifier"];
	//[ret setObject:strApplicationBundleIdentifier forKey:kDraggedAppIdentifier];
	//[ret setObject:strApplication forKey:kDraggedAppName];
	if ([strApplicationBundleIdentifier isEqualToString:@"com.apple.Safari"])
	{
		/*NSAppleScript *tabInfoScript = [[NSAppleScript alloc] initWithSource:
@"set url_list to {}\n \
tell application \"Safari\"\n\
	set safariWindow to window 1\n\
	try\n\
		repeat with t in (tabs of safariWindow)\n\
			set TabURL to (URL of t)\n\
			copy TabURL to the end of url_list\n\
		end repeat\n\
	end try\n\
end tell\n\
url_list"
										];
		NSAppleEventDescriptor  *returnDescriptor;
		returnDescriptor = [tabInfoScript executeAndReturnError:nil];
		[tabInfoScript release];
		if([returnDescriptor descriptorType])
		{
			if(kAENullEvent != [returnDescriptor descriptorType])
			{
				// Apple Events send back a descriptor.  Turn it into an NSArray.
				returnDescriptor = [returnDescriptor
									coerceToDescriptorType:typeCFArrayRef];
				NSArray *urlArray = [NSArray arrayWithArray:(NSArray *)returnDescriptor];
				NSLog(@"urlArray: %@", urlArray);
			}
		}*/
		SafariApplication *safari = [SBApplication applicationWithBundleIdentifier:@"com.apple.Safari"];
		SBElementArray *windows = [safari windows];
		SafariWindow *window = [windows objectAtIndex:0];
		SBElementArray *tabs = [window tabs];
		NSMutableArray *tabURLs = [NSMutableArray arrayWithCapacity:[tabs count]];
		for (SafariTab *tab in tabs)
		{
			[tabURLs addObject:[tab URL]];
		}
		[properties setObject:[tabURLs objectAtIndex:0] forKey:@"actionURL"];
		ret.properties = properties;
		
		ret.command = HOItemCommandTypeWebpage;
		ret.itemTitle = @"Webpage";
		ret.itemDescription = [tabURLs objectAtIndex:0];
	}
	else if ([strApplicationBundleIdentifier isEqualToString:@"com.apple.iTunes"])
	{
		[properties addEntriesFromDictionary:[self iTunesProperties]];
	}
	ret.properties = properties;

	return ret;
}
+(NSDictionary *)iTunesProperties
{
	NSMutableDictionary *props = [NSMutableDictionary dictionary];
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	iTunesTrack *track = [iTunes currentTrack];
	NSInteger seconds = [iTunes playerPosition];
	[props setObject:[track artist] forKey:@"artist"];
	[props setObject:[track name] forKey:@"track"];
	[props setObject:[NSNumber numberWithInt:seconds] forKey:@"seconds"];
	return props;
}
@end
