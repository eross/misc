/*
 Vermont Recipes
 VRAppDelegate.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r15s2
#import "VRPreferencesWindowController.h" // r18s2

@interface VRAppDelegate : NSObject { // r15s2
	IBOutlet NSMenu *dynamicDockMenu; // r15s2
	NSWindowController *preferencesWindowController; // r18s2
}

- (BOOL)isPumaOrNewer; // r21s1
- (BOOL)isJaguarOrNewer; // r21s1

#pragma mark ACTIONS

- (IBAction)openPreferencesWindowAction:(id)sender; // r18s2
- (IBAction)showReadMeAction:(id)sender; // r20s3

@end
