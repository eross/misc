/*
 Vermont Recipes
 VRButtonModel.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRButtonModel.h" // r1s3.5.1
#import "VRDocument.h" // r1s3.5.2
#import "NSString+VRStringUtilities.h" // r2s2.7

#pragma mark NOTIFICATIONS

NSString *VRButtonModelCheckboxValueChangedNotification = @"ButtonModel checkboxValue Changed Notification"; // r1s6.3

// Pegs
NSString *VRButtonModelTrianglePegsValueChangedNotification = @"ButtonModel trianglePegsValue Changed Notification"; // r2s2
NSString *VRButtonModelSquarePegsValueChangedNotification = @"ButtonModel squarePegsValue Changed Notification"; // r2s2
NSString *VRButtonModelRoundPegsValueChangedNotification = @"ButtonModel roundPegsValue Changed Notification"; // r2s2

// Music
NSString *VRButtonModelPlayMusicValueChangedNotification = @"ButtonModel playMusicValue Changed Notification"; // r2s3
NSString *VRButtonModelRockValueChangedNotification = @"ButtonModel rockValue Changed Notification"; // r2s3
NSString *VRButtonModelRecentRockValueChangedNotification = @"ButtonModel recentRockValue Changed Notification"; // r2s3
NSString *VRButtonModelOldiesRockValueChangedNotification = @"ButtonModel oldiesRockValue Changed Notification"; // r2s3
NSString *VRButtonModelClassicalValueChangedNotification = @"ButtonModel classicalValue Changed Notification"; // r2s3

// Party
NSString *VRButtonModelPartyValueChangedNotification = @"ButtonModel partyValue Changed Notification"; // r2s4

// State
NSString *VRButtonModelStateValueChangedNotification = @"ButtonModel stateValue Changed Notification"; // r2s5

NSString *VRButtonModelUnarchivedNotification = @"ButtonModel Unarchived Notification"; // r12s5

@implementation VRButtonModel // r1s3.5.1

#pragma mark INITIALIZATION

+ (void) initialize { // r19
	// Initialize class version and default model values before any other method is called.
	static BOOL initialized = NO;
	if ( !initialized ) {
		if (self == [VRButtonModel class]) {
			[self setVersion:1];
		}
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *initialUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], @"CheckboxValue", [NSNumber numberWithBool:YES], @"TrianglePegsValue", [NSNumber numberWithInt:VRRepublican], @"PartyValue", [NSNumber numberWithInt:VRVermont], @"StateValue", nil];
		[defaults registerDefaults:initialUserDefaults];
		initialized = YES;
	}
}

- (id)init { // r1s3.5.2
	// Override method.
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(VRDocument *)inDocument { // r1s3.5.2
	// Designated initializer.
    if (self = [super init]) {
        document = inDocument;

		// Set nonempty default values
        // Bracket calls to instance variables' accessor methods between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
		[[self undoManager] disableUndoRegistration]; // r1s6.1

		[self setCheckboxValue:[[NSUserDefaults standardUserDefaults] boolForKey:@"CheckboxValue"]]; // r19
		[self setTrianglePegsValue:[[NSUserDefaults standardUserDefaults] boolForKey:@"TrianglePegsValue"]]; // r19
		[self setPartyValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"PartyValue"]]; // r19
		[self setStateValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"StateValue"]]; // r19

		[[self undoManager] enableUndoRegistration]; // r1s6.1

#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\t%@", self); // r1s10.3
#endif
	}
//	NSAssert(checkboxValue, @"checkboxValue is not YES"); // r1s10.4, r1s10.5, removed r19
    return self;
}

- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument { // r12s5
	document = inDocument;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelUnarchivedNotification object:[self document]];
}

#pragma mark ACCESSORS

- (VRDocument *)document { // r1s3.5.2
    return document;
}

- (NSUndoManager *)undoManager { // r1s6.1
    return [[self document] undoManager];
}

- (void)setCheckboxValue:(BOOL)inValue { // r1s3.5.4
    [[[self undoManager] prepareWithInvocationTarget:self] setCheckboxValue:checkboxValue]; // r1s6.1
    checkboxValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelCheckboxValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:checkboxValue] forKey:VRButtonModelCheckboxValueChangedNotification]]; // r1s6.3, r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setCheckboxValue:], checkboxValue:%@\n",  [NSString stringWithBool:checkboxValue]); // r1s10.2, r2s4
#endif
}

- (BOOL)checkboxValue { // r1s3.5.4
    return checkboxValue;
}

// Pegs

- (void)setTrianglePegsValue:(BOOL)inValue { // r2s2
    [[[self undoManager] prepareWithInvocationTarget:self] setTrianglePegsValue:trianglePegsValue];
    trianglePegsValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelTrianglePegsValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:trianglePegsValue] forKey:VRButtonModelTrianglePegsValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setTrianglePegsValue:], trianglePegsValue:%@\n",  [NSString stringWithBool:trianglePegsValue]); // r2s4
#endif
}

- (BOOL)trianglePegsValue { // r2s2
    return trianglePegsValue;
}

- (void)setSquarePegsValue:(BOOL)inValue { // r2s2
    [[[self undoManager] prepareWithInvocationTarget:self] setSquarePegsValue:squarePegsValue];
    squarePegsValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelSquarePegsValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:squarePegsValue] forKey:VRButtonModelSquarePegsValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setSquarePegsValue:], squarePegsValue:%@\n",  [NSString stringWithBool:squarePegsValue]); // r2s4
#endif
}

- (BOOL)squarePegsValue { // r2s2
    return squarePegsValue;
}

- (void)setRoundPegsValue:(BOOL)inValue { // r2s2
    [[[self undoManager] prepareWithInvocationTarget:self] setRoundPegsValue:roundPegsValue];
    roundPegsValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelRoundPegsValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:roundPegsValue] forKey:VRButtonModelRoundPegsValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setRoundPegsValue:], roundPegsValue:%@\n",  [NSString stringWithBool:roundPegsValue]); // r2s4
#endif
}

- (BOOL)roundPegsValue { // r2s2
    return roundPegsValue;
}

// Music

- (void)setPlayMusicValue:(BOOL)inValue { // r2s3
    [[[self undoManager] prepareWithInvocationTarget:self] setPlayMusicValue:playMusicValue];
    playMusicValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelPlayMusicValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:playMusicValue] forKey:VRButtonModelPlayMusicValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setPlayMusicValue:], playMusicValue:%@\n",  [NSString stringWithBool:playMusicValue]); // r2s4
#endif
}

- (BOOL)playMusicValue { // r2s3
    return playMusicValue;
}

- (void)setRockValue:(BOOL)inValue { // r2s3
    [[[self undoManager] prepareWithInvocationTarget:self] setRockValue:rockValue];
    rockValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelRockValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:rockValue] forKey:VRButtonModelRockValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setRockValue:], rockValue:%@\n",  [NSString stringWithBool:rockValue]); // r2s4
#endif
}

- (BOOL)rockValue { // r2s3
    return rockValue;
}

- (void)setRecentRockValue:(BOOL)inValue { // r2s3
    [[[self undoManager] prepareWithInvocationTarget:self] setRecentRockValue:recentRockValue];
    recentRockValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelRecentRockValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:recentRockValue] forKey:VRButtonModelRecentRockValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setRecentRockValue:], recentRockValue:%@\n",  [NSString stringWithBool:recentRockValue]); // r2s4
#endif
}

- (BOOL)recentRockValue { // r2s3
    return recentRockValue;
}

- (void)setOldiesRockValue:(BOOL)inValue { // r2s3
    [[[self undoManager] prepareWithInvocationTarget:self] setOldiesRockValue:oldiesRockValue];
    oldiesRockValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelOldiesRockValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:oldiesRockValue] forKey:VRButtonModelOldiesRockValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setOldiesRockValue:], oldiesRockValue:%@\n",  [NSString stringWithBool:oldiesRockValue]); // r2s4
#endif
}

- (BOOL)oldiesRockValue { // r2s3
    return oldiesRockValue;
}

- (void)setClassicalValue:(BOOL)inValue { // r2s3
    [[[self undoManager] prepareWithInvocationTarget:self] setClassicalValue:classicalValue];
    classicalValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelClassicalValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:classicalValue] forKey:VRButtonModelClassicalValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setClassicalValue:], classicalValue:%@\n", [NSString stringWithBool:classicalValue]); // r2s4
#endif
}

- (BOOL)classicalValue { // r2s3
    return classicalValue;
}

// Party

- (void)setPartyValue:(VRParty)inValue { // r2s4
    [[[self undoManager] prepareWithInvocationTarget:self] setPartyValue:partyValue];
    partyValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelPartyValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:partyValue] forKey:VRButtonModelPartyValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setPartyValue:], partyValue:%@\n", [NSString stringWithVRParty:partyValue]);
#endif
}

- (VRParty)partyValue { // r2s4
    return partyValue;
}

// State

- (void)setStateValue:(VRState)inValue { // r2s5
    [[[self undoManager] prepareWithInvocationTarget:self] setStateValue:stateValue];
    stateValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRButtonModelStateValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:stateValue] forKey:VRButtonModelStateValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRButtonModel setStateValue:], stateValue:%@\n", [NSString stringWithVRState:stateValue]);
#endif
}

- (VRState)stateValue { // r2s5
    return stateValue;
}

#pragma mark DEBUGGING

- (NSString *)description { // r1s10
	// Override method.
	return [NSString stringWithFormat:@"%@\
	\n\tcheckboxValue:%@\
	\n\ttrianglePegsValue:%@\
	\n\tsquarePegsValue:%@\
	\n\troundPegsValue:%@\
	\n\tplayMusicValue:%@\
	\n\trockValue:%@\
	\n\trecentRockValue:%@\
	\n\toldiesRockValue:%@\
	\n\tclassicalValue:%@\
	\n\tpartyValue:%@\
	\n\tstateValue:%@\n",
		[super description],
		[NSString stringWithBool:[self checkboxValue]],
		[NSString stringWithBool:[self trianglePegsValue]],
		[NSString stringWithBool:[self squarePegsValue]],
		[NSString stringWithBool:[self roundPegsValue]],
		[NSString stringWithBool:[self playMusicValue]],
		[NSString stringWithBool:[self rockValue]],
		[NSString stringWithBool:[self recentRockValue]],
		[NSString stringWithBool:[self oldiesRockValue]],
		[NSString stringWithBool:[self classicalValue]],
		[NSString stringWithVRParty:[self partyValue]],
		[NSString stringWithVRState:[self stateValue]]];
}

#pragma mark STORAGE

// Keys and values for dictionary
// Include the name of the model object in the key string to ensure that all keys in all model objects used in the same document are unique. 

static NSString *VRCheckboxValueKey = @"VRButtonModelCheckboxValue"; // r1s4.2.3

// Pegs
static NSString *VRTrianglePegsValueKey = @"VRButtonModelTrianglePegsValue"; // r2s2
static NSString *VRSquarePegsValueKey = @"VRButtonModelSquarePegsValue"; // r2s2
static NSString *VRRoundPegsValueKey = @"VRButtonModelRoundPegsValue"; // r2s2

// Music
static NSString *VRPlayMusicValueKey = @"VRButtonModelPlayMusicValue"; // r2s3
static NSString *VRRockValueKey = @"VRButtonModelRockValue"; // r2s3
static NSString *VRRecentRockValueKey = @"VRButtonModelRecentRockValue"; // r2s3
static NSString *VROldiesRockValueKey = @"VRButtonModelOldiesRockValue"; // r2s3
static NSString *VRClassicalValueKey = @"VRButtonModelClassicalValue"; // r2s3

// Party
static NSString *VRPartyValueKey = @"VRButtonModelPartyValue"; // r2s4

// State
static NSString *VRStateValueKey = @"VRButtonModelStateValue"; // r2s5

/* REMOVED r12
// Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary { // r1s4.2.3
	// Each value should be converted to an NSString object using the NSString stringWithFormat: method. If the value is already an NSString object, pass it without conversion.
    [dictionary setObject:[NSString stringWithBool:[self checkboxValue]] forKey:VRCheckboxValueKey]; // r2s2

	// Pegs
    [dictionary setObject:[NSString stringWithBool:[self trianglePegsValue]] forKey:VRTrianglePegsValueKey]; // r2s2
    [dictionary setObject:[NSString stringWithBool:[self squarePegsValue]] forKey:VRSquarePegsValueKey]; // r2s2
    [dictionary setObject:[NSString stringWithBool:[self roundPegsValue]] forKey:VRRoundPegsValueKey]; // r2s2

	// Music
    [dictionary setObject:[NSString stringWithBool:[self playMusicValue]] forKey:VRPlayMusicValueKey]; // r2s3
    [dictionary setObject:[NSString stringWithBool:[self rockValue]] forKey:VRRockValueKey]; // r2s3
    [dictionary setObject:[NSString stringWithBool:[self recentRockValue]] forKey:VRRecentRockValueKey]; // r2s3
    [dictionary setObject:[NSString stringWithBool:[self oldiesRockValue]] forKey:VROldiesRockValueKey]; // r2s3
    [dictionary setObject:[NSString stringWithBool:[self classicalValue]] forKey:VRClassicalValueKey]; // r2s3

        // Party
    [dictionary setObject:[NSString stringWithVRParty:[self partyValue]] forKey:VRPartyValueKey]; // r2s4

        // State
    [dictionary setObject:[NSString stringWithVRState:[self stateValue]] forKey:VRStateValueKey]; // r2s5
}

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary { // r1s4.2.3
	// Each NSDictionary object should be restored to a value of the native type of its instance variable using the NSString intValue or floatValue method, casting intValue to BOOL for Boolean values. If the native type of the NSDictionary object's instance variable is NSString or another object, retain it. Bracket these calls between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
	[[self undoManager] disableUndoRegistration]; // r1s6.1
	
    [self setCheckboxValue:[[dictionary objectForKey:VRCheckboxValueKey] boolValue]]; //r2s2
	
    // Pegs
    [self setTrianglePegsValue:[[dictionary objectForKey:VRTrianglePegsValueKey] boolValue]]; // r2s2
    [self setSquarePegsValue:[[dictionary objectForKey:VRSquarePegsValueKey] boolValue]]; // r2s2
    [self setRoundPegsValue:[[dictionary objectForKey:VRRoundPegsValueKey] boolValue]]; // r2s2

	// Music
    [self setPlayMusicValue:[[dictionary objectForKey:VRPlayMusicValueKey] boolValue]]; // r2s3
    [self setRockValue:[[dictionary objectForKey:VRRockValueKey] boolValue]]; // r2s3
    [self setRecentRockValue:[[dictionary objectForKey:VRRecentRockValueKey] boolValue]]; // r2s3
    [self setOldiesRockValue:[[dictionary objectForKey:VROldiesRockValueKey] boolValue]]; // r2s3
    [self setClassicalValue:[[dictionary objectForKey:VRClassicalValueKey] boolValue]]; // r2s3

	// Party
    [self setPartyValue:[[dictionary objectForKey:VRPartyValueKey] partyValue]]; // r2s4

	// State
    [self setStateValue:[[dictionary objectForKey:VRStateValueKey] stateValue]]; // r2s5

	[[self undoManager] enableUndoRegistration]; // r1s6.1
}
*/

