///////////////////////////////////////////////////////////////
//                                                           //
//  SegmentedView.m					     //
//  SegmentedControls                                        //
//                                                           //
//  Created by Jacob on Tue Nov 11 2003.                     //
//  Copyright © 2003 - Nance Software. All rights reserved.  //  
//                                                           //
//  This program is distributed in the hope that it will be  //
//  useful, but WITHOUT ANY WARRANTY; without even the       //
//  implied warranty of but WITHOUT ANY WARRANTY; without    //
//  even the implied warranty of MERCHANTABILITY or FITNESS  //
//  FOR A PARTICULAR PURPOSE.				     //
//                                                           //
///////////////////////////////////////////////////////////////

#import "SegmentedView.h"

@implementation SegmentedView

- (id)initWithFrame:(NSRect)frameRect {
    [super initWithFrame:frameRect];
    segControl = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)];
    
    // Set the tracking mode and control size
    [[segControl cell] setTrackingMode:NSSegmentSwitchTrackingSelectOne];
    [[segControl cell] setControlSize:NSRegularControlSize];
    // Set the segmented control's target to self
    [segControl setTarget:self];
    // Set the segmented control's action to the IBAction controlClick:
    [segControl setAction:@selector(controlClicked:)];
    
    // Set the number of segments... Remember, the
    // segment count doesn't start with 0, while
    // when working with segments, they start with 0
    [segControl setSegmentCount:4];
    
    // Set the tag's for the segments. 
    [[segControl cell] setTag:0 forSegment:0];
    [[segControl cell] setTag:1 forSegment:1];
    [[segControl cell] setTag:2 forSegment:2];
    [[segControl cell] setTag:3 forSegment:3];

    
    // Set titles for each segment
    // This example show how to make a control similar
    // to that used in iCal. iCal uses images for the
    // background however.
    [segControl setLabel:@"Day" forSegment:0];
    [segControl setLabel:@"Week" forSegment:1];
    [segControl setLabel:@"Month" forSegment:2];
    [segControl setLabel:@"Year" forSegment:3];
    
    // Set the default selected segment
    [segControl setSelectedSegment:2];
    
    // Set the width of the segments
    [segControl setWidth:46 forSegment:0];
    [segControl setWidth:46 forSegment:1];
    [segControl setWidth:46 forSegment:2];
    [segControl setWidth:46 forSegment:3];


    // Add the NSSegmenetedControl to our view
    [self addSubview:segControl];
    return self;
}

- (void)awakeFromNib {
    // Click segControl control
    [self controlClicked:segControl];
}

- (void)drawRect:(NSRect)rect {
}

- (IBAction)controlClicked:(id)sender {
    int selectedSegment = [sender selectedSegment];
    int clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
    
    if (clickedSegmentTag == 0) {
	NSLog(@"Day selected.");
	[display setStringValue:@"Day selected"];
    } else if (clickedSegmentTag == 1) {
	NSLog(@"Week selected.");
	[display setStringValue:@"Week selected"];
    } else if (clickedSegmentTag == 2) {
	NSLog(@"Month selected.");
	[display setStringValue:@"Month selected"];
    }
}

@end