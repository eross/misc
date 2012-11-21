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

File: ControlsViewController.m
Abstract: The view controller for hosting the UIControls features of this
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

#import "ControlsViewController.h"
#import "Constants.h"
#import "UICell.h"
#import "UISourceCell.h"

@implementation ControlsViewController

@synthesize myTableView;

#define kUISwitch_Section				0
#define kUISlider_Section				1
#define kUISlider_Custom_Section		2
#define kUIPageControl_Section			3
#define kUIProgressIndicator_Section	4
#define kUIProgressBar_Section			5


- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"ControlsTitle", @"");
	}
	return self;
}

- (void)dealloc
{
	[myTableView setDelegate:nil];
	[myTableView release];
	
	[switchCtl release];
	[sliderCtl release];
	[customSlider release];
	[pageControl release];
	[progressInd release];
	[progressBar release];
	
	[super dealloc];
}

#pragma mark 
#pragma mark UISwitch 
#pragma mark
- (void)create_UISwitch
{
	CGRect frame = CGRectMake(0.0, 0.0, kSwitchButtonWidth, kSwitchButtonHeight);
	switchCtl = [[UISwitch alloc] initWithFrame:frame];
	[switchCtl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl.backgroundColor = [UIColor clearColor];
}

- (void)switchAction:(id)sender
{
	NSLog(@"switchAction: value = %d", [sender isOn]);
}

#pragma mark
#pragma mark UISlider
#pragma mark
- (void)create_UISlider
{
	CGRect frame = CGRectMake(0.0, 0.0, 120.0, kSliderHeight);
	sliderCtl = [[UISlider alloc] initWithFrame:frame];
	[sliderCtl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	sliderCtl.backgroundColor = [UIColor clearColor];
	
	sliderCtl.minimumValue = 0.0;
	sliderCtl.maximumValue = 100.0;
	sliderCtl.continuous = YES;
	sliderCtl.value = 50.0;
}

#pragma mark
#pragma mark UISlider (Custom)
#pragma mark
- (void)create_Custom_UISlider
{
	CGRect frame = CGRectMake(0.0, 0.0, 120.0, kSliderHeight);
	customSlider = [[UISlider alloc] initWithFrame:frame];
	[customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	customSlider.backgroundColor = [UIColor clearColor];	
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"orangeslide.png"]
									stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	UIImage *stetchRightTrack = [[UIImage imageNamed:@"yellowslide.png"]
									stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	[customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forStates:UIControlStateNormal];
	[customSlider setMinimumTrackImage:stetchLeftTrack forStates:UIControlStateNormal];
	[customSlider setMaximumTrackImage:stetchRightTrack forStates:UIControlStateNormal];
	customSlider.minimumValue = 0.0;
	customSlider.maximumValue = 100.0;
	customSlider.continuous = YES;
	customSlider.value = 50.0;
}

- (void)sliderAction:(id)sender
{
	NSLog(@"sliderAction");
}

#pragma mark
#pragma mark UIPageControl
#pragma mark
- (void)create_UIPageControl
{
	CGRect frame = CGRectMake(0.0, 0.0, kPageControlWidth, kPageControlHeight);
	pageControl = [[UIPageControl alloc] initWithFrame:frame];
	[pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
		
	// in case the parent view draws with a custom color or gradient, use a transparent color
	pageControl.backgroundColor = [UIColor grayColor];
	
	pageControl.numberOfPages = 10;	// must be set or control won't draw
}

- (void)pageAction:(id)sender
{
	NSLog(@"pageAction: current page = %d", [sender currentPage]);
}

#pragma mark
#pragma mark UIProgressIndicator
#pragma mark
- (void)create_UIProgressIndicator:(UIProgressIndicatorStyle)style
{
	CGRect frame = CGRectMake(0.0, 0.0, kProgressIndicatorSize, kProgressIndicatorSize);
	progressInd = [[UIProgressIndicator alloc] initWithFrame:frame];
	[progressInd startAnimating];
	progressInd.progressIndicatorStyle = style;
	[progressInd sizeToFit];
	progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									UIViewAutoresizingFlexibleRightMargin |
									UIViewAutoresizingFlexibleTopMargin |
									UIViewAutoresizingFlexibleBottomMargin);
}

#pragma mark
#pragma mark UIProgressBar
#pragma mark
- (void)create_UIProgressBar
{
	CGRect frame = CGRectMake(0.0, 0.0, kUIProgressBarWidth, kUIProgressBarHeight);
	progressBar = [[UIProgressBar alloc] initWithFrame:frame];
	progressBar.progressBarStyle = UIProgressBarStyleGray;
	progressBar.progress = 0.5;
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
	
	[self create_UIProgressBar];
	[self create_UISwitch];
	[self create_UISlider];
	[self create_Custom_UISlider];
	[self create_UIPageControl];
	[self create_UIProgressIndicator:UIProgressIndicatorStyleGray];
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
		case kUISwitch_Section:
		{
			title = @"UISwitch";
			break;
		}
		case kUISlider_Section:
		{
			title = @"UISlider";
			break;
		}
		case kUISlider_Custom_Section:
		{
			title = @"UISlider";
			break;
		}
		case kUIPageControl_Section:
		{
			title = @"UIPageControl";
			break;
		}
		case kUIProgressIndicator_Section:
		{
			title = @"UIProgressIndicator";
			break;
		}
		case kUIProgressBar_Section:
		{
			title = @"UIProgressBar";
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
		case kUISwitch_Section:
		{
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((UICell*)cell).nameLabel.text = @"Standard Switch";
				((UICell*)cell).view = switchCtl;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_UISwitch";
			}
			break;
		}
		
		case kUISlider_Section:
		{
			if (row == 0)
			{
				// this cell hosts the UISlider control
				((UICell*)cell).nameLabel.text = @"Standard Slider";
				((UICell*)cell).view = sliderCtl;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_UISlider";
			}
			break;
		}
		
		case kUISlider_Custom_Section:
		{
			if (row == 0)
			{
				// this cell hosts the custom UISlider control
				((UICell*)cell).nameLabel.text = @"Customized Slider";
				((UICell*)cell).view = customSlider;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_Custom_UISlider";
			}
			break;
		}
		
		case kUIPageControl_Section:
		{
			if (row == 0)
			{
				// this cell hosts the UIPageControl control
				((UICell*)cell).nameLabel.text = @"Ten Pages";
				((UICell*)cell).view = pageControl;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_UIPageControl";
			}
			break;
		}
		
		case kUIProgressIndicator_Section:
		{
			if (row == 0)
			{
				// this cell hosts the UIProgressIndicator control
				((UICell*)cell).nameLabel.text = @"Style Gray";
				((UICell*)cell).view = progressInd;	
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_UIProgressIndicator";
			}
			break;
		}
		
		case kUIProgressBar_Section:
		{
			if (row == 0)
			{
				// this cell hosts the UIProgressIndicator control
				((UICell*)cell).nameLabel.text = @"Style Gray";
				((UICell*)cell).view = progressBar;
			}						
			else
			{
				// this cell hosts the info on where to find the code
				((UISourceCell*)cell).sourceLabel.text = @"ControlsViewController.m - create_UIProgressBar";
			}
			break;
		}
	}
	
	return cell;
}

@end
