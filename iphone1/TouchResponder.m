//
//  TouchResponder.m
//  iphone1
//
//  Created by Eric Ross on 7/6/09.
//  Copyright 2009 Eric Ross. All rights reserved.
//

#import "TouchResponder.h"


@implementation TouchResponder


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[UIView beginAnimations:@"stalk" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationBeginsFromCurrentState:YES];
	UITouch *touch = [touches anyObject];
	stalker.center = [touch locationInView:self];
	[UIView commitAnimations];
}
#if 0
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
#endif

- (void)dealloc {
    [super dealloc];
}


@end
