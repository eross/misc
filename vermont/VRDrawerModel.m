/*
 Vermont Recipes
 VRDrawerModel.m
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRDrawerModel.h"
#import "VRDocument.h" // r16s6

#pragma mark NOTIFICATIONS

//NSString *VRDrawerModelUnarchivedNotification = @"DrawerModel Unarchived Notification"; // r16s6, REMOVED r17s1
//NSString *VRDrawerModelNotesChangedNotification = @"DrawerModel Notes Changed Notification"; // r16s6, REMOVED r17s1

@implementation VRDrawerModel // r16s6

- (id)init { // r16s6
	// Override method.
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(VRDocument *)inDocument { // r16s6
	// Designated initializer.
    if (self = [super init]) {
        document = inDocument;

		//notes = [[NSData alloc] init]; // empty NSData object, REMOVED r17s1
		notes = nil; // r17s1

#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\t%@", self);
#endif
		
	}
	return self;
}

- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument { // r16s6
	document = inDocument;
//    [[NSNotificationCenter defaultCenter] postNotificationName:VRDrawerModelUnarchivedNotification object:[self document]]; // REMOVED r17s1
}

/* REMOVED r17s1
- (void)dealloc { // r16s6
	// Override method.
	[[self notes] release];

	[super dealloc];
}
*/

#pragma mark ACCESSORS

- (VRDocument *)document { // r16s6
    return document;
}

- (void)setNotes:(NSTextStorage *)inValue { // r16s6, 17s1
/* REMOVED r17s1
	if (notes != inValue) {
		[notes release];
		notes = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRDrawerModelNotesChangedNotification object:[self document] userInfo:[NSDicitonary dictionaryWithObject:notes forKey:VRDrawerModelNotesChangedNotification]];
	}
*/

    if ([[[self document] windowControllers] count] == 0) { // r17s1
        // Opening new document, so must retain notes read from disk until window controller is created and updates notes view, whereupon it will release notes. Thereafter, don't retain notes because window controller updates notes view using NSKeyedUnarchiver delegate method.
        [inValue retain];
    }
    notes = inValue;
    //	[[NSNotificationCenter defaultCenter] postNotificationName:VRDrawerModelNotesChangedNotification object:self userInfo:[NSDictionary dictionaryWithObject:notes forKey:VRDrawerModelNotesChangedNotification]]; // REMOVED r17s1
}

/* REMOVED r17s1
- (void)setNotesWhileEditing:(NSData *)inValue { // r16s6
	[inValue retain]
	[notes release];
	notes = inValue;
}
*/

- (NSTextStorage *)notes { // r16s6, r17s1
//	return [[notes retain] autorelease]; // REMOVED r17s1
	return notes;
}

#pragma mark DEBUGGING

- (NSString *)description { // r16s6
	// Override method.
	return [NSString stringWithFormat:@"%@\
\n\tnotes:%@\n",
		[super description],
		[[self notes] description]];
}

#pragma mark STORAGE

// Keys and values
// Include the name of the model object in the key string to ensure that all keys in all model objects used in the same document are unique.

static NSString *VRNotesKey = @"VRDrawerModel Notes Key"; // r16s6

- (id)initWithCoder:(NSCoder *)decoder { // r16s6
	self = [super init];
	[self setNotes:[decoder decodeObjectForKey:VRNotesKey]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder { // r16s6
	[encoder encodeObject:[self notes] forKey:VRNotesKey];
}

@end
