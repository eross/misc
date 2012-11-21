/*
 Vermont Recipes
 VRUndoableForm.h
 Copyright � 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 Adopts the VRUndoableTextControl formal protocol to bring "live" undo and redo to text-based user controls.
*/

#import <Cocoa/Cocoa.h> // r9s5
#import "VRUndoableTextControl.h" // r9s5

@interface VRUndoableForm : NSForm <VRUndoableTextControl> { // r9s5
}

@end
