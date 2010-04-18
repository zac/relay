//
//  HOHandItemTableViewController.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItemTableViewController.h"

#import "HOItemTableViewCell.h"

#import "HOConnectionChooser.h"

#import "HOItem.h"
#import "HONetwork.h"

#import "HandoffAppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation HOItemTableViewController

@synthesize items, builtInItems, networkController;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if (!(self = [self initWithNibName:nil bundle:nil])) return nil;
	
	self.items = [NSMutableArray array];
	self.builtInItems = [NSMutableArray array];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
	self.tableView.rowHeight = 65.0;
	
	self.networkController = [[[HONetwork alloc] initWithDelegate:self] autorelease];

	return self;
}

- (void)viewDidAppear:(BOOL)animated {
	if ( ![self.networkController isConnected] ) {
		[self didDropConnectionOnNetwork: self.networkController];
	}
}

- (void)didDropConnectionOnNetwork:(HONetwork *)theNetwork {
	HOConnectionChooser *chooser = [[HOConnectionChooser alloc] initWithNetwork: self.networkController];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooser];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[((HandoffAppDelegate*)[UIApplication sharedApplication].delegate).viewController presentModalViewController:navController animated:YES];
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
	[self.builtInItems insertObject:nowPlayingItem atIndex:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
						  withRowAnimation:UITableViewRowAnimationTop];
}

- (void)discoverCurrentClipboard {
	
	HOItem *clipboardItem = [[HOItem alloc] init];
	clipboardItem.command = HOItemCommandTypeClipboard;
	clipboardItem.itemTitle = @"Clipboard";
	UIPasteboard *general = [UIPasteboard generalPasteboard];
	clipboardItem.itemDescription = [general string];
	clipboardItem.properties = [NSDictionary dictionaryWithObject:[general string] forKey:@"string"];
	
	[self.builtInItems addObject:clipboardItem];
	[clipboardItem release];
	
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.builtInItems.count-1 inSection:0]]
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 1) return [self.items count];
	
	return [self.builtInItems count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    HOItemTableViewCell *cell = (HOItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HOItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.parentController = self;
	
	if (indexPath.section == 0) {
		//we're in the built in section.
		cell.item = (HOItem *)[self.builtInItems objectAtIndex:indexPath.row];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		cell.item = (HOItem *)[self.items objectAtIndex:indexPath.row];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HOItemTableViewCell *tableCell = (HOItemTableViewCell *)[theTableView cellForRowAtIndexPath:indexPath];
	
	HOItem *theItem = nil;
	if (indexPath.section == 1) {
		theItem = [self.items objectAtIndex:indexPath.row];
		[self performActionForItem:theItem];
		return;
	} else {
		theItem = [self.builtInItems objectAtIndex:indexPath.row];
	}
	
	
	UIWindow *flyWindow = [tableCell windowForCell];
	
	//convert to the window's coordinate system.
	CGRect rowFrame = [[self.view window] convertRect:[theTableView rectForRowAtIndexPath:indexPath] fromView:theTableView];
	flyWindow.frame = rowFrame;
	
	[self.networkController sendItem:theItem];
	
	CGAffineTransform transform = CGAffineTransformMakeScale(.3, .3);
	
	[UIView beginAnimations:nil context:[[NSArray arrayWithObjects:flyWindow, tableCell, nil] retain]];
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
	
	NSLog(@"GOT ITEM: %@", theItem);
	
	//do special actions for the clipboard or the song.
	BOOL builtIn = [theItem.command isEqualToString:HOItemCommandTypeClipboard] || [theItem.command isEqualToString:HOItemCommandTypeSong];
	NSInteger indexOfItem = 0;
	NSIndexPath *lastPath = nil;
	CGRect rowRect;
	
	if (builtIn) {
		indexOfItem = [self.builtInItems count]-1;
		
		BOOL goingToSong = [theItem.command isEqualToString:HOItemCommandTypeSong];
		
		lastPath = [NSIndexPath indexPathForRow:goingToSong?0:1 inSection:0];
		
		rowRect = [[self.view window] convertRect:[self.tableView rectForRowAtIndexPath:lastPath]
										 fromView:self.tableView];
		
	} else {
		
		[self.items addObject:theItem];
		
		indexOfItem = [self.items count]-1;
		
		lastPath = [NSIndexPath indexPathForRow:indexOfItem inSection:1];
		
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastPath]
							  withRowAnimation:UITableViewRowAnimationRight];
		
		rowRect = [[self.view window] convertRect:[self.tableView rectForRowAtIndexPath:lastPath]
													fromView:self.tableView];
	}
	
	
	
	
	HOItemTableViewCell *tableCell = (HOItemTableViewCell *)[self.tableView cellForRowAtIndexPath:lastPath];
	
	UIWindow *flyWindow = [tableCell windowForCell];
	NSLog(@"tableCell: %@ flyWindow: %@", tableCell, flyWindow);
	
	if (!builtIn) [tableCell hideContents];
	
	//convert to the window's coordinate system.
	CGRect rowFrame = [[self.tableView window] convertRect:[self.tableView rectForRowAtIndexPath:lastPath] fromView:self.tableView];
	flyWindow.frame = rowFrame;
	
	flyWindow.frame = CGRectMake(768, 502, flyWindow.frame.size.width, flyWindow.frame.size.height);
	flyWindow.transform = CGAffineTransformMakeScale(.3, .3);
	flyWindow.alpha = 0.5;
	
	[UIView beginAnimations:nil context:[[NSArray arrayWithObjects:flyWindow, tableCell, nil] retain]];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	flyWindow.transform = CGAffineTransformMakeScale(1.0, 1.0);
	flyWindow.frame = rowRect;
	flyWindow.alpha = 1.0;
	
    [UIView commitAnimations];	
	
	[flyWindow makeKeyAndVisible];
	
	if (builtIn) [self performActionForItem:theItem];
}

