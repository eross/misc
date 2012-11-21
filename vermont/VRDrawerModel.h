/*
 Vermont Recipes
 VRDrawerModel.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r16s6

@class VRDocument; // r16s6

@interface VRDrawerModel : NSObject <NSCoding> { // r16s6
    @private
    VRDocument *document;

    NSTextStorage *notes; // r17s1
}

#pragma mark INITIALIZATION

- (id)initWithDocument:(VRDocument *)inDocument; // r16s6; designated initializer
- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument; // r16s6

#pragma mark ACCESSORS

- (VRDocument *)document; // r16s6

- (void)setNotes:(NSTextStorage *)inValue; // r16s6, r17s1
//- (void)setNotesWhileEditing:(NSData *)inValue; // r16s6, REMOVED r17s1
- (NSTextStorage *)notes; // r16s6, r17s1

@end

#pragma mark NOTIFICATIONS

//extern NSString *VRDrawerModelUnarchivedNotification; // r16s6, REMOVED r17s1
//extern NSString *VRDrawerModelNotesChangedNotification; // r16s6, REMOVED r17s1
