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

@implementation HOItemTableViewController

@synthesize items;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if (!(self = [self initWithNibName:nil bundle:nil])) return nil;
	
	NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:10];
	
	for (int i = 0; i < 10; i++) {
		HOItem *item = [[HOItem alloc] init];
		item.itemTitle = [NSString stringWithFormat:@"Item %d", i];
		item.itemDescription = [NSString stringWithFormat:@"This is a description of %d", i];
		item.itemIcon = [UIImage imageNamed:@"icon-test.png"];
		[itemArray addObject:item];
		[item release];
	}
	
	self.items = itemArray;
	
	self.tableView.rowHeight = 65.0;
	
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

- (void)viewDidLoad {
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

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[(UIWindow *)context removeFromSuperview];
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