- (void)network:(HONetwork *)theNetwork didReceiveResponse:(BLIPResponse *)theResponse {
	//we got a response.
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIWindow *theWindow = [(NSArray *)context objectAtIndex:0];
	HOItemTableViewCell *cell = [(NSArray *)context objectAtIndex:1];
	
	[theWindow resignKeyWindow];
	[theWindow release];
	
	[cell showContents];
	
	[(NSArray *)context release];
}


//HOItemCommandTypeSong
//HOItemCommandTypeWebpage
//HOItemCommandTypeClipboard
//HOItemCommandTypeDocument

- (void)performActionForItem:(HOItem *)theItem {
	
	NSLog(@"command: %@", theItem.command);
	
	if ([theItem.command isEqualToString:HOItemCommandTypeWebpage]) {
		
		NSString *urlString = [theItem.properties objectForKey:@"actionURL"];
		
		NSLog(@"theString: %@", urlString);
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	} else if ([theItem.command isEqualToString:HOItemCommandTypeSong]) {
		NSString *artist = [theItem.properties objectForKey:@"artist"];
		NSString *track = [theItem.properties objectForKey:@"track"];
		
		NSLog(@"Performing action with song: %@ by %@", track, artist);
		
		NSInteger seconds = [[theItem.properties objectForKey:@"seconds"] integerValue];
		BOOL playing = [[theItem.properties objectForKey:@"playbackState"] isEqualToString:@"1"];
		
		MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue: artist
																					 forProperty: MPMediaItemPropertyArtist];
		MPMediaPropertyPredicate *trackPredicate = [MPMediaPropertyPredicate predicateWithValue: track
																					forProperty: MPMediaItemPropertyTitle];
		
		MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];
		
		[songQuery addFilterPredicate: artistPredicate];
		[songQuery addFilterPredicate: trackPredicate];
		
		[[MPMusicPlayerController iPodMusicPlayer] setQueueWithQuery:songQuery];
		[songQuery release];
		
		[[MPMusicPlayerController iPodMusicPlayer] setCurrentPlaybackTime:(NSTimeInterval)seconds];
		if (playing) [[MPMusicPlayerController iPodMusicPlayer] play];
				
		HOItemTableViewCell *cell = (HOItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		[cell setItem:theItem];
		
	} else if ([theItem.command isEqualToString:HOItemCommandTypeClipboard]) {
		[[UIPasteboard generalPasteboard] setValue:[theItem.properties objectForKey:@"string"] forPasteboardType:@"public.utf8-plain-text"];
		
		HOItemTableViewCell *cell = (HOItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		[cell setItem:theItem];
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
	
	self.builtInItems = nil;
	self.items = nil;
	
    [super dealloc];
}


@end

