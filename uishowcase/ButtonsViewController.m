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

File: ButtonsViewController.m
Abstract: The view controller for hosting the UIButton features of this sample.

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

#import "ButtonsViewController.h"
#import "Constants.h"
#import "UICell.h"
#import "UISourceCell.h"

@implementation ButtonsViewController

@synthesize myTableView;

#define kUIGrayButton_Section		0
#define kUIDarkGrayButton_Section	1
#define kUIImageButton_Section		2
#define kUIRoundRectButton_Section	3
#define kUINavButton_Section		4
#define kUINavButtonBack_Section	5
#define kUINavButtonDone_Section	6


- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"ButtonsTitle", @"");
	}
	return self;
}

- (void)dealloc
{
	[myTableView setDelegate:nil];
	[myTableView release];
	
	[grayButton release];
	[darkGreyButton release];
	[imageButton release];
	[roundedButtonType release];
	[navStyleButton release];
	[navStyleBackButton release];
	[navStyleDoneButton release];	
	
	[super dealloc];
}

+ (UIButton *)buttonWithTitle:	(NSString *)title
									target:(id)target
									selector:(SEL)selector
									frame:(CGRect)frame
									image:(UIImage *)image
									imagePressed:(UIImage *)imagePressed
									darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forStates:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forStates:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forStates:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forStates:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forStates:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

#pragma mark
#pragma mark Gray Button
#pragma mark
- (void)createGrayButton
{
	// create the UIButtons with various background images
	// white button:
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight);
	
	grayButton = [ButtonsViewController buttonWithTitle:@"Gray"
								target:self
								selector:@selector(action:)
								frame:frame
								image:buttonBackground
								imagePressed:buttonBackgroundPressed
								darkTextColor:YES];
}

#pragma mark
#pragma mark Dark Gray Button
#pragma mark
- (void)createDarkGrayButton
{
	UIImage *buttonBackground = [UIImage imageNamed:@"grayButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight);
	
	darkGreyButton = [ButtonsViewController buttonWithTitle:@"Dark Gray"
								target:self
								selector:@selector(action:)
								frame:frame
								image:buttonBackground
								imagePressed:buttonBackgroundPressed
								darkTextColor:NO];
}

#pragma mark
#pragma mark Button with Image
#pragma mark
- (void)createImageButton
{	
	// create a UIButton with just an image instead of a title
	
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight);
	
	imageButton = [ButtonsViewController buttonWithTitle:@""
								target:self
								selector:@selector(action:)
								frame:frame
								image:buttonBackground
								imagePressed:buttonBackgroundPressed
								darkTextColor:YES];
	
	[imageButton setImage:[UIImage imageNamed:@"UIButton_custom.png"] forStates:UIControlStateNormal];
}

#pragma mark
#pragma mark UIButtonTypeRoundedRect
#pragma mark
- (void)createRoundedButton
{
	// create a UIButton (UIButtonTypeRoundedRect)
	roundedButtonType = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	roundedButtonType.frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight);
	[roundedButtonType setTitle:@"Rounded" forStates:UIControlStateNormal];
	roundedButtonType.backgroundColor = [UIColor clearColor];
}

#pragma mark
#pragma mark UIButtonTypeNavigation
#pragma mark
- (void)createNavButton
{
	// create a UIButton (UIButtonTypeNavigation)	
	navStyleButton = [[UIButton buttonWithType:UIButtonTypeNavigation] retain];
	[navStyleButton setTitle:@"Navigation" forStates:UIControlStateNormal];
}

#pragma mark
#pragma mark UIButtonTypeNavigationBack
#pragma mark
- (void)createNavBackButton
{
	// create a UIButton (UIButtonTypeNavigationBack)	
	navStyleBackButton = [[UIButton buttonWithType:UIButtonTypeNavigationBack] retain];
	[navStyleBackButton setTitle:@"Back" forStates:UIControlStateNormal];
}

#pragma mark
#pragma mark UIButtonTypeNavigationDone
#pragma mark
- (void)createNavDoneButton
{
	// create a UIButton (UIButtonTypeNavigationDone)	
	navStyleDoneButton = [[UIButton buttonWithType:UIButtonTypeNavigationDone] retain];
	[navStyleDoneButton setTitle:@"Done" forStates:UIControlStateNormal];
}

- (void)action:(id)sender
{
	NSLog(@"UIButton was clicked");
}


