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

File: PickerViewController.m
Abstract: The view controller for hosting the UIPickerView of this sample.

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

#import "PickerViewController.h"
#import "CustomPicker.h"
#import "Constants.h"

@implementation PickerViewController

#define kPickerSegmentControlHeight 30.0

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"PickerTitle", @"");
	}
	
	return self;
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
									screenRect.size.height - kToolbarHeight - 44.0 - size.height,
									size.width,
									size.height);
	return pickerRect;
}

#pragma mark 
#pragma mark UIPickerView
#pragma mark
- (void)createPicker
{
	pickerViewArray = [[NSArray arrayWithObjects:
							@"John Appleseed", @"Chris Armstrong", @"Serena Auroux",
							@"Susan Bean", @"Luis Becerra", @"Kate Bell", @"Alain Briere",
							nil] retain];
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	myPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
	myPickerView.frame = [self pickerFrameWithSize:pickerSize];

	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
}

#pragma mark 
#pragma mark UIPickerView - Date/Time
#pragma mark
- (void)createDatePicker
{
	datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	datePickerView.datePickerMode = UIDatePickerModeTime;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
	datePickerView.frame = [self pickerFrameWithSize:pickerSize];
}

#pragma mark 
#pragma mark UIPickerView - Custom Picker
#pragma mark
- (void)createCustomPicker
{
	customPickerView = [[CustomPicker alloc] initWithFrame:CGRectZero];
	customPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
	customPickerView.frame = [self pickerFrameWithSize:pickerSize];
}

- (void)showPicker:(UIView *)picker
{
	if (currentPicker)
	{
		[currentPicker removeFromSuperview];
		label.text = @"";
	}
	[self.view addSubview:picker];
	
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void)createButtonBar
{
	// create the button bar
	CGRect rect = [[UIScreen mainScreen] bounds];
	CGRect toolbarRect = rect;
	toolbarRect.size.height = 40.0;
	toolbarRect.origin.y = rect.size.height - 64.0 - toolbarRect.size.height;
	buttonBar = [[UIToolbar alloc] initWithFrame:toolbarRect];
	buttonBar.barStyle = UIBarStyleDefault;
	[self.view addSubview:buttonBar];

	// add a segmented control to the toolbar
	buttonBarSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"UIPicker", @"UIDatePicker", @"Custom", nil]];
	[buttonBarSegmentedControl addTarget:self action:@selector(togglePickers:) forControlEvents:UIControlEventValueChanged];
	buttonBarSegmentedControl.selectedSegmentIndex = 0.0;	// start by showing the normal picker
	buttonBarSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    buttonBarSegmentedControl.backgroundColor = [UIColor clearColor];
	[buttonBar addSubview:buttonBarSegmentedControl];

    // position the segmented control in the middle of the toolbar
    [buttonBar sizeToFit];
	[buttonBarSegmentedControl sizeToFit];

    CGRect segmentedControlFrame = buttonBarSegmentedControl.frame;
    CGRect toolbarFrame = buttonBar.frame;
    segmentedControlFrame.size.width = toolbarFrame.size.width - (kLeftMargin * 2.0);
    segmentedControlFrame.origin.x += (toolbarFrame.size.width - segmentedControlFrame.size.width)/2.0;
    segmentedControlFrame.origin.y += (toolbarFrame.size.height - segmentedControlFrame.size.height)/2.0;
    buttonBarSegmentedControl.frame = segmentedControlFrame;
}	

