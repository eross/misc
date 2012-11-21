//
//  AppController.m
//  keyval
//
//  Created by Eric Ross on 9/14/08.
//  Copyright 2008 Hewlett Packard. All rights reserved.
//

#import "AppController.h"


@implementation AppController
@synthesize sliderVal;

#if EXPLICIT_PROPERTIES
- (int) sliderVal
{
	NSLog(@"-sliderVal is returning %d", sliderVal);
	return sliderVal;s
}

- (void)setSliderVal:(int)x
{
	NSLog(@"-setSliderVal: is called with %d", x);
	sliderVal = x;
}
#endif

- (IBAction) increase: (id) sender
{
	if([self sliderVal] < 50)
	{
		[self setSliderVal:[self sliderVal] + 1];
	}
}

- (IBAction) decrease: (id) sender
{
	if([self sliderVal] > -50)
	{
		[self setSliderVal:[self sliderVal] - 1];
	}
}
@end
