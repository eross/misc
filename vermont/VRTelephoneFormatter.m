/*
 Vermont Recipes
 VRTelephoneFormatter.m
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRTelephoneFormatter.h"
#import "NSFormatter+VRFormatterBugfixes.h" // r6s3

@implementation VRTelephoneFormatter // r6s3

//Initialization

- (id)init { // r6s3
	// Override method. The formatter initializes these instance variables when the formatter is created and connected to a text field, in order to minimize overhead during typing. It accesses the instance variables directly rather than through accessor methods for the same reason.
    if (self = [super init]) {
		NSMutableCharacterSet *tempSet;
		NSCharacterSet *decimalDigitPlusTelephoneDelimitersCharacterSet;

		telephoneDelimitersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"() -"] retain];

		tempSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
        [tempSet addCharactersInString:@"() -"];
        decimalDigitPlusTelephoneDelimitersCharacterSet = [tempSet copy];
        [tempSet release];

		invertedDecimalDigitPlusTelephoneDelimitersCharacterSet = [[decimalDigitPlusTelephoneDelimitersCharacterSet invertedSet] retain];
		[decimalDigitPlusTelephoneDelimitersCharacterSet release];
	}
    return self;
}

- (void)dealloc { // r6s3
	// Override method.
    [telephoneDelimitersCharacterSet release];
    [invertedDecimalDigitPlusTelephoneDelimitersCharacterSet release];
    [super dealloc];
}

// Output validation

- (NSString *)stringForObjectValue:(id)object { // r6s3
	// Override method. Returns a string in conventional North American telephone number format (for example, "(800) 555-1212"). Because the formatter already holds an NSString object, it is not necessary to convert it to a string. This method is overridden to avoid the exception raised by the default implementation.
    if (![object isKindOfClass:[NSString class]]) {
        return nil;
	}
	return object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error { // r6s3
	// Override method. Returns a string by reference in object in conventional North American telephone number format (for example, "(800) 555-1212"). Because the incoming string is an NSString, it is not necessary to convert it to a string. This method is overridden to avoid the exception raised by the default implementation. It does minimal validity testing (only for correct length) because the on-the-fly filter and formatter assures that the form of the string will be correct. It also enables the NSControl delegate method control:didFailToFormatString:errorDescription to reject a telephone number of the wrong length with an error message.

 if (([string length] == 0) || ([string length] == 14)) {
        *object = string;
        return YES; // Object is accepted
    } else if ([string length] < 14) {
        *error = NSLocalizedString(@"Telephone number is too short.", @"Presented when telephone number is too short");
        return NO; // Object is rejected
	} else {
		*error = NSLocalizedString(@"Telephone number is too long.", @"Presented when telephone number is too long");
		return NO; // Object is rejected
	}
}

// Input validation and formatting

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error { // r6s3
	// Override method. Implements on-the-fly input filtering and formatting of a telephone number in the conventional North American format (for example, "(800) 555-1212") while the user types, cuts, pastes, deletes, forward deletes, or drags and drops characters within the text field. It enables NSControl's control:didFailToValidatePartialString:errorDescription: delegate method to reject invalid key presses on the fly, preventing entry of all characters other than the numerical digits 0-9 and the conventional delimiters. It automatically inserts the conventional delimiters "(", ")", " " (a space character), and "-" in the correct locations on the fly and adjusts the insertion point accordingly, effectively ignoring delimiters typed by the user.

	// Basic strategy: First, reject invalid characters typed or pasted into the text field. Second, strip delimiters from the contents of the text field, because they are in incorrect locations after editing. Third, restore delimiters to the text field in the correct locations after editing. Leaves the *partialStringPtr and *proposedSelRangePtr parameters undisturbed until the end, so they will remain available if needed. Adjusts local variables tempPartialString and tempProposedSelRangeLocation as delimiters are stripped and restored, so the proposed insertion point remains between the correct digits at all times. At the end, assigns tempPartialString to *partialStringPtr to return a new formatted string to the caller by reference for display in the text field, and assigns tempProposedSelRangeLocation to proposedSelRangePtr->location to return a new selection range to the caller by reference to position the new insertion point correctly in the text field. Telephone numbers that are too short or too long are rejected only when the user commits the data in the formatter's getObjectValue:forString:errorDescription: method. 

	// Drag and drop editing issues: Cocoa provides drag and drop editing within text fields. Drag and drop occurs in two phases, the first phase to "paste" the dragged characters into their destination and the second phase to "cut" the dragged characters from their source. This has two consequences for formatters: (1) Numbers that are too long cannot be rejected on the fly, because the "paste" phase comes second and may therefore result temporarily in a number that is too long because delimiter characters may be included. (2) Formatting must be suppressed between the "paste" and "cut" phases, because the "cut" phase does not update its selection range parameters on account of characters that might otherwise have been inserted or deleted after the "paste" phase.

	// NSFormatter bugs: This version of VRTelephoneFormatter imports the NSFormatter+VRFormatterBugfixes category to work around two bugs in NSFormatter as of Mac OS X 10.1.3 and the December 2001 Developer Tools. (1) Call the deleteBugfix: method near the beginning of this method, to assign a corrected value to the originalSelectedRange: parameter when the Delete key is pressed in the text field. (2) Call the emptyBugfix: method twice, once near the beginning and once near the end of this method, before setting *error to nil and returning NO, to fix the text field's selection after the last character in the text field is deleted programmatically by the formatter. Both of these bugfix methods require the AppKit, but because they are implemented in a category, this formatter can still import Foundation alone as specified for formatters. It is believed that formatters using these bugfix methods will continue to work correctly after Apple fixes the bugs.

	NSString *tempPartialString; // Local stand-in for *partialStringPtr parameter
	int tempProposedSelRangeLocation; // Local stand-in for proposedSelRangePtr->location parameter element
	
	NSString *insertedString; // Characters typed or pasted by user, if any, as string
	
	NSScanner *scanner; // Used to strip delimiters from tempPartialString
	NSString *accumulatedDigits; // Used to hold temporary scanner output
	NSString *discardedDelimiters; // Used to hold temporary scanner output

	int index; // Loop counter used to restore delimiters to tempPartialString
	BOOL deleting; // Detect Delete key for special handling while restoring delimiters

	if ([*partialStringPtr length] == 0) {
		// User deleted or cut all characters, so there is nothing to filter or format.
		[self emptyBugfix:*partialStringPtr];
		// Guarantee state of insertion point if field is empty. See NSFormatter+VRFormatterBugfixes category for information.
		return YES; // Accept *partialStringPtr
	} else {
		origSelRange = [self deleteBugfix:origSelRange];
		// Guarantee that origSelRange is correct after Delete key is pressed. See NSFormatter+VRFormatterBugfixes category for information.
	
		deleting = (origSelRange.location - proposedSelRangePtr->location) == 1;
	
		if (proposedSelRangePtr->location <= origSelRange.location) {
			// User deleted or cut some characters; proposed insertion point is unchanged if cut or pressed Forward Delete key, or moved left by one position if pressed Delete key.
			insertedString = @""; // Nothing typed or pasted
		} else {
			// User typed or pasted characters; proposed insertion point moved right to end of proposed insertion.
			insertedString = [*partialStringPtr substringWithRange:NSMakeRange(origSelRange.location, proposedSelRangePtr->location - origSelRange.location)]; // Characters typed or pasted

			// Reject invalid characters.
			
			if ([insertedString rangeOfCharacterFromSet:invertedDecimalDigitPlusTelephoneDelimitersCharacterSet options:NSLiteralSearch].location != NSNotFound) {
				*error = [NSString stringWithFormat:NSLocalizedString(@"Ò%@Ó is not allowed in a telephone number.", @"Presented when typed or pasted value contains a character other than a numeric digit or telephone delimiter"), insertedString];
				return NO; // Reject *partialStringPtr, invoke NSControl delegate method with error message
			}
		}
		
		tempPartialString = @""; // Initialize
		tempProposedSelRangeLocation = proposedSelRangePtr->location; // Initialize

		// Scan for delimiters and discard them, adjusting insertion point.
		
		// At beginning of scan, *partialStringPtr is in form (800) 555-1212 (or part of it) with delimiters; tempProposedSelRangeLocation is between the digits it should remain between.
		scanner = [NSScanner scannerWithString:*partialStringPtr];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
		// Allow removal of white space used as delimiter (scanners default to skip white space).
		
		while (![scanner isAtEnd]) {
			// Alternately discard delimiters and accumulate digits.

			// Discard delimiters.
			if ([scanner scanCharactersFromSet:telephoneDelimitersCharacterSet intoString:&discardedDelimiters]) {
				if ([scanner scanLocation] <= proposedSelRangePtr->location) {
					// Decrement proposed insertion point if to right of discarded delimiters string.
					tempProposedSelRangeLocation = tempProposedSelRangeLocation - [discardedDelimiters length];
				} else if (([scanner scanLocation] - [discardedDelimiters length]) <= proposedSelRangePtr->location) {
					// Decrement proposed insertion point if within discarded delimiters string.
					tempProposedSelRangeLocation = tempProposedSelRangeLocation - ([discardedDelimiters length] - ([scanner scanLocation] - proposedSelRangePtr->location));
				}
			}
			
			// Accumulate digits.
			if ([scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&accumulatedDigits]) {
				tempPartialString = [tempPartialString stringByAppendingString:accumulatedDigits];
			}
		}

		// Loop backwards to insert new separators where appropriate, adjusting insertion point.
		
		// At beginning of loop, *partialStringPtr is in form 8005551212 (or part of it) without delimiters; tempProposedSelRangeLocation is between digits that it should remain between.
		for (index = [tempPartialString length] - 1; index >= 0; index--) {
			NSString *delimiterString;
			switch (index) {
				case 0: delimiterString = @"("; break;
				case 3: delimiterString = @") "; break; // Note space after close paren
				case 6: delimiterString = @"-";  break;
				default: delimiterString = @""; break; // Empty string
			}
			
			// Insert delimiters
			if ([delimiterString length] > 0) {
				tempPartialString = [NSString stringWithFormat:@"%@%@%@", [tempPartialString substringToIndex:index], delimiterString, [tempPartialString substringFromIndex:index]];
				if ((index <= tempProposedSelRangeLocation) && !(deleting && ([telephoneDelimitersCharacterSet characterIsMember:[tempPartialString characterAtIndex:(tempProposedSelRangeLocation + [delimiterString length] -1)]]))) {
					// Increment proposed insertion point if within or to right of inserted delimiters string.
					tempProposedSelRangeLocation = tempProposedSelRangeLocation + [delimiterString length];
				}
			}
		}
	
		*partialStringPtr = tempPartialString;
		*proposedSelRangePtr = NSMakeRange(tempProposedSelRangeLocation, 0);
		
		[self emptyBugfix:*partialStringPtr];
		// Guarantee state of insertion point if field is emptied programmatically. See NSFormatter+VRFormatterBugfixes category for information.

		*error = nil; // Signal NSControl that no error occurred
		return NO; // Display *partialStringPtr as edited; invokes delegate method but signals no error by returning nil in errorDescription parameter.
	}
}

@end
