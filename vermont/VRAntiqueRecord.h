/*
 Vermont Recipes
 VRAntiqueRecord.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r11s3

@class VRDocument; // r11s3

@interface VRAntiqueRecord : NSObject <NSCoding> { // r11s3, r12s1
    @private // r11s3
    VRDocument *document; // r11s3

	NSNumber *antiqueID; // r11s3
	NSString *antiqueKind; // r11s3
	// Insert other fields here.
}

#pragma mark INITIALIZATION

- (id)initWithDocument:(VRDocument *)inDocument; // r11s3
- (id)initWithID:(NSNumber *)inID document:(VRDocument *)inDocument; // r11s3; designated initializer

#pragma mark ACCESSORS

- (VRDocument *)document; // r11s3
- (void)setDocument:(id)inDocument; // r12s5
	
- (NSUndoManager *)undoManager; // r11s3

- (void)setAntiqueID:(NSNumber *)inValue; // r11s3
- (NSNumber *)antiqueID; // r11s3

- (void)setAntiqueKind:(NSString *)inValue; // r11s3
- (NSString *)antiqueKind; // r11s3

@end

#pragma mark NOTIFICATIONS

extern NSString *VRAntiqueRecordChangedNotification; // r11s3
