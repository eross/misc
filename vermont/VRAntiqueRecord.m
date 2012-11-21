/*
 Vermont Recipes
 VRAntiqueRecord.m
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRAntiqueRecord.h"
#import "VRDocument.h" // r11s3

#pragma mark NOTIFICATIONS

NSString *VRAntiqueRecordChangedNotification = @"AntiqueRecord Changed Notification"; // r11s3

@implementation VRAntiqueRecord

#pragma mark INITIALIZATION

- (id)init { // r11s3
	// Override method.
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(VRDocument *)inDocument { // r11s3
	return [self initWithID:nil document:inDocument];
}

- (id)initWithID:(NSNumber *)inID document:(VRDocument *)inDocument { // r11s3
	// Designated initializer.
    if (self = [super init]) {
		document = inDocument;

		[[self undoManager] disableUndoRegistration];
		[self setAntiqueID:inID];
		[self setAntiqueKind:NSLocalizedString(@"New", @"Kind of new antique record")];
		[[self undoManager] enableUndoRegistration];
	}
	return self;
}

- (void)dealloc { // r11s3
	// Override method.
    [[self antiqueID] release];
	[[self antiqueKind] release];
	[super dealloc];
}

#pragma mark ACCESSORS

- (VRDocument *)document { // r11s3
    return document;
}

- (void)setDocument:(id)inDocument { // r12s5
	document = inDocument;
}

- (NSUndoManager *)undoManager { // r11s3
    return [[self document] undoManager];
}

- (void)setAntiqueID:(NSNumber *)inValue { // r11s3
	if (antiqueID != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setAntiqueID:antiqueID];
		[antiqueID release];
		antiqueID = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRAntiqueRecordChangedNotification object:[self document]];
	}
}

- (NSNumber *)antiqueID { // r11s3
	return [[antiqueID retain] autorelease];
}

- (void)setAntiqueKind:(NSString *)inValue { // r11s3
	if (antiqueKind != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setAntiqueKind:antiqueKind];
		[antiqueKind release];
		antiqueKind = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRAntiqueRecordChangedNotification object:[self document]];
	}
}

- (NSString *)antiqueKind { // r11s3
	return [[antiqueKind retain] autorelease];
}

#pragma mark STORAGE

// Keys and values
// Include the name of the model object in the key string to ensure that all keys in all model objects used in the same document are unique.

static NSString *VRAntiqueIdKey = @"VRAntiqueRecord Antique ID Key"; // r12s1
static NSString *VRAntiqueKindKey = @"VRAntiqueRecord Antique Kind Key"; // r12s1

- (id)initWithCoder:(NSCoder *)decoder { // r12s1
	self = [super init];
	[self setAntiqueID:[decoder decodeObjectForKey:VRAntiqueIdKey]];
	[self setAntiqueKind:[decoder decodeObjectForKey:VRAntiqueKindKey]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder { // r12s1
	[encoder encodeObject:[self antiqueID] forKey:VRAntiqueIdKey];
	[encoder encodeObject:[self antiqueKind] forKey:VRAntiqueKindKey];
}

@end
