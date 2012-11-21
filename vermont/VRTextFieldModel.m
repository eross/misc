/*
 Vermont Recipes
 VRTextFieldModel.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRTextFieldModel.h"
#import "VRDocument.h" // r4s1

// Formatted values
NSString *VRTextFieldModelIntegerValueChangedNotification = @"TextFieldModel integerValue Changed Notification"; // r4s1
NSString *VRTextFieldModelDecimalValueChangedNotification = @"TextFieldModel decimalValue Changed Notification"; // r4s1
NSString *VRTextFieldModelTelephoneValueChangedNotification = @"TextFieldModel telephoneValue Changed Notification"; // r4s1

// Form values
NSString *VRTextFieldModelFormNameValueChangedNotification = @"TextFieldModel formNameValue Changed Notification"; // r9s2
NSString *VRTextFieldModelFormIdValueChangedNotification = @"TextFieldModel formIdValue Changed Notification"; // r9s2
NSString *VRTextFieldModelFormDateValueChangedNotification = @"TextFieldModel formDateValue Changed Notification"; // r9s2
NSString *VRTextFieldModelFormFaxValueChangedNotification = @"TextFieldModel formFaxValue Changed Notification"; // r9s2

// Antiques table values
NSString *VRTextFieldModelAntiquesArrayChangedNotification = @"TextFieldModel antiquesArray Changed Notification"; // r11s2

NSString *VRTextFieldModelUnarchivedNotification = @"TextFieldModel Unarchived Notification"; // r12s5

@implementation VRTextFieldModel

#pragma mark INITIALIZATION

+ (void) initialize { // r19
	// Initialize class version and default model values before any other method is called.
	static BOOL initialized = NO;
	if ( !initialized ) {
		if (self == [VRTextFieldModel class]) {
			[self setVersion:1];
		}
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *initialUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys: @"(800) 555-1212", @"TelephoneValue", @"Test Name", @"FormNameValue", [NSNumber numberWithInt:95123], @"FormIdValue", @"(800) 555-1212", @"FormFaxValue", nil];
		[defaults registerDefaults:initialUserDefaults];
		initialized = YES;
	}
}

- (id)init { // r4s1
	// Override method.
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(VRDocument *)inDocument { // r4s1
	// Designated initializer.
    if (self = [super init]) {
        document = inDocument;
		
        // Default settings values
        // Bracket calls to instance variables' accessor methods between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
        telephoneValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"TelephoneValue"]; // r19

		formNameValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"FormNameValue"]; // r9s2, r19
		formIdValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FormIdValue"] retain]; // r9s2, r19
		formDateValue = [[NSCalendarDate calendarDate] retain]; // r9s2; today's date
		formFaxValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"FormFaxValue"]; // r9s2, r19
		
		[self setLastAntiqueID:0]; // r11s5; incremented to provide unique ID for every new record
		antiques = [[NSMutableArray array] retain]; // r11s2; empty mutable array
		antiqueAddedKinds = [[NSMutableArray array] retain]; // r11s9; empty mutable array

#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\t%@", self);
#endif
	}
    return self;
}

- (void)initAfterUnarchivingWithDocument:(VRDocument *)inDocument { // r12s5
	document = inDocument;
	[[self antiques] makeObjectsPerformSelector:@selector(setDocument:) withObject:document];
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelUnarchivedNotification object:[self document]];
}

- (void)dealloc { // r4s1
	// Override method.
    [[self telephoneValue] release];

	[[self formNameValue] release]; // r9s2
	[[self formIdValue] release]; // r9s2
	[[self formDateValue] release]; // r9s2
	[[self formFaxValue] release]; // r9s2

	[[self antiques] release]; // r11s2
	[[self antiqueAddedKinds] release]; // r11s9

	[super dealloc];
}

#pragma mark ACCESSORS

- (VRDocument *)document { // r4s1
    return document;
}

- (NSUndoManager *)undoManager { // r4s1
    return [[self document] undoManager];
}

// Formatted values

- (void)setIntegerValue:(int)inValue { // r4s1
    [[[self undoManager] prepareWithInvocationTarget:self] setIntegerValue:integerValue];
    integerValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelIntegerValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:integerValue] forKey:VRTextFieldModelIntegerValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRTextFieldModel setIntegerValue:], integerValue:%@\n",  [[NSNumber numberWithInt:[self integerValue]] stringValue]);
#endif
}

- (int)integerValue { // r4s1
    return integerValue;
}

- (void)setDecimalValue:(float)inValue { // r4s1
    [[[self undoManager] prepareWithInvocationTarget:self] setDecimalValue:decimalValue];
    decimalValue = inValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelDecimalValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:decimalValue] forKey:VRTextFieldModelDecimalValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
	NSLog(@"\n\tExiting [VRTextFieldModel setDecimalValue:], decimalValue:%@\n",  [[NSNumber numberWithFloat:[self decimalValue]] stringValue]);
#endif
}

- (float)decimalValue { // r4s1
    return decimalValue;
}

- (void)setTelephoneValue:(NSString *)inValue { // r4s1
	if (telephoneValue != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setTelephoneValue:telephoneValue];
		[telephoneValue release];
		telephoneValue = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelTelephoneValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:telephoneValue forKey:VRTextFieldModelTelephoneValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\tExiting [VRTextFieldModel setTelephoneValue:], telephoneValue:%@\n",  [self telephoneValue]);
#endif
	}
}

- (NSString *)telephoneValue { // r4s1
    return [[telephoneValue retain] autorelease];
}

// Form values

- (void)setFormNameValue:(NSString *)inValue { // r9s2
	if (formNameValue != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setFormNameValue:formNameValue];
		[formNameValue release];
		formNameValue = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelFormNameValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:formNameValue forKey:VRTextFieldModelFormNameValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\tExiting [VRTextFieldModel setFormNameValue:], formNameValue:%@\n",  [self formNameValue]);
#endif
	}
}

- (NSString *)formNameValue { // r9s2
    return [[formNameValue retain] autorelease];
}

- (void)setFormIdValue:(NSNumber *)inValue { // r9s2
	if (formIdValue != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setFormIdValue:formIdValue];
		[formIdValue release];
		formIdValue = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelFormIdValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:formIdValue forKey:VRTextFieldModelFormIdValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\tExiting [VRTextFieldModel setFormIdValue:], formIdValue:%@\n",  [self formIdValue]);
#endif
	}
}

- (NSNumber *)formIdValue { // r9s2
    return [[formIdValue retain] autorelease];
}

- (void)setFormDateValue:(NSCalendarDate *)inValue { // r9s2
	if (formDateValue != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setFormDateValue:formDateValue];
		[formDateValue release];
		formDateValue = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelFormDateValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:formDateValue forKey:VRTextFieldModelFormDateValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\tExiting [VRTextFieldModel setFormDateValue:], formDateValue:%@\n",  [self formDateValue]);
#endif
	}
}

- (NSCalendarDate *)formDateValue { // r9s2
    return [[formDateValue retain] autorelease];
}

- (void)setFormFaxValue:(NSString *)inValue { // r9s2
	if (formFaxValue != inValue) {
		[[[self undoManager] prepareWithInvocationTarget:self] setFormFaxValue:formFaxValue];
		[formFaxValue release];
		formFaxValue = [inValue copy];
		[[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelFormFaxValueChangedNotification object:[self document] userInfo:[NSDictionary dictionaryWithObject:formFaxValue forKey:VRTextFieldModelFormFaxValueChangedNotification]]; // r12s5
#ifndef VR_BLOCK_LOGS
		NSLog(@"\n\tExiting [VRTextFieldModel setFormFaxValue:], formFaxValue:%@\n",  [self formFaxValue]);
#endif
	}
}

- (NSString *)formFaxValue { // r9s2
    return [[formFaxValue retain] autorelease];
}

// Antiques array values

- (void)setAntiques:(NSMutableArray *)inValue { // r12s1
	[inValue retain];
	[antiques release];
	antiques = inValue;
}

- (NSMutableArray *)antiques { // r11s2
	return antiques;
}

- (void)setLastAntiqueID:(int)inValue { // r11s5
	lastAntiqueID = inValue;
}

- (int)lastAntiqueID { // r11s5
	return lastAntiqueID;
}

- (void)setAntiqueAddedKinds:(NSMutableArray *)inValue { // r12s1
	[inValue retain];
	[antiqueAddedKinds release];
	antiqueAddedKinds = inValue;
}

- (NSMutableArray *)antiqueAddedKinds { // r11s9
	return antiqueAddedKinds;
}

#pragma mark ANTIQUES ARRAY METHODS

- (NSNumber *)uniqueAntiqueID { // r11s5
	int newID = [self lastAntiqueID] + 1; // get next available antiqueID
	[self setLastAntiqueID:newID]; // save it for the next new record
	return [NSNumber numberWithInt:newID];
}

- (BOOL)isUniqueAntiqueID:(NSNumber *)inValue { // r11s5
	return ([inValue intValue] > [self lastAntiqueID]);
}

- (void)newAntiqueRecord { // r11s4
	// Creates new record at end of model array, automatically inserting unique antiqueID.
	VRAntiqueRecord *record = [[VRAntiqueRecord alloc] initWithID:[self uniqueAntiqueID] document:[self document]];
    [[[self undoManager] prepareWithInvocationTarget:self] deleteAntiqueRecord:record];
	[[self antiques] addObject:record];
	[record release]; // because array retained it
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelAntiquesArrayChangedNotification object:[self document]];
}

- (void)deleteAntiqueRecord:(VRAntiqueRecord *)record { // r11s4
	// Deletes record from model array.
    [[[self undoManager] prepareWithInvocationTarget:self] undeleteAntiqueRecord:record];
	[[self antiques] removeObject:record];
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelAntiquesArrayChangedNotification object:[self document]];
}

- (void)undeleteAntiqueRecord:(VRAntiqueRecord *)record { // r11s4
	// Undeletes record from model array.
    [[[self undoManager] prepareWithInvocationTarget:self] deleteAntiqueRecord:record];
	[[self antiques] addObject:record];
    [[NSNotificationCenter defaultCenter] postNotificationName:VRTextFieldModelAntiquesArrayChangedNotification object:[self document]];
}

#pragma mark DEBUGGING

- (NSString *)description { // r4s1, r?s?, r11s2
	// Override method.
	return [NSString stringWithFormat:@"%@\
	\n\tintegerValue:%@\
	\n\tdecimalValue:%@\
	\n\tteleponeValue:%@\
	\n\tformNameValue:%@\
	\n\tformIDValue:%@\
	\n\tformDateValue:%@\
	\n\tformFaxValue:%@\
	\n\tantiques:%@\n",
		[super description],
		[[NSNumber numberWithInt:[self integerValue]] stringValue],
		[[NSNumber numberWithFloat:[self decimalValue]] stringValue],
		[self telephoneValue],
		[self formNameValue],
		[[self formIdValue] stringValue],
		[[self formDateValue] description],
		[self formFaxValue],
		[[self antiques] description]];
}

#pragma mark STORAGE

// Keys and values
// Include the name of the model object in the key string to ensure that all keys in all model objects used in the same document are unique.

// Formatted values
static NSString *VRIntegerValueKey = @"VRTextFieldModelIntegerValue"; // r4s1
static NSString *VRDecimalValueKey = @"VRTextFieldModelDecimalValue"; // r4s1
static NSString *VRTelephoneValueKey = @"VRTextFieldModelTelephoneValue"; // r4s1

// Form values
static NSString *VRFormNameValueKey = @"VRTextFieldModelFormNameValue"; // r9s2
static NSString *VRFormIdValueKey = @"VRTextFieldModelFormIdValue"; // r9s2
static NSString *VRFormDateValueKey = @"VRTextFieldModelFormDateValue"; // r9s2
static NSString *VRFormFaxValueKey = @"VRTextFieldModelFormFaxValue"; // r9s2

// Antiques
static NSString *VRAntiquesKey = @"VRTextFieldModel Antiques Key"; // r12s1
static NSString *VRLastAntiqueIDKey = @"VRTextFieldModel AntiqueID Key"; // r12s1
static NSString *VRAntiqueAddedKindsKey = @"VRTextFieldModel AntiqueAddedKinds Key"; // r12s1

/* REMOVED r12
 // Saving information to persistent storage:

- (void)addDataToDictionary:(NSMutableDictionary *)dictionary { // r4s1
	// Each value should be converted to an NSString object using the NSString stringWithFormat: method or equivalent. If the value is already an NSString object, pass it without conversion.

	// Formatted values
    [dictionary setObject:[NSString stringWithFormat:@"%d", [self integerValue]] forKey:VRIntegerValueKey];
    [dictionary setObject:[NSString stringWithFormat:@"%f", [self decimalValue]] forKey:VRDecimalValueKey];
    [dictionary setObject:[self telephoneValue] forKey:VRTelephoneValueKey];

	// Form values
    [dictionary setObject:[self formNameValue] forKey:VRFormNameValueKey]; // r9s2
    [dictionary setObject:[self formIdValue] forKey:VRFormIdValueKey]; // r9s2
    [dictionary setObject:[self formDateValue] forKey:VRFormDateValueKey]; // r9s2
    [dictionary setObject:[self formFaxValue] forKey:VRFormFaxValueKey]; // r9s2
}

// Loading information from persistent storage:

- (void)restoreDataFromDictionary:(NSDictionary *)dictionary { // r4s1
	// Each NSDictionary object should be restored to a value of the native type of its instance variable using the NSString intValue or floatValue method, casting intValue to BOOL for Boolean values. If the native type of the NSDictionary object's instance variable is NSString or another object, retain it. Bracket calls to instance variables' accessor methods between calls to the undo manager's disableUndoRegistration and enableUndoRegistration methods, because reading from storage should not be undoable.
    [[self undoManager] disableUndoRegistration];

	// Formatted values
    [self setIntegerValue:[[dictionary objectForKey:VRIntegerValueKey] intValue]];
    [self setDecimalValue:[[dictionary objectForKey:VRDecimalValueKey] floatValue]];
    [self setTelephoneValue:[dictionary objectForKey:VRTelephoneValueKey]];

	// Form values
	[self setFormNameValue:[dictionary objectForKey:VRFormNameValueKey]]; // r9s2
    [self setFormIdValue:[dictionary objectForKey:VRFormIdValueKey]]; // r9s2
    [self setFormDateValue:[dictionary objectForKey:VRFormDateValueKey]]; // r9s2
    [self setFormFaxValue:[dictionary objectForKey:VRFormFaxValueKey]]; // r9s2

    [[self undoManager] enableUndoRegistration];
}
*/

