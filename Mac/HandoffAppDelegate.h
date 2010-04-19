//
//  HandoffAppDelegate.h
//  Handoff
//
//  Created by Daniel DeCovnick on 4/16/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HONetwork.h"

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

@interface HandoffAppDelegate : NSObject <HONetworkDelegate> {
	NSStatusItem *statusItem;
	
	IBOutlet NSWindow *preferencesWindow;
	IBOutlet NSPopUpButton *screenEdgeChoice;
	IBOutlet NSMenu *statusMenu;
	PTHotKey *lastKey;
	PTKeyCombo *lastCombo;
	NSInteger screenEdgeChoiceValue;
	HONetwork *network;
	BOOL inPaste;
}
@property (nonatomic, retain) PTHotKey *lastKey;
@property (nonatomic, retain) PTKeyCombo *lastCombo;
@property (nonatomic, retain) HONetwork *network;
@property (assign) BOOL	inPaste;

-(void)hideFrontmostApp;

-(IBAction)showPrefsWindow:(id)sender;
-(IBAction)setChoice:(id)sender;
-(IBAction)pasteToiPad:(id)sender;

@end
