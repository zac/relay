//
//  HandoffAppDelegate.h
//  Handoff
//
//  Created by Daniel DeCovnick on 4/16/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTHotKey;
@class PTHotKeyCenter;
@class PTKeyCombo;

enum screenEdges {
//	screenEdgeTopChoice,
	screenEdgeLeftChoice,
	screenEdgeRightChoice,
	screenEdgeBottomChoice
};
extern NSString *const kScreenEdgeChoiceKey; 

@interface HandoffAppDelegate : NSObject {
	NSStatusItem *statusItem;
	
	IBOutlet NSWindow *preferencesWindow;
	IBOutlet NSPopUpButton *screenEdgeChoice;
	IBOutlet NSMenu *statusMenu;
	PTHotKey *lastKey;
	PTKeyCombo *lastCombo;
	NSInteger screenEdgeChoiceValue;
}
@property (nonatomic, retain) PTHotKey *lastKey;
@property (nonatomic, retain) PTKeyCombo *lastCombo;

-(IBAction)showPrefsWindow:(id)sender;
-(IBAction)setChoice:(id)sender;

@end
