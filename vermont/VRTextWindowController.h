/*
 Vermont Recipes
 VRTextWindowController.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
 */

#import <Cocoa/Cocoa.h> // r17s3

@interface VRTextWindowController : NSWindowController { // r17s3
    @private // r17s3
    IBOutlet NSTextView *topNotesView; // r17s3
	IBOutlet NSTextView *bottomNotesView; // r17s3
	
	NSTextStorage *notesTextStorage; // r17s5
}

#pragma mark INITIALIZATION

- (id)initWithTextStorage:(NSTextStorage *)textStorage; // r17s5, designated initializer

@end
