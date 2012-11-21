/*
 Vermont Recipes
 VRSliderModel.h
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r3s1

@class VRDocument; // r3s1

@interface VRSliderModel : NSObject <NSCoding> { // r3s1, r12s4
    @private // r3s1
    VRDocument *document; // r3s1

    // Personality
    float personalityValue; // r3s1

    // Speed
    float speedValue; // r3s2

    // Quantum
    float quantumValue; // r3s3
}

#pragma mark INITIALIZATION

- (id)initWithDocument:(VRDocument *)inDocument; // r3s1; designated initializer
- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument; // r12s5

#pragma mark ACCESSORS

- (VRDocument *)document; // r3s1

- (NSUndoManager *)undoManager; // r3s1

// Personality

- (void)setPersonalityValue:(float)inValue; // r3s1
- (float)personalityValue; // r3s1

// Speed

- (void)setSpeedValue:(float)inValue; // r3s2
- (float)speedValue; // r3s2

// Quantum

- (void)setQuantumValue:(float)inValue; // r3s3
- (float)quantumValue; // r3s3

/* REMOVED r12
#pragma mark STORAGE

// Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary; // r3s1

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary; // r3s1
*/

@end

#pragma mark NOTIFICATIONS

// Personality
extern NSString *VRSliderModelPersonalityValueChangedNotification; // r3s1

// Speed
extern NSString *VRSliderModelSpeedValueChangedNotification; // r3s2

// Quantum
extern NSString *VRSliderModelQuantumValueChangedNotification; // r3s3

extern NSString *VRSliderModelUnarchivedNotification; // r12s5
