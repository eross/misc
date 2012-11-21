/*
 Vermont Recipes
 VRButtonModel.h
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r1s3.5.1

#pragma mark TYPEDEFS

typedef enum { // r2s4
    VRDemocratic,
    VRRepublican,
    VRSocialist
} VRParty;

typedef enum { // r2s5
    VRMaine,
    VRMassachusetts,
    VRNewHampshire,
    VRRhodeIsland,
    VRVermont
} VRState;

@class VRDocument; // r1s3.5.2

@interface VRButtonModel : NSObject <NSCoding> { // r1s3.5.1, r12s4
    @private // r1s3.5.2
    VRDocument *document; // r1s3.5.2

    BOOL checkboxValue; // r1s3.5.4

    // Pegs
    BOOL trianglePegsValue; // r2s2
    BOOL squarePegsValue; // r2s2
    BOOL roundPegsValue; // r2s2

    // Music
    BOOL playMusicValue; // r2s3
    BOOL rockValue; // r2s3
    BOOL recentRockValue; // r2s3
    BOOL oldiesRockValue; // r2s3
    BOOL classicalValue; // r2s3

    // Party
    VRParty partyValue; // r2s4

    // State
    VRState stateValue; // r2s5
}

#pragma mark INITIALIZATION

- (id)initWithDocument:(VRDocument *)inDocument; // r1s3.5.2; designated initializer
- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument; // r12s5

#pragma mark ACCESSORS

- (VRDocument *)document; // r1s3.5.2

- (NSUndoManager *)undoManager; // r1s6.1

- (void)setCheckboxValue:(BOOL)inValue; // r1s3.5.4
- (BOOL)checkboxValue; // r1s3.5.4

    // Pegs

- (void)setTrianglePegsValue:(BOOL)inValue; // r2s2
- (BOOL)trianglePegsValue; // r2s2

- (void)setSquarePegsValue:(BOOL)inValue; // r2s2
- (BOOL)squarePegsValue; // r2s2

- (void)setRoundPegsValue:(BOOL)inValue; // r2s2
- (BOOL)roundPegsValue; // r2s2

    // Music

- (void)setPlayMusicValue:(BOOL)inValue; // r2s3
- (BOOL)playMusicValue; // r2s3

- (void)setRockValue:(BOOL)inValue; // r2s3
- (BOOL)rockValue; // r2s3

- (void)setRecentRockValue:(BOOL)inValue; // r2s3
- (BOOL)recentRockValue; // r2s3

- (void)setOldiesRockValue:(BOOL)inValue; // r2s3
- (BOOL)oldiesRockValue; // r2s3

- (void)setClassicalValue:(BOOL)inValue; // r2s3
- (BOOL)classicalValue; // r2s3

    // Party

- (void)setPartyValue:(VRParty)inValue; // r2s4
- (VRParty)partyValue; // r2s4

    // State

- (void)setStateValue:(VRState)inValue; // r2s5
- (VRState)stateValue; // r2s5

/* REMOVED r12
#pragma mark STORAGE

// Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary; // r1s4.2.3

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary; // r1s4.2.3
*/

@end

#pragma mark NOTIFICATIONS

extern NSString *VRButtonModelCheckboxValueChangedNotification; // r1s6.3

// Pegs
extern NSString *VRButtonModelTrianglePegsValueChangedNotification; // r2s2
extern NSString *VRButtonModelSquarePegsValueChangedNotification; // r2s2
extern NSString *VRButtonModelRoundPegsValueChangedNotification; // r2s2

// Music
extern NSString *VRButtonModelPlayMusicValueChangedNotification; // r2s3
extern NSString *VRButtonModelRockValueChangedNotification; // r2s3
extern NSString *VRButtonModelRecentRockValueChangedNotification; // r2s3
extern NSString *VRButtonModelOldiesRockValueChangedNotification; // r2s3
extern NSString *VRButtonModelClassicalValueChangedNotification; // r2s3

// Party
extern NSString *VRButtonModelPartyValueChangedNotification; // r2s4

// State
extern NSString *VRButtonModelStateValueChangedNotification; // r2s5

extern NSString *VRButtonModelUnarchivedNotification; // r12s5