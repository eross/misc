//
//  AppController.h
//  keyval
//
//  Created by Eric Ross on 9/14/08.
//  Copyright 2008 Hewlett Packard. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {

	IBOutlet NSSlider *slider;
	IBOutlet NSTextField *textfield;
}
@property (readwrite, assign ) int sliderVal;

//- (int) sliderVal;

//- (void)setSliderVal:(int)x;
-(IBAction)decrease: (id) sender;
-(IBAction)increase: (id) sender;

@end