- (id)initWithCoder:(NSCoder *)decoder { // r12s4
	self = [super init];
	[self setCheckboxValue:[decoder decodeBoolForKey:VRCheckboxValueKey]];
	[self setTrianglePegsValue:[decoder decodeBoolForKey:VRTrianglePegsValueKey]];
	[self setSquarePegsValue:[decoder decodeBoolForKey:VRSquarePegsValueKey]];
	[self setRoundPegsValue:[decoder decodeBoolForKey:VRRoundPegsValueKey]];
	[self setPlayMusicValue:[decoder decodeBoolForKey:VRPlayMusicValueKey]];
	[self setRockValue:[decoder decodeBoolForKey:VRRockValueKey]];
	[self setRecentRockValue:[decoder decodeBoolForKey:VRRecentRockValueKey]];
	[self setOldiesRockValue:[decoder decodeBoolForKey:VROldiesRockValueKey]];
	[self setClassicalValue:[decoder decodeBoolForKey:VRClassicalValueKey]];
	[self setPartyValue:[decoder decodeIntForKey:VRPartyValueKey]];
	[self setStateValue:[decoder decodeIntForKey:VRStateValueKey]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder { // r12s4
	[[self undoManager] disableUndoRegistration];
	
	[encoder encodeBool:[self checkboxValue] forKey:VRCheckboxValueKey];
	[encoder encodeBool:[self trianglePegsValue] forKey:VRTrianglePegsValueKey];
	[encoder encodeBool:[self squarePegsValue] forKey:VRSquarePegsValueKey];
	[encoder encodeBool:[self roundPegsValue] forKey:VRRoundPegsValueKey];
	[encoder encodeBool:[self playMusicValue] forKey:VRPlayMusicValueKey];
	[encoder encodeBool:[self rockValue] forKey:VRRockValueKey];
	[encoder encodeBool:[self recentRockValue] forKey:VRRecentRockValueKey];
	[encoder encodeBool:[self oldiesRockValue] forKey:VROldiesRockValueKey];
	[encoder encodeBool:[self classicalValue] forKey:VRClassicalValueKey];
	[encoder encodeInt:[self partyValue] forKey:VRPartyValueKey];
	[encoder encodeInt:[self stateValue] forKey:VRStateValueKey];
	
	[[self undoManager] enableUndoRegistration];
}

@end
