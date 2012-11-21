/*
 Vermont Recipes
 NSString+VRStringUtilities.m
 Copyright © 2001-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSString+VRStringUtilities.h" // r2s2.7
#import <Foundation/NSException.h> // r2s2.7

@implementation NSString (VRStringUtilities) // r2s2.7

+ (id)stringWithBool:(BOOL)inValue { // r2s2.7
    return [NSString stringWithString:(inValue ? @"YES" : @"NO")];
}

- (BOOL)boolValue { // r2s2.7
    return ([self isEqualToString:@"YES"] ? YES : NO);
}

+ (id)stringWithVRParty:(int)inValue { // r2s4.3
    switch (inValue) {
		case 0:
			return [NSString stringWithString:@"VRDemocratic"];
			break;
		case 1:
			return [NSString stringWithString:@"VRRepublican"];
			break;
		case 2:
			return [NSString stringWithString:@"VRSocialist"];
			break;
		default:
			[NSException raise:NSInvalidArgumentException format:@"Exception raised in NSString+VRStringUtilities +stringWithVRParty: - attempt to pass parameter (%d) other than VRDemocratic (0), VRRepublican (1), or VRSocialist (2)", inValue];
			return [NSString string]; // empty string
			break;
    }
}

- (int)VRPartyValue { // r2s4.3
    if ([self isEqualToString:@"VRDemocratic"]) {
        return 0;
    } else if ([self isEqualToString:@"VRRepublican"]) {
        return 1;
    } else if ([self isEqualToString:@"VRSocialist"]) {
        return 2;
    } else {
		[NSException raise:@"VRInvalidValueException" format:@"Exception raised in NSString+VRStringUtilities -VRPartyValue - found string (%@) other than VRDemocratic, VRRepublican, or VRSocialist", self];
		return -1;
	}
}

+ (id)stringWithVRState:(int)value { // r2s5.2
    switch (value) {
		case 0:
			return [NSString stringWithString:@"VRMaine"];
			break;
		case 1:
			return [NSString stringWithString:@"VRMassachusetts"];
			break;
		case 2:
			return [NSString stringWithString:@"VRNewHampshire"];
			break;
		case 3:
			return [NSString stringWithString:@"VRRhodeIsland"];
			break;
		case 4:
			return [NSString stringWithString:@"VRVermont"];
			break;
		default:
			return [NSString string]; // empty string
			break;
    }
}

- (int)VRStateValue { // r2s5.2
    if ([self isEqualToString:@"VRMaine"]) {
        return 0;
    } else if ([self isEqualToString:@"VRMassachusetts"]) {
        return 1;
    } else if ([self isEqualToString:@"VRNewHampshire"]) {
        return 2;
    } else if ([self isEqualToString:@"VRRhodeIsland"]) {
        return 3;
    } else if ([self isEqualToString:@"VRVermont"]) {
        return 4;
    } else {
		return -1;
    }
}

@end
