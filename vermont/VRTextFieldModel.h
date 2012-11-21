/*
 Vermont Recipes
 VRTextFieldModel.h
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h>
#import "VRAntiqueRecord.h" // r11s4

@class VRDocument; // r4s1

@interface VRTextFieldModel : NSObject <NSCoding> { // r4s1, r12s1
    @private // r4s1
    VRDocument *document; // r4s1

	// Formatted values
    int integerValue; // r4s1
    float decimalValue; // r4s1
    NSString *telephoneValue; // r4s1

	// Form values
	NSString *formNameValue; // r9s2
	NSNumber *formIdValue; // r9s2
	NSCalendarDate *formDateValue; // r9s2
	NSString *formFaxValue; // r9s2

	// Antiques table values
	NSMutableArray *antiques; // r11s2
	int lastAntiqueID; //r11s5
	NSMutableArray *antiqueAddedKinds; // r11s9
}

#pragma mark INITIALIZATION

- (id)initWithDocument:(VRDocument *)inDocument; // r4s1; designated initializer
- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument; // r12s5

#pragma mark ACCESSORS

- (VRDocument *)document; // r4s1

- (NSUndoManager *)undoManager; // r4s1

// Formatted values

- (void)setIntegerValue:(int)inValue; // r4s1
- (int)integerValue; // r4s1

- (void)setDecimalValue:(float)inValue; // r4s1
- (float)decimalValue; // r4s1

- (void)setTelephoneValue:(NSString *)inValue; // r4s1
- (NSString *)telephoneValue; // r4s1

// Form values

- (void)setFormNameValue:(NSString *)inValue; // r9s2
- (NSString *)formNameValue; // r9s2

- (void)setFormIdValue:(NSNumber *)inValue; // r9s2
- (NSNumber *)formIdValue; // r9s2

- (void)setFormDateValue:(NSCalendarDate *)inValue; // r9s2
- (NSCalendarDate *)formDateValue; // r9s2

- (void)setFormFaxValue:(NSString *)inValue; // r9s2
- (NSString *)formFaxValue; // r9s2

// Antiques array values

- (void)setAntiques:(NSMutableArray *)inValue; // r12s1
- (NSMutableArray *)antiques; // r11s2

- (void)setLastAntiqueID:(int)inValue; // r11s5
- (int)lastAntiqueID; // r11s5

- (void)setAntiqueAddedKinds:(NSMutableArray *)inValue; // r12s1
- (NSMutableArray *)antiqueAddedKinds; // r11s9

#pragma mark ANTIQUES ARRAY METHODS

- (NSNumber *)uniqueAntiqueID; // r11s5
- (BOOL)isUniqueAntiqueID:(NSNumber *)inValue; // r11s5

- (void)newAntiqueRecord; // r11s4
- (void)deleteAntiqueRecord:(VRAntiqueRecord *)record; // r11s4
- (void)undeleteAntiqueRecord:(VRAntiqueRecord *)record; // r11s4

/* REMOVED r12
#pragma mark STORAGE

// Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary; // r4s1

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary; // r4s1
*/

@end

#pragma mark NOTIFICATIONS

// Formatted values
extern NSString *VRTextFieldModelIntegerValueChangedNotification; // r4s1
extern NSString *VRTextFieldModelDecimalValueChangedNotification; // r4s1
extern NSString *VRTextFieldModelTelephoneValueChangedNotification; // r4s1

// Form values
extern NSString *VRTextFieldModelFormNameValueChangedNotification; // r9s2
extern NSString *VRTextFieldModelFormIdValueChangedNotification; // r9s2
extern NSString *VRTextFieldModelFormDateValueChangedNotification; // r9s2
extern NSString *VRTextFieldModelFormFaxValueChangedNotification; // r9s2

// Antiques table values
extern NSString *VRTextFieldModelAntiquesArrayChangedNotification; // r11s2

extern NSString *VRTextFieldModelUnarchivedNotification; // r12s5
