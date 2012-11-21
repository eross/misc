/*
 Vermont Recipes
 VRIntegerNumberFilter.h
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 This integer number formatter acts as an on-the-fly filter to prevent the user from typing any printable characters in a text field other than the numeric digits 0..9.
*/

#import <Foundation/Foundation.h> // r6s1

@interface VRIntegerNumberFilter : NSNumberFormatter { // r6s1
}

@end
