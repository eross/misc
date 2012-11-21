/*
 Vermont Recipes
 NSFormatter+VRFormatterBugfixes.m
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "NSFormatter+VRFormatterBugfixes.h"
#import <Cocoa/Cocoa.h> // r6s2

@implementation NSFormatter (VRFormatterBugFixes) // r6s2

// Return corrected origSelRange parameter for text field.
// Usage: Assign the return value of this method to origSelRange near the beginning of a formatter's isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription: method.
// Works around NSFormatter bug #1: After pressing Delete, the origSelRange.location parameter element reports the position of the insertion point as it exits AFTER the user presses Delete, instead of BEFORE, and the origSelRange.length parameter element reports 1 even if nothing was selected. This bug makes it impossible to use the origSelRange parameter to distinguish between Delete and Forward Delete, because they report the same origSelRange value. Pressing Forward Delete also reports an incorrect origSelRange.length of 1 even if nothing was selected.

- (NSRange)deleteBugfix:(NSRange)origSelRange { // r6s2
	if (([[NSApp currentEvent] type] == NSKeyDown) && ([[[NSApp currentEvent] characters] characterAtIndex:0] == NSDeleteCharacter)) {
		// Get the field editor's (firstResponder's) selected range to fix origSelRange.
		return [(NSText *)[[NSApp keyWindow] firstResponder] selectedRange];
	} else {
		return origSelRange;
	}
}

// Set text field's selection if text field is empty.
// Usage: Call this method at the end of a formatter's isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription: method, just before *error = nil; and return NO;.
// Works around NSFormatter bug #2: If, after the user Deletes or Forward Deletes other characters in the text field, the formatter automatically removes the last characters programmatically (such as an opening or closing delimiter), NSFormatter fails to reset the field editor's selection. As a result, the insertion point is left in an anomalous state, ignoring the text field's justification setting and showing only the top half of the blinking insertion cursor.

- (void)emptyBugfix:(NSString *)partialString { // r6s2
	if ([partialString length] == 0) {
		// Set the field editor's (firstResponder's) selected range to {0, 0} to fix the insertion point.
		[(NSText *)[[NSApp keyWindow] firstResponder] setSelectedRange:NSMakeRange(0, 0)];
	}
}

@end
