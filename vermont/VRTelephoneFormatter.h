/*
 Vermont Recipes
 VRTelephoneFormatter.h
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 This telephone number formatter acts as an on-the-fly filter to prevent the user from typing any printable characters in a text field other than the numeric digits 0..9 and the North American conventional telephone number delimiters "(", ")", " " (a space character), and "-" (ignoring the delimiters). It also formats a telephone number on the fly in conventional North American format (for example, "(800) 555-1212"), inserting delimiters automatically while the user types, cuts, pastes, deletes, or forward deletes.
*/

#import <Foundation/Foundation.h> // r6s3

@interface VRTelephoneFormatter : NSFormatter { // r6s3
	@protected
    NSCharacterSet *telephoneDelimitersCharacterSet;
    NSCharacterSet *invertedDecimalDigitPlusTelephoneDelimitersCharacterSet;
}

@end
