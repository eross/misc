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

File: TextFieldController.m
Abstract: The view controller for hosting the UITextField features of this
sample.

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

#import "TextFieldController.h"
#import "Constants.h"
#import "UICellTextField.h"
#import "UISourceCell.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					150.0

#define kTextFieldWidth							100.0	// initial width, but the table cell will dictact the actual width

// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.30

#define kUITextField_Section					0
#define kUITextField_Rounded_Custom_Section		1
#define kUITextField_Secure_Section				2


// Private interface for TextFieldController - internal only methods.
@interface TextFieldController (Private)
- (void)setViewMovedUp:(BOOL)movedUp;
@end

@implementation TextFieldController

@synthesize myTableView;

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"TextFieldTitle", @"");
	}
	
	return self;
}

- (void)dealloc
{
	[textFieldCell release];
	[textFieldRoundedCell release];
	[textFieldSecureCell release];
	
	[super dealloc];
}

#pragma mark
#pragma mark UITextField
#pragma mark
- (UITextField *)createTextField
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
   
	textField.borderStyle = UITextFieldBorderStyleBezel;
    textField.textColor = [UIColor blackColor];
	textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"<enter text>";
    textField.backgroundColor = [UIColor whiteColor];
	
	textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textField.returnKeyType = UIReturnKeyDone;
	
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	return textField;
}

#pragma mark
#pragma mark UITextField - rounded
#pragma mark
- (UITextField *)createTextField_Rounded
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    
	textField.borderStyle = UITextFieldBorderStyleRounded;
    textField.textColor = [UIColor blackColor];
	textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"<enter text>";
    textField.backgroundColor = [UIColor whiteColor];
	
	textField.keyboardType = UIKeyboardTypeDefault;
	textField.returnKeyType = UIReturnKeyDone;
	
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return textField;
}

#pragma mark
#pragma mark UITextField - secure
#pragma mark
- (UITextField *)createTextField_Secure
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextFieldBorderStyleBezel;
    textField.textColor = [UIColor blackColor];
	textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"<enter password>";
    textField.backgroundColor = [UIColor whiteColor];
	
	textField.keyboardType = UIKeyboardTypeDefault;
	textField.returnKeyType = UIReturnKeyDone;
	
	textField.secureTextEntry = YES;	// make the text entry secure (bullets)
	
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return textField;
}

- (void)loadView
{
	self.editing = NO;
    self.navigationItem.customRightView = self.editButton;
	
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	myTableView.scrollEnabled = NO;
	self.view = myTableView;

	self.view.autoresizesSubviews = YES;
	
	UITextField *textField = [self createTextField];
	textFieldCell = [[UICellTextField alloc] initWithFrame:CGRectZero];
	textFieldCell.delegate = self;	// so we can detect when cell editing starts
	textFieldCell.view = textField;
	[textField release];
	
	UITextField *textFieldRounded = [self createTextField_Rounded];
	textFieldRoundedCell = [[UICellTextField alloc] initWithFrame:CGRectZero];
    textFieldRoundedCell.view = textFieldRounded;
	textFieldRoundedCell.delegate = self;	// so we can detect when cell editing starts
	[textFieldRounded release];
	
	UITextField *textFieldSecure = [self createTextField_Secure];
	textFieldSecureCell = [[UICellTextField alloc] initWithFrame:CGRectZero];
	textFieldSecureCell.view = textFieldSecure;
	textFieldSecureCell.delegate = self;	// so we can detect when cell editing starts
	[textFieldSecure release];
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
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section)
	{
		case kUITextField_Section:
		{
			title = @"UITextField";
			break;
		}
		case kUITextField_Rounded_Custom_Section:
		{
			title = @"UITextField Rounded";
			break;
		}
		case kUITextField_Secure_Section:
		{
			title = @"UITextField Secure";
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

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView 
								cellForRowAtIndexPath:(NSIndexPath *)indexPath
								withAvailableCell:(UITableViewCell *)availableCell
{
	UISourceCell *sourceCell;
	
	int row = [indexPath row];
	switch (indexPath.section)
	{
		case kUITextField_Section:
		{
			if (row == 0)
			{
				// this cell hosts the text field control
				return textFieldCell;
			}
			else
			{
				if (availableCell == nil)
					sourceCell = [[UISourceCell alloc] initWithFrame:CGRectZero];
				else
					sourceCell = (UISourceCell *)availableCell;
					
				// this cell hosts the info on where to find the code
				sourceCell.sourceLabel.text = @"TextFieldController.m - createTextField";
				
				return sourceCell;
			}
			break;
		}
		
		case kUITextField_Rounded_Custom_Section:
		{
			if (row == 0)
			{
				// this cell hosts the rounded text field control
				return textFieldRoundedCell;
			}
			else
			{
				if (availableCell == nil)
					sourceCell = [[UISourceCell alloc] initWithFrame:CGRectZero];
				else
					sourceCell = (UISourceCell *)availableCell;
					
				// this cell hosts the info on where to find the code
				sourceCell.sourceLabel.text = @"TextFieldController.m - createTextField_Rounded";
				
				return sourceCell;
			}
			break;	
		}
		
		case kUITextField_Secure_Section:
		{
			// we are creating a new cell, setup its attributes
			if (row == 0)
			{
				// this cell hosts the secure text field control
				return textFieldSecureCell;
			}
			else
			{
				if (availableCell == nil)
					sourceCell = [[UISourceCell alloc] initWithFrame:CGRectZero];
				else
					sourceCell = (UISourceCell *)availableCell;
					
				// this cell hosts the info on where to find the code
				sourceCell.sourceLabel.text = @"TextFieldController.m - createTextField_Secure";
				
				return sourceCell;
			}
			break;
		}
	}
	
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 37.0;
}


#pragma mark -
#pragma mark <EditableTableViewCellDelegate> Methods and editing management

- (BOOL)cellShouldBeginEditing:(EditableTableViewCell *)cell
{
    // notify other cells to end editing
    if (![cell isEqual:textFieldCell])
		[textFieldCell stopEditing];
    if (![cell isEqual:textFieldRoundedCell])
		[textFieldRoundedCell stopEditing];
    if (![cell isEqual:textFieldSecureCell])
		[textFieldSecureCell stopEditing];
		
    return self.editing;
}

- (void)cellDidEndEditing:(EditableTableViewCell *)cell
{
	if ([cell isEqual:textFieldSecureCell] || [cell isEqual:textFieldRoundedCell])
	{
        // Restore the position of the main view if it was animated to make room for the keyboard.
        if  (self.view.frame.origin.y < 0)
		{
            [self setViewMovedUp:NO];
        }
    }
}

// Animate the entire view up or down, to prevent the keyboard from covering the author field.
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (!editing)
	{
        [textFieldCell stopEditing];
        [textFieldRoundedCell stopEditing];
        [textFieldSecureCell stopEditing];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
    if ((textFieldRoundedCell.isInlineEditing || textFieldSecureCell.isInlineEditing) && self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
    }
	else if (!textFieldSecureCell.isInlineEditing && self.view.frame.origin.y < 0)
	{
        [self setViewMovedUp:NO];
    }
}


#pragma mark - UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
            name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
	
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

@end
