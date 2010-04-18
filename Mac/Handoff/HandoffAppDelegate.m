//
//  HandoffAppDelegate.m
//  Handoff
//
//  Created by Daniel DeCovnick on 4/16/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import "HandoffAppDelegate.h"
#import "PTHotKey.h"
#import "PTHotKeyCenter.h"
#import "PTKeyCombo.h"
#import <ApplicationServices/ApplicationServices.h>
#import "HOAppInfo.h"
#import "HOItem.h"

CGEventRef CheckForMouseupInTargetArea(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon);
static CGEventType lastEventType = 0;
NSString *const kScreenEdgeChoiceKey = @"ScreenEdgeChoiceKey";
@implementation HandoffAppDelegate
@synthesize lastKey;
@synthesize lastCombo;
@synthesize network;

-(void)awakeFromNib
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[statusItem setHighlightMode:YES];
	[statusItem setToolTip:@"Handoff"];
	[statusItem setEnabled:YES];
	[statusItem setImage:[NSImage imageNamed:@"NSActionTemplate"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"NSActionTemplate"]];
	[statusItem setTarget:self];
	[statusItem setAction:@selector(showPrefsWindow:)];
	[statusItem setMenu:statusMenu];
	screenEdgeChoiceValue = [[NSUserDefaults standardUserDefaults] integerForKey:kScreenEdgeChoiceKey];
	[screenEdgeChoice selectItemAtIndex:screenEdgeChoiceValue];
	CFMachPortRef eventTap = CGEventTapCreate (
									kCGSessionEventTap,
									kCGTailAppendEventTap,
									kCGEventTapOptionListenOnly,
									CGEventMaskBit(kCGEventLeftMouseUp) | CGEventMaskBit(kCGEventLeftMouseDragged),
									CheckForMouseupInTargetArea,
									self
	);
	CFRunLoopSourceRef source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetMain(), source, kCFRunLoopCommonModes);
	network = [[HONetwork alloc] initWithDelegate:self];

}
-(IBAction)setChoice:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[sender indexOfSelectedItem] forKey:kScreenEdgeChoiceKey];
}
-(IBAction)showPrefsWindow:(id)sender
{
	[preferencesWindow makeKeyAndOrderFront:sender];
}
- (void)network:(HONetwork *)theNetwork didReceiveItem:(HOItem *)theItem
{
	return; //TODO: later
}
-(void)hideFrontmostApp
{
	NSAppleScript *hideScript = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"h\" using command down"];
	[hideScript executeAndReturnError:NULL];
	return;
}
-(void)dealloc
{
	[statusItem release];
	[network release];
	[super dealloc];
}
@end
CGEventRef CheckForMouseupInTargetArea(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
	HandoffAppDelegate *self = (HandoffAppDelegate *)refcon;
	if (lastEventType != kCGEventLeftMouseDragged && type != kCGEventLeftMouseDragged)
	{
		lastEventType = type;
		return NULL;
	}
	if (lastEventType != kCGEventLeftMouseDragged && type == kCGEventLeftMouseDragged)
	{
		lastEventType = type;
		return NULL;
	}
	if (type == kCGEventLeftMouseUp)
	{
		lastEventType = type;
		CGPoint mouseUpPoint = CGEventGetUnflippedLocation(event);
		NSPoint nsMouseUpPoint;
		nsMouseUpPoint.x = mouseUpPoint.x;
		nsMouseUpPoint.y = mouseUpPoint.y;
		NSRect screenRect = [[NSScreen mainScreen] frame];
		NSRect targetRect;
		switch ([[NSUserDefaults standardUserDefaults] integerForKey:kScreenEdgeChoiceKey])
		{
				//case screenEdgeTopChoice:
				//	targetRect = NSMakeRect(screenRect.origin.x+50.0, screenRect.size.height-22.0, screenRect.size.width-100.0, 22.0);
				//	break;
			case screenEdgeLeftChoice:
				targetRect = NSMakeRect(screenRect.origin.x, screenRect.origin.y+50.0, 22.0, screenRect.size.height-100.0);
				break;
			case screenEdgeRightChoice:
				targetRect = NSMakeRect(screenRect.size.width-22.0, screenRect.origin.y+50.0, 22.0, screenRect.size.height-100.0);
				break;
			case screenEdgeBottomChoice:
				targetRect = NSMakeRect(screenRect.origin.x+50.0, screenRect.origin.y, screenRect.size.width-100.0, 22.0);
				break;
			default:
				targetRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
				NSLog(@"there was a problem here");
		}
		if (NSPointInRect(nsMouseUpPoint, targetRect))
		{
			NSLog(@"Registered hit in the preferenced area");
			//NSArray *windowInfoDictionaries = (NSArray *)CGWindowListCopyWindowInfo(kCGWindowListExcludeDesktopElements, kCGNullWindowID);
			//for (NSDictionary *dict in windowInfoDictionaries)
			//{
			//
			//}
			AXUIElementRef _systemWideElement = AXUIElementCreateSystemWide();
			AXUIElementRef _focusedApp;
			CFTypeRef _focusedWindow;
			CFTypeRef _position;
			CFTypeRef _size;			
			//Get the app that has the focus
			AXUIElementCopyAttributeValue(_systemWideElement,
										  (CFStringRef)kAXFocusedApplicationAttribute,
										  (CFTypeRef*)&_focusedApp);
			
			//Get the window that has the focus
			if(AXUIElementCopyAttributeValue((AXUIElementRef)_focusedApp,
											 (CFStringRef)NSAccessibilityFocusedWindowAttribute,
											 (CFTypeRef*)&_focusedWindow) == kAXErrorSuccess) {
				
				if(CFGetTypeID(_focusedWindow) == AXUIElementGetTypeID()) {
					//Get the Window's Current Position
					if(AXUIElementCopyAttributeValue((AXUIElementRef)_focusedWindow,
													 (CFStringRef)NSAccessibilityPositionAttribute,
													 (CFTypeRef*)&_position) != kAXErrorSuccess) {
						NSLog(@"Can't Retrieve Window Position");
					}
					//Get the Window's Current Size
					if(AXUIElementCopyAttributeValue((AXUIElementRef)_focusedWindow,
													 (CFStringRef)NSAccessibilitySizeAttribute,
													 (CFTypeRef*)&_size) != kAXErrorSuccess) {
						NSLog(@"Can't Retrieve Window Size");
					}
					//NSSize focusedWindowSize = [(NSValue *)_size sizeValue];
					CGSize focusedWindowSize;
					CGPoint focusedWindowLocation;
					
					if (!AXValueGetValue((AXValueRef)_size, kAXValueCGSizeType, &focusedWindowSize))
						NSLog(@"it's not a kAXValueRef, or something like that");
					if (!AXValueGetValue((AXValueRef)_position, kAXValueCGPointType, &focusedWindowLocation))
						NSLog(@"it's not a kAXValueCGPointType, or something");
					//NSPoint focusedWindowLocation = [(NSValue *)_position pointValue];
					switch ([[NSUserDefaults standardUserDefaults] integerForKey:kScreenEdgeChoiceKey])
					{
						case screenEdgeLeftChoice:
							if (focusedWindowLocation.x < 0.0)
							{
								[self.network sendItem:[HOAppInfo draggedAppInfo]];
								[self hideFrontmostApp];
							}
							else 
							{
								NSLog(@"check for dragging pasteboard in mouseDragged, copy it, use it here");
							}
							break;
						case screenEdgeRightChoice:
							if (focusedWindowLocation.x+focusedWindowSize.width > screenRect.size.width)
							{
								[self.network sendItem:[HOAppInfo draggedAppInfo]];
								[self hideFrontmostApp];

							}
							else 
							{
								NSLog(@"check for dragging pasteboard in mouseDragged, copy it, use it here");
							}
							break;
						case screenEdgeBottomChoice:
							if (focusedWindowLocation.y < 0.0)
							{
								[self.network sendItem:[HOAppInfo draggedAppInfo]];
								[self hideFrontmostApp];
							}
							else 
							{
								NSLog(@"check for dragging pasteboard in mouseDragged, copy it, use it here");
							}
							break;
						default:
							break;
					}
				}//end focused window exists
			}//end could get the focused window				
			
		}//end hit test success
	}
	return NULL;
}
