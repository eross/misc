/*
 Vermont Recipes
 VRDecimalNumberFilter.m
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRDecimalNumberFilter.h" // r6s2
#import "NSFormatter+VRFormatterBugfixes.h" // r6s2

@implementation VRDecimalNumberFilter // r6s2

//Initialization

- (id)init { // r6s2
	// Override method. The formatter initializes these instance variables when the formatter is created and connected to a text field, in order to minimize overhead during typing. It accesses the instance variables directly rather than through accessor methods for the same reason.
    if (self = [super init]) {
		NSMutableCharacterSet *tempSet;
		NSCharacterSet *decimalDigitPlusLocalizedSeparatorsCharacterSet;

		localizedDecimalSeparatorString = [[NSUserDefaults standardUserDefaults] objectForKey:NSDecimalSeparator];
        localizedThousandsSeparatorString = [[NSUserDefaults standardUserDefaults] objectForKey:NSThousandsSeparator];

        tempSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
        [tempSet addCharactersInString:[localizedDecimalSeparatorString stringByAppendingString:localizedThousandsSeparatorString]];
        decimalDigitPlusLocalizedSeparatorsCharacterSet = [tempSet copy];
        [tempSet release];

		invertedDecimalDigitPlusLocalizedSeparatorsCharacterSet = [[decimalDigitPlusLocalizedSeparatorsCharacterSet invertedSet] retain];
		[decimalDigitPlusLocalizedSeparatorsCharacterSet release];
    }
    return self;
}

- (void)dealloc { // r6s2
	// Override method.
    [invertedDecimalDigitPlusLocalizedSeparatorsCharacterSet release];
    [super dealloc];
}

// Input validation and formatting

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error { // r6s2
	// Override method. Implements on-the-fly input filtering and formatting of a decimal number while the user types, cuts, pastes, deletes, forward deltes, or drags and drops characters within the text field. It enables NSControl's control:didFailToValidatePartialString:errorDescription: delegate method to reject invalid key presses on the fly, preventing entry of all characters other than the numerical digits 0..9, the localized thousands separator, and a single localized decimal separator. It automatically inserts localized thousands separators in the correct locations on the fly and adjusts the insertion point accordingly, effectively ignoring thousands separators typed by the user.

	// Basic strategy: First, reject invalid characters typed or pasted into the text field. Second, strip delimiters from the contents of the text field, because they are in incorrect locations after editing. Third, restore delimiters to the text field in the correct locations after editing. Leaves the *partialStringPtr and *proposedSelRangePtr parameters undisturbed until the end, so they will remain available if needed. Adjusts local variables tempPartialString and tempProposedSelRangeLocation as delimiters are stripped and restored, so the proposed insertion point remains between the correct digits at all times. At the end, assigns tempPartialString to *partialStringPtr to return a new formatted string to the caller by reference for display in the text field, and assigns tempProposedSelRangeLocation to proposedSelRangePtr->location to return a new selection range to the caller by reference to position the new insertion point correctly in the text field.

	// NSFormatter bugs: This version of VRTelephoneFormatter imports the NSFormatter+VRFormatterBugfixes category to work around one bug in NSFormatter as of Mac OS X 10.1.3 and the December 2001 Developer Tools. Call the deleteBugfix: method near the beginning of this method, to assign a corrected value to the originalSelectedRange: parameter when the Delete key is pressed in the text field. This bugfix method requires the AppKit, but because it is implemented in a category, this formatter can still import Foundation alone as specified for formatters. It is believed that formatters using this bugfix method will continue to work correctly after Apple fixes the bug.

	NSString *tempPartialString; // Local stand-in for *partialStringPtr parameter
	int tempProposedSelRangeLocation; // Local stand-in for proposedSelRangePtr->location parameter element

	NSString *insertedString; // Characters typed or pasted by user, if any, as string
	
    NSScanner *scanner; // Used to strip delimiters from tempPartialString

    int thousandsSeparatorLocation;
    int decimalSeparatorLocation;
    int remainingIntegerPart;

	BOOL deleting; // Detect Delete key for special handling while restoring thousands separators

	if ([*partialStringPtr length] == 0) {
		// User deleted or cut all characters, so there is nothing to filter or format.
		[self emptyBugfix:*partialStringPtr];
		// Guarantee state of insertion point if field is empty. See NSFormatter+VRFormatterBugfixes category for information.
		return YES; // Accept *partialStringPtr
	} else {
		origSelRange = [self deleteBugfix:origSelRange];
		// Guarantee that origSelRange is correct. See NSFormatter+VRFormatterBugfixes category for information.
	
		deleting = (origSelRange.location - proposedSelRangePtr->location) == 1;

		if (proposedSelRangePtr->location <= origSelRange.location) {
			// User deleted or cut some characters; proposed insertion point is unchanged if cut or pressed Forward Delete key, or moved left by one position if pressed Delete key.
			insertedString = @""; // Nothing typed or pasted
		} else {
			// User typed or pasted characters; proposed insertion point moved right to end of proposed insertion.
			insertedString = [*partialStringPtr substringWithRange:NSMakeRange(origSelRange.location, proposedSelRangePtr->location - origSelRange.location)]; // Characters typed or pasted

			// Reject invalid characters

			if ([insertedString rangeOfCharacterFromSet:invertedDecimalDigitPlusLocalizedSeparatorsCharacterSet options:NSLiteralSearch].location != NSNotFound) {
				*error = [NSString stringWithFormat:NSLocalizedString(@"Ò%@Ó is not allowed in a decimal number.", @"Presented when typed or pasted value contains a character other than a numeric digit or localized thousands or decimal separator"), insertedString];
				return NO; // Reject *partialStringPtr, invoke NSControl delegate method with error message
			} else {
				// If localized decimal separator found, search remainder of string for another.
				decimalSeparatorLocation = [*partialStringPtr rangeOfString:localizedDecimalSeparatorString options:NSLiteralSearch].location;
				if ((decimalSeparatorLocation != NSNotFound) && ([*partialStringPtr length] - 1 > decimalSeparatorLocation) && ([[*partialStringPtr substringFromIndex:decimalSeparatorLocation + 1] rangeOfString:localizedDecimalSeparatorString options:NSLiteralSearch].location != NSNotFound)) {
					*error = [NSString stringWithFormat:NSLocalizedString(@"Ò%@Ó can't be entered more than once.", @"Presented when typed or pasted value contains a second decimal separator"), localizedDecimalSeparatorString];
					return NO; // Reject *partialStringPtr, invoke NSControl delegate method with error message
				}
			}
		}

		if ([localizedThousandsSeparatorString isEqualToString: @""]) {
			// Don't format for thousands separators if "None" selected in system preferences
			return YES;
		} else {

			tempPartialString = @""; // Initialize
			tempProposedSelRangeLocation = proposedSelRangePtr->location; // Initialize
	
			// Scan for thousands separators and discard them, adjusting insertion point.
			
			scanner = [NSScanner localizedScannerWithString:*partialStringPtr];
			[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
			// Allow removal of white space used as thousands separator in some languages (scanners default to skip white space).
			
			while (![scanner isAtEnd]) {
				NSString *tempString;
				if ([scanner scanUpToString:localizedThousandsSeparatorString intoString:&tempString]) {
					// Accumulate digits and decimal separator
					tempPartialString = [tempPartialString stringByAppendingString:tempString];
				} else if ([scanner scanString:localizedThousandsSeparatorString intoString:nil]) {
					// Discard thousands separator; decrement proposed insertion point if to right of discarded thousands separator
					if ([scanner scanLocation] <= proposedSelRangePtr->location + [insertedString length]) {
						tempProposedSelRangeLocation--;
					}
				}
			}
		
			// Loop to insert thousands separators where appropriate, adjusting insertion point.
			
			thousandsSeparatorLocation = 1; // Initialize to track location for next separator
			decimalSeparatorLocation = [tempPartialString rangeOfString:localizedDecimalSeparatorString options:NSLiteralSearch].location;
			remainingIntegerPart = (decimalSeparatorLocation == NSNotFound) ? [tempPartialString length] - 1 : decimalSeparatorLocation - 1;  // Initialize to track number of digits remaining in integer part
	
			// Insert separator
			while (remainingIntegerPart > 2) {
				if (remainingIntegerPart % 3 == 0) {
					// Insert thousands separator at thousandsSeparatorLocation
					tempPartialString = [NSString stringWithFormat:@"%@%@%@", [tempPartialString substringToIndex:thousandsSeparatorLocation], localizedThousandsSeparatorString, [tempPartialString substringFromIndex:thousandsSeparatorLocation]];
					if ((thousandsSeparatorLocation <= proposedSelRangePtr->location) && !(deleting && [[tempPartialString substringWithRange:NSMakeRange(proposedSelRangePtr->location, 1)] isEqualToString:localizedThousandsSeparatorString])) {
						// Increment proposed insertion point if to right of new thousands separator, or if user deleted over thousands separator
						tempProposedSelRangeLocation++;
					}
					thousandsSeparatorLocation++;
				}
				thousandsSeparatorLocation++;
				remainingIntegerPart--;
			}
	
			*partialStringPtr = tempPartialString;
			*proposedSelRangePtr = NSMakeRange(tempProposedSelRangeLocation, 0);
				
			[self emptyBugfix:*partialStringPtr];
			// Guarantee state of insertion point if field is emptied programmatically. See NSFormatter+VRFormatterBugfixes category for information.

			*error = nil; // Signal NSControl that no error occurred
			return NO; // Display *partialStringPtr as edited; invokes delegate method but signals no error by returning nil in errorDescription parameter.
		}
	}
}

@end
