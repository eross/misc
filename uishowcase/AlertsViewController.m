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

File: AlertsViewController.m
Abstract: The view controller for hosting various kinds of alerts and action
sheets.

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

#import "AlertsViewController.h"
#import "ButtonsViewController.h"	// to use buttonWithTitle
#import "UISourceCell.h"
#import "UICell.h"
#import "Constants.h"

@implementation AlertsViewController

#define kUIAction_Simple_Section	0
#define kUIAction_OKCancel_Section	1
#define kUIAction_Custom_Section	2
#define kUIAlert_Simple_Section		3
#define kUIAlert_OKCancel_Section	4
#define kUIAlert_Custom_Section		5

@synthesize myTableView;

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"AlertTitle", @"");
	}
	return self;
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
}

- (void)dealloc
{
	[super dealloc];
}

- (UIButton *)actionButtonWithSelector:(SEL)selector
{
	UIButton *button = [ButtonsViewController buttonWithTitle:@"Show"
							target:self
							selector:selector
							frame:CGRectMake(0, 0, kStdButtonWidth, kStdButtonHeight)
							image:[UIImage imageNamed:@"whiteButton.png"]
							imagePressed:[UIImage imageNamed:@"blueButton.png"]
							darkTextColor:YES];
	return button;
}


#pragma mark UIActionSheet

- (void)dialogSimpleAction:(id)sender
{
	// open a dialog with just an OK button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"UIActionSheet <title>"
									delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)dialogOKCancelAction:(id)sender
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"UIActionSheet <title>"
									delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)dialogOtherAction:(id)sender
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"UIActionSheet <title>"
									delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
									otherButtonTitles:@"Button1", @"Button2", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	[actionSheet showInView:self.view];
	[actionSheet release];
}


#pragma mark UIAlertView

- (void)alertSimpleAction:(id)sender
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>"
							delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)alertOKCancelAction:(id)sender
{
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>"
							delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
	[alert show];
	[alert release];
}

- (void)alertOtherAction:(id)sender
{
	// open an alert with two custom buttons
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>"
							delegate:self cancelButtonTitle:nil otherButtonTitles:@"Button1", @"Button2", nil];
	[alert show];
	[alert release];
}

- (void)modalView:(UIModalView *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		NSLog(@"ok");
	}
	else
	{
		NSLog(@"cancel");
	}
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
	return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section)
	{
		case kUIAction_Simple_Section:
		{
			title = @"UIActionSheet";
			break;
		}
		case kUIAction_OKCancel_Section:
		{
			title = @"UIActionSheet";
			break;
		}
		case kUIAction_Custom_Section:
		{
			title = @"UIActionSheet";
			break;
		}
		case kUIAlert_Simple_Section:
		{
			title = @"UIAlertView";
			break;
		}
		case kUIAlert_OKCancel_Section:
		{
			title = @"UIAlertView";
			break;
		}
		case kUIAlert_Custom_Section:
		{
			title = @"UIAlertView";
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
		case kUIAction_Simple_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Action sheet simple variant
				((UICell*)cell).nameLabel.text = @"Simple";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(dialogSimpleAction:)];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - dialogSimpleAction";
			}
			break;
		}
		
		case kUIAction_OKCancel_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Action sheet OK/Cancel variant
				((UICell*)cell).nameLabel.text = @"OK - Cancel";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(dialogOKCancelAction:)];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - dialogOKCancelAction";
			}
			break;
		}
		
		case kUIAction_Custom_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Action sheet custom variant
				((UICell*)cell).nameLabel.text = @"Customized";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(dialogOtherAction:)];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - dialogOtherAction";
			}
			break;
		}
		
		case kUIAlert_Simple_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Alert's simple variant
				((UICell*)cell).nameLabel.text = @"Simple";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(alertSimpleAction:)];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - alertSimpleAction";
			}
			break;
		}
		
		case kUIAlert_OKCancel_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Alert's OK/Cancel variant
				((UICell*)cell).nameLabel.text = @"OK - Cancel";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(alertOKCancelAction:)];	
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - alertOKCancelAction";
			}
			break;
		}
		
		case kUIAlert_Custom_Section:
		{
			if (row == 0)
			{
				// this cell hosts the Alert's Custom variant
				((UICell*)cell).nameLabel.text = @"Custom";
				((UICell*)cell).view = [self actionButtonWithSelector:@selector(alertOtherAction:)];	
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"AlertsViewController.m - alertOtherAction";
			}
			break;
		}
	}
	
	return cell;
}

@end
