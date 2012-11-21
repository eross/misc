/*
 Vermont Recipes
 NSFormatter+VRFormatterBugfixes.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Foundation/NSFormatter.h> // r6s2

@interface NSFormatter (VRFormatterBugfixes) // r6s2

// Methods to work around bugs in NSFormatter.
- (NSRange)deleteBugfix:(NSRange)origSelRange; // r6s2
- (void)emptyBugfix:(NSString *)partialString; // r6s2

@end