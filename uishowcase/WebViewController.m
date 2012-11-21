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

File: WebViewController.m
Abstract: The view controller for hosting the UIWebView feature of this sample.

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

#import "WebViewController.h"
#import "ButtonsViewController.h"	// to use buttonWithTitle
#import "Constants.h"

@implementation WebViewController

- (id)init
{
	if (self = [super init])
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"WebTitle", @"");
	}
	return self;
}

- (void)dealloc
{
	[webView release];
	[urlField release];
	
	[super dealloc];
}

- (void)loadView
{
	// the base view for this view controller
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor whiteColor];
	
	// important for view orientation rotation
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	self.view = contentView;
	self.view.autoresizesSubviews = YES;
	
	[contentView release];
	
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y += kTopMargin + 5.0;	// leave from the URL input field and its label
	webFrame.size.height -= 40.0;
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	webView.backgroundColor = [UIColor whiteColor];
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview: webView];
		
	// left button	
	UIImage *image = [UIImage imageNamed:@"LeftArrow.png"];
	CGRect frame = CGRectMake(5.0, 10.0, image.size.width, image.size.height);
	UIButton *button = [ButtonsViewController buttonWithTitle:nil
								target:self
								selector:@selector(backAction:)
								frame:frame
								image:image
								imagePressed:[UIImage imageNamed:@"LeftArrowPressed.png"]
								darkTextColor:NO];
	[self.view addSubview:button];

	// right button
	image = [UIImage imageNamed:@"RightArrow.png"];
	frame = CGRectMake(45.0, 10.0, image.size.width, image.size.height);
	button = [ButtonsViewController buttonWithTitle:nil
								target:self
								selector:@selector(forwardAction:)
								frame:frame
								image:image
								imagePressed:[UIImage imageNamed:@"RightArrowPressed.png"]
								darkTextColor:NO];
	[self.view addSubview:button];

	// reload button
	image = [UIImage imageNamed:@"reload.png"];
	frame = CGRectMake(85.0, 10.0, image.size.width, image.size.height);
	button = [ButtonsViewController buttonWithTitle:nil
								target:self
								selector:@selector(reloadAction:)
								frame:frame
								image:image
								imagePressed:[UIImage imageNamed:@"reload_tap.png"]
								darkTextColor:NO];
	[self.view addSubview:button];
		
	CGRect textFieldFrame = CGRectMake(120.0, 10.0, self.view.bounds.size.width - 130.0, 26.0);
	urlField = [[UITextField alloc] initWithFrame:textFieldFrame];
    urlField.borderStyle = UITextFieldBorderStyleBezel;
    urlField.textColor = [UIColor blackColor];
    urlField.font = [UIFont systemFontOfSize:14.0];
    urlField.delegate = self;
    urlField.placeholder = @"<enter a URL>";
    urlField.text = @"http://www.apple.com";
	urlField.backgroundColor = [UIColor whiteColor];
	urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	urlField.returnKeyType = UIReturnKeyDone;
	urlField.keyboardType = UIKeyboardTypeURL;	// this makes the keyboard more friendly for typing URLs
	[self.view addSubview:urlField];

	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// if you want to only support portrait mode, use this:
	//return YES;
	
	return NO;
}

- (void)backAction:(id)sender
{
	[webView goBack];
}

- (void)forwardAction:(id)sender
{
	[webView goForward];
}

- (void)reloadAction:(id)sender
{
	[webView reload];
}

// this helps dismiss the keyboard then the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];
	return YES;
}

@end
