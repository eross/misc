/*
 Vermont Recipes
 VRPreferencesWindowController.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r18s2

@interface VRPreferencesWindowController : NSWindowController { // r18s2
    @private
    IBOutlet NSButton *checkbox;
	IBOutlet NSTextField *speedTextField;
}

#pragma mark ACCESSORS

- (NSButton *)checkbox; // r18s2
- (NSTextField *)speedTextField; // r18s2

#pragma mark ACTIONS

- (IBAction)checkboxAction:(id)sender; // r18s2
- (IBAction)speedTextFieldAction:(id)sender; // r18s2
- (IBAction)closeButtonAction:(id)sender; // r18s2

@end
