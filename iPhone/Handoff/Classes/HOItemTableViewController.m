//
//  HOHandItemTableViewController.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItemTableViewController.h"

#import "HOItemTableViewCell.h"

#import "HOItem.h"
#import "HONetwork.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation HOItemTableViewController

@synthesize items, networkController;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if (!(self = [self initWithNibName:nil bundle:nil])) return nil;
	
	NSMutableArray *itemArray = [NSMutableArray array];
	
	self.items = itemArray;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
	self.tableView.rowHeight = 65.0;
	
	self.networkController = [[[HONetwork alloc] initWithDelegate:self] autorelease];

	return self;
}

- (void)discoverCurrentSong {
	MPMusicPlayerController *iPodPlayer = [MPMusicPlayerController iPodMusicPlayer];
	MPMediaItem *currentItem = iPodPlayer.nowPlayingItem;
	
	if (!currentItem) return;
	
	HOItem *nowPlayingItem = [[HOItem alloc] init];
	nowPlayingItem.command = HOItemCommandTypeSong;
	
	NSString *desc = [NSString stringWithFormat:@"%@ by %@",
					  [currentItem valueForProperty:MPMediaItemPropertyTitle],
					  [currentItem valueForProperty:MPMediaItemPropertyArtist]];
	nowPlayingItem.itemDescription = desc;
	nowPlayingItem.itemTitle = @"Current iPod Song";
	MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
	nowPlayingItem.itemIconData = UIImagePNGRepresentation([artwork imageWithSize:CGSizeMake(45.0, 45.0)]);
	
	
	//make it the first object.
	[self.items insertObject:nowPlayingItem atIndex:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)discoverCurrentClipboard {
	
	HOItem *clipboardItem = [[HOItem alloc] init];
	clipboardItem.command = HOItemCommandTypeClipboard;
	clipboardItem.itemTitle = @"Clipboard";
	UIPasteboard *general = [UIPasteboard generalPasteboard];
	clipboardItem.itemDescription = [general string];
	
	[self.items addObject:clipboardItem];
	[clipboardItem release];
	
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]]
						  withRowAnimation:UITableViewRowAnimationTop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

- (void)viewDidLoad {
	
	[self discoverCurrentSong];
	[self discoverCurrentClipboard];
	
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    HOItemTableViewCell *cell = (HOItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HOItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.item = (HOItem *)[self.items objectAtIndex:indexPath.row];
	
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HOItemTableViewCell *tableCell = (HOItemTableViewCell *)[theTableView cellForRowAtIndexPath:indexPath];
		
	UIWindow *flyWindow = [tableCell windowForCell];
	
	//convert to the window's coordinate system.
	CGRect rowFrame = [[self.view window] convertRect:[theTableView rectForRowAtIndexPath:indexPath] fromView:theTableView];
	flyWindow.frame = rowFrame;
	
	[self.networkController sendItem:[self.items objectAtIndex:indexPath.row]];
	
	CGAffineTransform transform = CGAffineTransformMakeScale(.3, .3);
	
	[UIView beginAnimations:nil context:flyWindow];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	flyWindow.frame = CGRectMake(768, 502, flyWindow.frame.size.width, flyWindow.frame.size.height);
	flyWindow.transform = transform;
	flyWindow.alpha = .5;
	
    [UIView commitAnimations];	
		
	[flyWindow makeKeyAndVisible];
}

- (void)network:(HONetwork *)theNetwork didReceiveItem:(HOItem *)theItem {
	[self.items addObject:theItem];
	
	NSIndexPath *lastPath = [NSIndexPath indexPathForRow:[self.items count]-1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastPath]
						  withRowAnimation:UITableViewRowAnimationTop];
	CGRect lastRowRect = [self.tableView rectForRowAtIndexPath:lastPath];
	
	HOItemTableViewCell *tableCell = (HOItemTableViewCell *)[self.tableView cellForRowAtIndexPath:lastPath];
	
	UIWindow *flyWindow = [tableCell windowForCell];
	
	//convert to the window's coordinate system.
	CGRect rowFrame = [[self.tableView window] convertRect:[self.tableView rectForRowAtIndexPath:lastPath] fromView:self.tableView];
	flyWindow.frame = rowFrame;
	
	flyWindow.frame = CGRectMake(768, 502, flyWindow.frame.size.width, flyWindow.frame.size.height);
	flyWindow.transform = CGAffineTransformMakeScale(.3, .3);
	flyWindow.alpha = 0.5;
	
	[UIView beginAnimations:nil context:flyWindow];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	flyWindow.frame = lastRowRect;
	flyWindow.transform = CGAffineTransformMakeScale(1.0, 1.0);
	flyWindow.alpha = 1.0;
	
    [UIView commitAnimations];	
	
	[flyWindow makeKeyAndVisible];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[(UIWindow *)context removeFromSuperview];
}


//HOItemCommandTypeSong
//HOItemCommandTypeWebpage
//HOItemCommandTypeClipboard
//HOItemCommandTypeDocument

- (void)performActionForItem:(HOItem *)theItem {
	if ([theItem.command isEqualToString:HOItemCommandTypeWebpage]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[theItem.properties objectForKey:@"actionURL"]]];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	self.items = nil;
	
    [super dealloc];
}


@end