- (id)initWithCoder:(NSCoder *)decoder { // r12s1
	self = [super init];
	[self setIntegerValue:[decoder decodeIntForKey:VRIntegerValueKey]]; // r12s3
	[self setDecimalValue:[decoder decodeFloatForKey:VRDecimalValueKey]]; // r12s3
	[self setTelephoneValue:[decoder decodeObjectForKey:VRTelephoneValueKey]]; // r12s3
	[self setFormNameValue:[decoder decodeObjectForKey:VRFormNameValueKey]]; // r12s3
	[self setFormIdValue:[decoder decodeObjectForKey:VRFormIdValueKey]]; // r12s3
	[self setFormDateValue:[decoder decodeObjectForKey:VRFormDateValueKey]]; // r12s3
	[self setFormFaxValue:[decoder decodeObjectForKey:VRFormFaxValueKey]]; // r12s3
	[self setAntiques:[decoder decodeObjectForKey:VRAntiquesKey]];
	[self setLastAntiqueID:[decoder decodeIntForKey:VRLastAntiqueIDKey]];
	[self setAntiqueAddedKinds:[decoder decodeObjectForKey:VRAntiqueAddedKindsKey]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder { // r12s1
	[encoder encodeInt:[self integerValue] forKey:VRIntegerValueKey]; // r12s3
	[encoder encodeFloat:[self decimalValue] forKey:VRDecimalValueKey]; // r12s3
	[encoder encodeObject:[self telephoneValue] forKey:VRTelephoneValueKey]; // r12s3
	[encoder encodeObject:[self formNameValue] forKey:VRFormNameValueKey]; // r12s3
	[encoder encodeObject:[self formIdValue] forKey:VRFormIdValueKey]; // r12s3
	[encoder encodeObject:[self formDateValue] forKey:VRFormDateValueKey]; // r12s3
	[encoder encodeObject:[self formFaxValue] forKey:VRFormFaxValueKey]; // r12s3
	[encoder encodeObject:[self antiques] forKey:VRAntiquesKey];
	[encoder encodeInt:[self lastAntiqueID] forKey:VRLastAntiqueIDKey];
	[encoder encodeObject:[self antiqueAddedKinds] forKey:VRAntiqueAddedKindsKey];
}

@end