- (void)loadView
{		
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	
	// setup our parent content view and embed it to your view controller
	UIView *contentView = [[UIView alloc] initWithFrame:screenRect];
	contentView.backgroundColor = [UIColor blackColor];
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	self.view = contentView;
	[contentView release];
	
	[self createPicker];	
	[self createDatePicker];
	[self createCustomPicker];
	
	// label for picker selection output, place it right above the picker
	CGRect labelFrame = CGRectMake(	kLeftMargin,
									myPickerView.frame.origin.y - kTextFieldHeight,
									self.view.bounds.size.width - (kRightMargin * 2.0),
									kTextFieldHeight);
	label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont systemFontOfSize: 14];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	[self.view addSubview:label];
	
	[self createButtonBar];
	
	// create the segmented control to control the picker style (date/time/datetime)
	pickerStyleSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Time", @"Date", @"Date & Time", @"Counter", nil]];
	[pickerStyleSegmentedControl addTarget:self action:@selector(togglePickerStyle:) forControlEvents:UIControlEventValueChanged];
	pickerStyleSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    pickerStyleSegmentedControl.backgroundColor = [UIColor clearColor];
	[pickerStyleSegmentedControl sizeToFit];
	[self.view addSubview:pickerStyleSegmentedControl];
	pickerStyleSegmentedControl.hidden = YES;
	
	CGRect segmentedControlFrame = CGRectMake(0, kTopMargin, screenRect.size.width, kPickerSegmentControlHeight);
    pickerStyleSegmentedControl.frame = segmentedControlFrame;
		
	// start by showing the normal picker
	buttonBarSegmentedControl.selectedSegmentIndex = 0.0;
}

- (void)dealloc
{
	[pickerViewArray release];
	[myPickerView release];
	[datePickerView release];
	[label release];
	[customPickerView release];
	
	[pickerStyleSegmentedControl release];
	[buttonBarSegmentedControl release];
	[buttonBar release];
	
	[super dealloc];
}

- (void)togglePickerStyle:(id)sender
{
	UISegmentedControl *segControl = sender;
	switch (segControl.selectedSegmentIndex)
	{
		case 0:	// Time
		{
			datePickerView.datePickerMode = UIDatePickerModeTime;
			[self showPicker:datePickerView];
			break;
		}
		case 1: // Date
		{	
			datePickerView.datePickerMode = UIDatePickerModeDate;
			[self showPicker:datePickerView];
			break;
		}
		case 2:	// Date & Time
		{
			datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
			[self showPicker:datePickerView];	
			break;
		}
		case 3:	// Counter
		{
			datePickerView.datePickerMode = UIDatePickerModeCountDownTimer;
			[self showPicker:datePickerView];	
			break;
		}
	}
}

- (void)togglePickers:(id)sender
{
	UISegmentedControl *segControl = sender;
	switch (segControl.selectedSegmentIndex)
	{
		case 0:	// UIPickerView
		{
			pickerStyleSegmentedControl.hidden = YES;
			[self showPicker:myPickerView];
			break;
		}
		case 1: // UIDatePicker
		{	
			// start by showing the time picker
			
			// initially set the picker style to "time" format
			pickerStyleSegmentedControl.selectedSegmentIndex = 0.0;
			pickerStyleSegmentedControl.hidden = NO;
			[self showPicker:datePickerView];
			break;
		}
	
		case 2:	// Custom
		{
			pickerStyleSegmentedControl.hidden = YES;
			[self showPicker:customPickerView];	
			break;
		}
	}
}

- (void)pickerAction:(id)sender
{
	if (myPickerView != currentPicker)
		[self showPicker:myPickerView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// if you want to only support portrait mode, do this
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
	return YES;
}


#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component
{
	// report the selection to the UI label
	label.text = [NSString stringWithFormat:@"%@ - %d",
		[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]], [pickerView selectedRowInComponent:1]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component;
{
	NSString *returnStr;
	if (component == 0)
	{
		returnStr = [pickerViewArray objectAtIndex:row];
	}
	else
	{
		returnStr = [[NSNumber numberWithInt:row] stringValue];
	}
	return returnStr;
}

- (CGSize)pickerView:(UIPickerView *)pickerView rowSizeForComponent:(NSUInteger)component
{
	CGSize rowSize;
	if (component == 0)
		rowSize = CGSizeMake(250.0, 22.0);	// first column size is wider to hold names
	else
		rowSize = CGSizeMake(30.0, 22.0);	// second column is narrower to show numbers
	return rowSize;
}

- (NSUInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSUInteger)component
{
	return [pickerViewArray count];
}

- (NSUInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}


#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	[currentPicker removeFromSuperview];	// remove any picker that was showing
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{
	[self togglePickers:buttonBarSegmentedControl];	// make sure the last picker is still showing
}

@end
