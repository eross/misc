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

File: FlipViewController.m
Abstract: The view controller for showing flip animation with UIViews.

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

#import "FlipViewController.h"
#import "ButtonsViewController.h"	// to use buttonWithTitle
#import "Constants.h"

@implementation FlipViewController

#define kImageHeight		200.0
#define kImageWidth			250.0
#define kTransitionDuration	0.75
#define kTopPlacement		80.0	// y coord for the images

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"FlipTitle", @"");
	}
	return self;
}

- (void)dealloc
{
	[mainView release];
	[flipToView release];
	[containerView release];
	
	[super dealloc];
}

// create the alternate view that we flip to.
// In this case, it's almost exactly the same except for differnt photos
//
- (void)createAlternateFlipView
{
	CGRect imageFrame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
	flipToView = [[UIImageView alloc] initWithFrame:imageFrame];
	flipToView.image = [UIImage imageNamed:@"scene2.jpg"];
}

- (void)loadView
{
	// add the top-most parent view
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
	
	// create the container view which we will use for flip animation (centered horizontally)
	CGRect frame = CGRectMake((self.view.bounds.size.width - kImageWidth) / 2.0, kTopPlacement, kImageWidth, kImageHeight);
	containerView = [[UIView alloc] initWithFrame:frame];
	[self.view addSubview:containerView];
	
	// create the initial image view
	frame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
	mainView = [[UIImageView alloc] initWithFrame:frame];
	mainView.image = [UIImage imageNamed:@"scene1.jpg"];
	[containerView addSubview:mainView];
	
	// create the alternate image view (to flip between)
	[self createAlternateFlipView];
	
	// create the flip button	
	frame = CGRectMake(	(self.view.bounds.size.width - kStdButtonWidth) / 2.0,
						self.view.bounds.size.height - (kStdButtonHeight * 2.0) - kTweenMargin,
						kStdButtonWidth,
						kStdButtonHeight);
	UIButton *flipButton = [ButtonsViewController buttonWithTitle:NSLocalizedString(@"FlipTitle", @"")
								target:self
								selector:@selector(flipAction:)
								frame:frame
								image:[UIImage imageNamed:@"grayButton.png"]
								imagePressed:[UIImage imageNamed:@"blueButton.png"]
								darkTextColor:NO];
	[self.view addSubview:flipButton];
}

- (void)flipAction:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTransitionDuration];
		
	[UIView setAnimationTransition:([mainView superview] ?
										UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
										forView:containerView cache:YES];
	if ([flipToView superview])
	{
		[flipToView removeFromSuperview];
		[containerView addSubview:mainView];
	}
	else
	{
		[mainView removeFromSuperview];
		[containerView addSubview:flipToView];
	}
	
	[UIView commitAnimations];
}


#pragma mark UIViewController delegate methods

// called after this controller's view has appeared
- (void)viewWillAppear:(BOOL)animated
{
	// for aesthetic reasons (the background is black), make the nav bar black for this particular page
	self.navigationController.navigationBarStyle = UIBarStyleBlackOpaque;
}

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBarStyle = UIBarStyleDefault;
}

@end