- (void)loadView
{
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.rowHeight = kUIRowHeight;
	self.view = myTableView;

	self.view.autoresizesSubviews = YES;
	
	[self createGrayButton];
	[self createDarkGrayButton];
	[self createImageButton];
	[self createRoundedButton];
	[self createNavButton];
	[self createNavBackButton];
	[self createNavDoneButton];
}


#pragma mark - UITableView delegates

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 7;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section)
	{
		case kUIGrayButton_Section:
		{
			title = @"UIButton";
			break;
		}
		case kUIDarkGrayButton_Section:
		{
			title = @"UIButton";
			break;
		}
		case kUIImageButton_Section:
		{
			title = @"UIButton";
			break;
		}
		case kUIRoundRectButton_Section:
		{
			title = @"UIButtonTypeRoundedRect";
			break;
		}
		case kUINavButton_Section:
		{
			title = @"UIButtonTypeNavigation";
			break;
		}
		case kUINavButtonBack_Section:
		{
			title = @"UIButtonTypeNavigationBack";
			break;
		}
		case kUINavButtonDone_Section:
		{
			title = @"UIButtonTypeNavigationDone";
			break;
		}
	}
	return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	
	switch ([indexPath row])
	{
		case 0:
		{
			result = kUIRowHeight;
			break;
		}
		case 1:
		{
			result = kUIRowLabelHeight;
			break;
		}
	}

	return result;
}

// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)obtainTableCell:(UITableViewCell *)availableCell forRow:(NSInteger)row
{
	UITableViewCell *cell;
	
	if (availableCell != nil)
	{
		if ((0 == row && ![availableCell isKindOfClass:[UICell class]]) ||
			(1 == row && ![availableCell isKindOfClass:[UISourceCell class]]))
		{
			// can't reuse the cell - it's the wrong type for the row
			availableCell = nil;
		}
		else
		{
			cell = availableCell;
		}
	}
	
	if (availableCell == nil)
	{
		if (row == 0)
		{
			cell = [[UICell alloc] initWithFrame:CGRectZero];
		}
		else if (row == 1)
		{
			cell = [[UISourceCell alloc] initWithFrame:CGRectZero];
		}
	}
	
	return cell;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView 
								cellForRowAtIndexPath:(NSIndexPath *)indexPath
								withAvailableCell:(UITableViewCell *)availableCell
{
	int row = [indexPath row];
	UITableViewCell *cell = [self obtainTableCell:availableCell forRow:row];
	
	switch (indexPath.section)
	{
		case kUIGrayButton_Section:
		{
			if (row == 0)
			{
				// this cell hosts the gray button
				((UICell*)cell).nameLabel.text = @"Gray Button";
				((UICell*)cell).view = grayButton;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createGrayButton";
			}
			break;
		}
		
		case kUIDarkGrayButton_Section:
		{
			if (row == 0)
			{
				// this cell hosts the dark grey button
				((UICell*)cell).nameLabel.text = @"Dark Gray Button";
				((UICell*)cell).view = darkGreyButton;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createDarkGrayButton";
			}
			break;
		}
		
		case kUIImageButton_Section:
		{
			if (row == 0)
			{
				// this cell hosts the button with image
				((UICell*)cell).nameLabel.text = @"Button with Image";
				((UICell*)cell).view = imageButton;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createImageButton";
			}
			break;
		}
		
		case kUIRoundRectButton_Section:
		{
			if (row == 0)
			{
				// this cell hosts the rounded button
				((UICell*)cell).nameLabel.text = @"Rounded Button";
				((UICell*)cell).view = roundedButtonType;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createRoundedButton";
			}
			break;
		}
		
		case kUINavButton_Section:
		{
			if (row == 0)
			{
				// this cell hosts the nav button
				((UICell*)cell).nameLabel.text = @"Nav Button";
				((UICell*)cell).view = navStyleButton;
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createNavButton";
			}
			break;
		}
			
		case kUINavButtonBack_Section:
		{
			if (row == 0)
			{
				// this cell hosts the nav back button
				((UICell*)cell).nameLabel.text = @"Back Button";
				((UICell*)cell).view = navStyleBackButton;
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createNavBackButton";
			}
			break;
		}
		
		case kUINavButtonDone_Section:
		{
			if (row == 0)
			{
				// this cell hosts the nav done button
				((UICell*)cell).nameLabel.text = @"Done Button";
				((UICell*)cell).view = navStyleDoneButton;
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ButtonsViewController.m - createNavDoneButton";
			}
			break;
		}
	}
	
	return cell;
}

@end
