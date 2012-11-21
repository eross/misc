///////////////////////////////////////////////////////////////
//                                                           //
//  SegmentedView.h					     //
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

#import <Cocoa/Cocoa.h>

@interface SegmentedView : NSView {
    IBOutlet NSTextField *display;
    NSSegmentedControl *segControl;
}

- (IBAction)controlClicked:(id)sender;
@end