//
//  RelayAppInfo.m
//  Relay
//
//  Created by Daniel DeCovnick on 4/17/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import "RelayAppInfo.h"
#import "Safari.h"
#import "iTunes.h"
#import "HOItem.h"
#import "Base64.h"
#import <ScriptingBridge/ScriptingBridge.h>

NSString *const kDraggedAppName = @"HODraggedAppName";
NSString *const kDraggedAppIdentifier = @"HODraggedAppIdentifier";
@implementation RelayAppInfo
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
		
		NSInteger index = 0;
		for (SafariTab *tab in tabs)
		{
			[tabURLs addObject:[tab URL]];
			[properties setObject:[tab URL] forKey:[NSString stringWithFormat:@"actionURL%d", index]];
			index++;
		}
		[properties setObject:[tabURLs objectAtIndex:0] forKey:@"actionURL"];
		
		ret.command = HOItemCommandTypeWebpage;
		ret.itemTitle = @"Webpage";
		ret.itemDescription = [tabURLs objectAtIndex:0];
	}
	else if ([strApplicationBundleIdentifier isEqualToString:@"com.apple.iTunes"])
	{
		ret.command = HOItemCommandTypeSong;
		ret.itemTitle = @"Current iTunes Song";
		NSDictionary *iTunesProperties = [self iTunesProperties];
		ret.itemDescription = [NSString stringWithFormat:@"%@ by %@",
							   [iTunesProperties objectForKey:@"track"],
							   [iTunesProperties objectForKey:@"artist"]];
		[properties addEntriesFromDictionary:iTunesProperties];
	}
	ret.properties = properties;

	return ret;
}

+(NSDictionary *)iTunesProperties
{
	NSMutableDictionary *props = [NSMutableDictionary dictionary];
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	iTunesTrack *track = [iTunes currentTrack];
	
	SBElementArray *artworks = [track artworks];
	
	NSImage *mainArtwork = nil;
	if ([artworks count]) {
		mainArtwork = [(iTunesArtwork *)[artworks objectAtIndex:0] data];
	}
	
	/* Get a smaller version of the image to send over the wire. */
	if (mainArtwork) {
		CGFloat resizeWidth = 45.0;
		CGFloat resizeHeight = 45.0;
		
		NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
		
		NSSize originalSize = [mainArtwork size];
		
		[resizedImage lockFocus];
		[mainArtwork drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight)
					   fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height)
					  operation: NSCompositeSourceOver
					   fraction: 1.0];
		[resizedImage unlockFocus];
		
		NSData *resizedData = [resizedImage TIFFRepresentation];
		
		[props setObject:[Base64 encode:resizedData] forKey:HOItemPropertyKeyIconData];
		
		[resizedImage release];
	}
	
	iTunesEPlS playerState = [iTunes playerState];
	
	NSString *playingString = @"1";
	if (playerState == iTunesEPlSStopped || playerState == iTunesEPlSPaused){
		playingString = @"0";
	}
	
	NSInteger seconds = [iTunes playerPosition];
	[props setObject:[track artist] forKey:@"artist"];
	[props setObject:[track name] forKey:@"track"];
	[props setObject:[NSString stringWithFormat:@"%d",seconds] forKey:@"seconds"];
	[props setObject:playingString forKey:@"playbackState"];
	
	return props;
}
@end
