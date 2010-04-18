//
//  HandoffViewController.m
//  Handoff
//
//  Created by Zac White on 4/16/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import "HandoffViewController.h"
#import "HOItemTableViewController.h"


@implementation HandoffViewController

@synthesize tableViewController, textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	
	return self;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
		
	if (!self.tableViewController) {
		self.tableViewController = [[[HOItemTableViewController alloc] init] autorelease];
	}
	
	self.tableViewController.view.frame = CGRectMake(0, 0, 300, 1004);
	
	[self.view addSubview:self.tableViewController.view];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	self.tableViewController = nil;
	
    [super dealloc];
}

@end
