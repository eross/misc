/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: MainViewController.m
Abstract: The application's main view controller (front page).

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "MainViewController.h"
#import "ButtonsViewController.h"
#import "ControlsViewController.h"
#import "TextFieldController.h"
#import "TextViewController.h"
#import "SegmentViewController.h"
#import "PickerViewController.h"
#import "ImagesViewController.h"
#import "WebViewController.h"
#import "AlertsViewController.h"
#import "FlipViewController.h"

#import "Constants.h"

@implementation MainViewController

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
		
		menuList = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView
{	
	// setup our parent content view and embed it this view controller
	// having a generic contentView (as opposed to UITableView taking up the entire view controller)
	// makes your UI design more flexible as you can add more subviews later
	//
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = contentView;
	[contentView release];
	
	self.view.autoresizesSubviews = YES;
	
	// create our view controllers - we will encase each title and view controller pair in a NSDictionary
	// and add it to a mutable array.  If you want to add more pages, simply call "addObject" on "menuList"
	// with an additional NSDictionary.  Note we use NSLocalizedString to load a localized version of its title.
	
	// for showing various UIButtons:
	ButtonsViewController *buttonsViewController = [[ButtonsViewController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"ButtonsTitle", @""), @"title",
							buttonsViewController, @"viewController",
							nil]];
	[buttonsViewController release];
	
	// for showing various UIControls:
	ControlsViewController *controlsViewController = [[ControlsViewController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"ControlsTitle", @""), @"title",
							controlsViewController, @"viewController",
							nil]];
	[controlsViewController release];
	
	// for showing various UITextFields:
	TextFieldController *textFieldViewController = [[TextFieldController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"TextFieldTitle", @""), @"title",
							textFieldViewController, @"viewController",
							nil]];
	[textFieldViewController release];
	
	// for showing UITextView:
	TextViewController *textViewController = [[TextViewController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"TextViewTitle", @""), @"title",
							textViewController, @"viewController",
							nil]];
	[textViewController release];
	
	// for showing various UIPickers:
	PickerViewController *pickerViewController = [[PickerViewController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"PickerTitle", @""), @"title",
							pickerViewController, @"viewController",
							nil]];
	[pickerViewController release];
	
	// for showing UIImageView:
	ImagesViewController *imagesViewController = [[ImagesViewController alloc] init];
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"ImagesTitle", @""), @"title",
							imagesViewController, @"viewController",
							nil]];
	[imagesViewController release];	
	
	// for showing UIWebView:
	WebViewController *webViewController = [[WebViewController alloc] init];
	[menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													NSLocalizedString(@"WebTitle", @""), @"title",
													webViewController, @"viewController",
													nil]];
	[webViewController release];	
	
	// for showing various UISegmentedControls:
	SegmentViewController *segmentViewController = [[SegmentViewController alloc] init];
	[menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													NSLocalizedString(@"SegmentTitle", @""), @"title",
													segmentViewController, @"viewController",
													nil]];
	[segmentViewController release];
	
	// for showing various UIActionSheets and UIAlertViews:
	AlertsViewController *alertsViewController = [[AlertsViewController alloc] init];
	[menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													NSLocalizedString(@"AlertTitle", @""), @"title",
													alertsViewController, @"viewController",
													nil]];
	[alertsViewController release];
	
	// for showing how to a use flip animation transition between two UIViews:
	FlipViewController *flipViewController = [[FlipViewController alloc] init];
	[menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													NSLocalizedString(@"FlipTitle", @""), @"title",
													flipViewController, @"viewController",
													nil]];
	[flipViewController release];												

	// finally create a our table, its contents will be populated by "menuList" using the UITableView delegate methods
	myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	// setup our list view to autoresizing in case we decide to support autorotation along the other UViewControllers
	myTableView.autoresizesSubviews = YES;
	myTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	
	[myTableView reloadData];	// populate our table's data
	[self.view addSubview: myTableView];
}

- (void)dealloc
{
	[menuList dealloc];
	[myTableView dealloc];
	
	[super dealloc];
}


#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [myTableView indexPathForSelectedRow];
	[myTableView deselectRowAtIndexPath:tableSelection animated:NO];
}


#pragma mark UITableView delegate methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

// tell our table how many sections or groups it will have (always 1 in our case)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuList count];
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView selectionDidChangeToIndexPath:(NSIndexPath *)newIndexPath
						fromIndexPath:(NSIndexPath *)oldIndexPath
{
	UIViewController *targetViewController = [[menuList objectAtIndex: newIndexPath.row] objectForKey:@"viewController"];
	[[self navigationController] pushViewController:targetViewController animated:YES];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
						withAvailableCell:(UITableViewCell *)availableCell
{
	UITableViewCell *cell = nil;
	
	if (availableCell != nil)
	{
		cell = (UITableViewCell *)availableCell;
	}
	else
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;	// important for auto rotation of the table
	}
	
	cell.text = [[menuList objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}

@end

