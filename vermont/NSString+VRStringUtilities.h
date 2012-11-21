/*
 Vermont Recipes
 NSString+VRStringUtilities.h
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Foundation/NSString.h> // r2s2.7

@interface NSString (VRStringUtilities) // r2s2.7

// Accessor methods to extend to Boolean values the technique used by other, built-in NSString accessor methods to convert between common C values and NSString objects.
+ (id)stringWithBool:(BOOL)inValue; // r2s2.7
- (BOOL)boolValue; // r2s2.7

// Accessor methods to extend to VRParty enumeration values the technique used by other, built-in NSString accessor methods to convert between common C values and NSString objects.
+ (id)stringWithVRParty:(int)inValue; // r2s4.3
- (int)VRPartyValue; // r2s4.3

// Accessor methods to extend to VRState enumeration values the technique used by other, built-in NSString accessor methods to convert between common C values and NSString objects.
+ (id)stringWithVRState:(int)inValue; // r2s5.2
- (int)VRStateValue; // r2s5.2

@end
