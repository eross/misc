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

File: UIPickerColorViews.m
Abstract: The list of CustomColorView to hold each color.

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

#import "UIPickerColorViews.h"
#import "CustomColorView.h"

@implementation UIPickerColorViews

- (id)init
{
	self = [super init];
	if (self)
	{
		colorViews = [[NSMutableArray alloc] init];

		CGRect colorRect = CGRectMake(0.0, 0.0, 44.0, 44.0);
		
		NSArray *orange = [[NSArray alloc] initWithObjects:
							[NSNumber numberWithFloat:.255], [NSNumber numberWithFloat:.140],
							[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], nil];
		CustomColorView *orangeView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:orange];
		[colorViews addObject:orangeView];
		[orangeView release];
		[orange release];
		
		NSArray *pink = [[NSArray alloc] initWithObjects:
							[NSNumber numberWithFloat:.255], [NSNumber numberWithFloat:.105],
							[NSNumber numberWithFloat:.180], [NSNumber numberWithFloat:1], nil];
		CustomColorView *pinkView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:pink];
		[colorViews addObject:pinkView];
		[pinkView release];
		[pink release];
		
		NSArray *purple = [[NSArray alloc] initWithObjects:
							[NSNumber numberWithFloat:.159], [NSNumber numberWithFloat:.121],
							[NSNumber numberWithFloat:.238], [NSNumber numberWithFloat:1], nil];
		CustomColorView *purpleView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:purple];
		[colorViews addObject:purpleView];
		[purpleView release];
		[purple release];
		
		NSArray *red = [[NSArray alloc] initWithObjects:
							[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0],
							[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], nil];
		CustomColorView *redView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:red];
		[colorViews addObject:redView];
		[redView release];
		[red release];
		
		NSArray *yellow = [[NSArray alloc] initWithObjects:
							[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:1],
							[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], nil];
		CustomColorView *yellowView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:yellow];
		[colorViews addObject:yellowView];
		[yellowView release];
		[yellow release];
		
		NSArray *turquoise = [[NSArray alloc] initWithObjects:
								[NSNumber numberWithFloat:.173], [NSNumber numberWithFloat:.234],
								[NSNumber numberWithFloat:.234], [NSNumber numberWithFloat:1], nil];
		CustomColorView *turquoiseView = [[CustomColorView alloc] initWithFrame:colorRect rgbFloatColorArray:turquoise];
		[colorViews addObject:turquoiseView];
		[turquoiseView release];
		[turquoise release];
	}
	
	return self;
}

- (NSMutableArray *)getPickerColors
{
	return colorViews;	
}

- (void)dealloc
{
	[colorViews release];
	[super dealloc];
}

@end
