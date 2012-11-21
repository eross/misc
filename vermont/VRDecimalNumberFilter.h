/*
 Vermont Recipes
 VRDecimalNumberFilter.h
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 This decimal number formatter acts both as an on-the-fly filter to prevent the user from typing any printable characters other than the numeric digits, the localized thousands separator, and a single localized decimal separator, and as an on-the-fly formatter to add localized thousands separators. It is designed to permit a user to enter a decimal number in a text field seamlessly, typing digits, deleting them backward and forward, and cutting and pasting them, in any order, as if the number did not contain thousands separators. When a character or selection is deleted by any means, the insertion point is left where the character or selection was located, so that the same character or other characters can be retyped or pasted in place, even though the thousands separators may have moved as a result of the deletion.
*/

#import <Foundation/Foundation.h> // r6s2

@interface VRDecimalNumberFilter : NSNumberFormatter { // r6s2
    @protected
    NSString *localizedDecimalSeparatorString;
    NSString *localizedThousandsSeparatorString;
    NSCharacterSet *invertedDecimalDigitPlusLocalizedSeparatorsCharacterSet;
}

@end
