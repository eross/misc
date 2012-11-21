/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import "VPABWindow.h"

@implementation VPABWindow

//In Interface Builder we set CustomWindow to be the class for our window, so our own initializer is called here.
- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    
    
    //Call NSWindow's version of this function, but pass in the all-important value of NSBorderlessWindowMask
    //for the styleMask so that the window doesn't have a title bar
    //NSWindow* 
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    //Set the background color to clear so that (along with the setOpaque call below) we can see through the parts
    //of the window that we're not drawing into
    [self setBackgroundColor: [NSColor clearColor]];
    
    //This next line pulls the window up to the front on top of other system windows.  This is how the Clock app behaves;
    //generally you wouldn't do this for windows unless you really wanted them to float above everything.
    //[result setLevel: NSStatusWindowLevel];
    
    //Let's start with no transparency for all drawing into the window
    [self setAlphaValue:1.0];
    
    //but let's turn off opaqueness so that we can see through the parts of the window that we're not drawing into
    [self setOpaque:NO];
    
    //and while we're at it, make sure the window has a shadow, which will automatically be the shape of our custom content.
    [self setHasShadow: NO];
    
    //[self setLevel:-2147483628];
    
    [self setAcceptsMouseMovedEvents:YES];
    
    return self;
}

// Custom windows that use the NSBorderlessWindowMask can't become key by default.  Therefore, controls in such windows
// won't ever be enabled by default.  Thus, we override this method to change that.
- (BOOL) canBecomeKeyWindow {
    return YES;
}

// so we can get the keydowns
- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    
    int keyDown = [[theEvent characters] characterAtIndex:0];
    
    switch(keyDown) {
        
        case 27:    // the escape key
            
            // according to the HIG, escape should be used for "get me out of here" situations.
            [[self delegate] close];
            break;
            
        default:
            [super keyDown:theEvent];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    
    if (!NSMouseInRect([NSEvent mouseLocation], [self frame], NO)) {
        [self orderOut:self];
    }
}


@end
