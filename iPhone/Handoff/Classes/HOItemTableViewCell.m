//
//  HOItemTableViewCell.m
//  Handoff
//
//  Created by Zac White on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "HOItemTableViewCell.h"

#import "HOItem.h"
#import "HOItemTableViewController.h"

@implementation HOItemTableViewCell

@synthesize item, actionButton, parentController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (!(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) return nil;
	
	return self;
}

- (void)hideContents {
	self.imageView.hidden = YES;
	self.textLabel.hidden = YES;
	self.detailTextLabel.hidden = YES;
}

- (void)showContents {
	self.imageView.hidden = NO;
	self.textLabel.hidden = NO;
	self.detailTextLabel.hidden = NO;
}

#pragma mark -
#define MARGIN 10.0

- (UIWindow *)windowForCell {
	UIWindow *theWindow = [[UIWindow alloc] initWithFrame:self.contentView.bounds];
	
	UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
	iconView.backgroundColor = [UIColor clearColor];
	iconView.image = self.imageView.image;
	[theWindow addSubview:iconView];
	[iconView release];
	
	UILabel *titleField = [[UILabel alloc] initWithFrame:self.textLabel.frame];
	titleField.backgroundColor = [UIColor clearColor];
	titleField.font = self.textLabel.font;
	titleField.text = self.textLabel.text;
	[theWindow addSubview:titleField];
	[titleField release];
	
	UILabel *descriptionField = [[UILabel alloc] initWithFrame:self.detailTextLabel.frame];
	descriptionField.backgroundColor = [UIColor clearColor];
	descriptionField.font = self.detailTextLabel.font;
	descriptionField.text = self.detailTextLabel.text;
	[theWindow addSubview:descriptionField];
	[descriptionField release];
	
	return theWindow;
}

- (void)setItem:(HOItem *)theItem {
	
	if (self.item == theItem) return;
	
	[item release];
	item = [theItem retain];
	
	self.textLabel.text = theItem.itemTitle;
	self.detailTextLabel.text = theItem.itemDescription;
	self.imageView.image = [UIImage imageWithData:theItem.itemIconData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	
	self.parentController = nil;
	
	self.item = nil;
	self.actionButton = nil;
	
    [super dealloc];
}


@end
