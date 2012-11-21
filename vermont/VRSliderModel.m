/*
 Vermont Recipes
 VRSliderModel.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "VRSliderModel.h"
#import "VRDocument.h" // r3s1

#pragma mark NOTIFICATIONS

// Personality
NSString *VRSliderModelPersonalityValueChangedNotification = @"SliderModel personalityValue Changed Notification"; // r4s1

// Speed
NSString *VRSliderModelSpeedValueChangedNotification = @"SliderModel speedValue Changed Notification"; // r3s2

// Quantum
NSString *VRSliderModelQuantumValueChangedNotification = @"SliderModel quantumValue Changed Notification"; // r3s3

NSString *VRSliderModelUnarchivedNotification = @"SliderModel Unarchived Notification"; // r12s5

@implementation VRSliderModel

#pragma mark INITIALIZATION

+ (void) initialize { // r19
	// Initialize class version and default model values before any other method is called.
	static BOOL initialized = NO;
	if ( !initialized ) {
		if (self == [VRSliderModel class]) {
			[self setVersion:1];
		}
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *initialUserDefaults = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat:75.0] forKey:@"SpeedValue"];
		[defaults registerDefaults:initialUserDefaults];
		initialized = YES;
	}
}

- (id)init { // r3s1
	// Override method.
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(VRDocument *)inDocument { // r3s1
	// Designated initializer.
    if (self = [super init]) {
        document = inDocument;

        // Default settings values
        // Bracket calls to instance variables' accessor methods between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
        [[self undoManager] disableUndoRegistration]; // r3s2

        [self setSpeedValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SpeedValue"]]; // r3s2, r19

        [[self undoManager] enableUndoRegistration]; // r3s2
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\t%@", self); // r3s1
#endif
	}
    return self;
}

- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument { // r12s5
	document = inDocument;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRSliderModelUnarchivedNotification object:[self document]];
}

#pragma mark ACCESSORS

- (VRDocument *)document { // r3s1
    return document;
}

- (NSUndoManager *)undoManager { // r3s1
    return [[self document] undoManager];
}

// Personality

- (void)setPersonalityValue:(float)inValue { // r3s1
	[[[self undoManager] prepareWithInvocationTarget:self] setPersonalityValue:personalityValue];
    personalityValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRSliderModelPersonalityValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:personalityValue] forKey:VRSliderModelPersonalityValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRSliderModel setPersonalityValue:], personalityValue:%@\n",  [[NSNumber numberWithFloat:[self personalityValue]] stringValue]);
#endif
}

- (float)personalityValue { // r3s1
    return personalityValue;
}

// Speed

- (void)setSpeedValue:(float)inValue { // r3s2
	[[[self undoManager] prepareWithInvocationTarget:self] setSpeedValue:speedValue];
    speedValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRSliderModelSpeedValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:speedValue] forKey:VRSliderModelSpeedValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRSliderModel setSpeedValue:], speedValue:%@\n",  [[NSNumber numberWithFloat:[self speedValue]] stringValue]);
#endif
}

- (float)speedValue { // r3s2
    return speedValue;
}

// Quantum

- (void)setQuantumValue:(float)inValue { // r3s3
	[[[self undoManager] prepareWithInvocationTarget:self] setQuantumValue:quantumValue];
    quantumValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRSliderModelQuantumValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:quantumValue] forKey:VRSliderModelQuantumValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRSliderModel setQuantumValue:], quantumValue:%@\n",  [[NSNumber numberWithFloat:[self quantumValue]] stringValue]);
#endif
}

- (float)quantumValue { // r3s3
    return quantumValue;
}

#pragma mark DEBUGGING

- (NSString *)description { // r3s1
	// Override method.
	return [NSString stringWithFormat:@"%@\
	\n\tpersonalityValue:%@\
	\n\tspeedValue:%@\
	\n\tquantumValue:%@\n",
		[super description],
		[[NSNumber numberWithFloat:[self personalityValue]] stringValue],
		[[NSNumber numberWithFloat:[self speedValue]] stringValue],
		[[NSNumber numberWithFloat:[self quantumValue]] stringValue]];
}

#pragma mark STORAGE

// Keys and values
// Include the name of the model object in the key string to ensure that all keys in all model objects used in the same document are unique.

// Personality
static NSString *VRPersonalityValueKey = @"VRSliderModelPersonalityValue"; // r3s1

// Speed
static NSString *VRSpeedValueKey = @"VRSliderModelSpeedValue"; // r3s2

// Quantum
static NSString *VRQuantumValueKey = @"VRSliderModelQuantumValue"; // r3s3

/* REMOVED r12
// Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary { // r3s1
	// Each value should be converted to an NSString object using the NSString stringWithFormat: method. If the value is already an NSString object, pass it without conversion.

	// Personality
	[dictionary setObject:[NSString stringWithFormat:@"%f", [self personalityValue]] forKey:VRPersonalityValueKey];
	
	// Speed
    [dictionary setObject:[NSString stringWithFormat:@"%f", [self speedValue]] forKey:VRSpeedValueKey]; // r3s2

	// Quantum
    [dictionary setObject:[NSString stringWithFormat:@"%f", [self quantumValue]] forKey:VRQuantumValueKey]; // r3s3
}

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary { // r3s1
	// Each NSDictionary object should be restored to a value of the native type of its instance variable using the NSString intValue or floatValue method, casting intValue to BOOL for Boolean values. If the native type of the NSDictionary object's instance variable is NSString or another object, retain it. Bracket these calls between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
	[[self undoManager] disableUndoRegistration];

	// Personality
    [self setPersonalityValue:[[dictionary objectForKey:VRPersonalityValueKey] floatValue]];

	// Speed
    [self setSpeedValue:[[dictionary objectForKey:VRSpeedValueKey] floatValue]]; // r3s2

	// Quantum
    [self setQuantumValue:[[dictionary objectForKey:VRQuantumValueKey] floatValue]]; // r3s3

    [[self undoManager] enableUndoRegistration];
}
*/

- (id)initWithCoder:(NSCoder *)decoder { // r12s4
	self = [super init];
	[self setPersonalityValue:[decoder decodeFloatForKey:VRPersonalityValueKey]];
	[self setSpeedValue:[decoder decodeFloatForKey:VRSpeedValueKey]];
	[self setQuantumValue:[decoder decodeFloatForKey:VRQuantumValueKey]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder { // r12s4
	[encoder encodeFloat:[self personalityValue] forKey:VRPersonalityValueKey];
	[encoder encodeFloat:[self speedValue] forKey:VRSpeedValueKey];
	[encoder encodeFloat:[self quantumValue] forKey:VRQuantumValueKey];
}

@end
