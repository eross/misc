/*
 Vermont Recipes
 VRDocument.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRDocument.h" // r1s1, r1s3.3
#import "VRButtonModel.h" // r1s3.5.3
#import "VRSliderModel.h" // r3s1
#import "VRTextfieldModel.h" // r4s1
#import "VRDrawerModel.h" // r16s7
#import "VRMainWindowController.h" // r1s3.3

@implementation VRDocument // r1s1, r1s3.3

- (BOOL)isJaguarOrNewer { // r21s1
	// Mac OS X 10.2 or newer
	return (floor(NSAppKitVersionNumber) >= 663);
}

#pragma mark INITIALIZATION

- (id)init { // r1s3.5.3
	// Override method.
    if (self = [super init]) {
        buttonModel = [[VRButtonModel alloc] initWithDocument:self];
        sliderModel = [[VRSliderModel alloc] initWithDocument:self]; // r3s1
        textFieldModel = [[VRTextFieldModel alloc] initWithDocument:self]; // r4s1
		drawerModel = [[VRDrawerModel alloc] initWithDocument:self]; // r16s7
    }
    return self;
}

- (void)dealloc { // r1s3.5.3
	// Override method.
    [[self buttonModel] release];
    [[self sliderModel] release]; // r3s1
	[[self textFieldModel] release]; // r4s1
	[[self drawerModel] release]; // r16s7
	[super dealloc];
}

#pragma mark ACCESSORS

- (void)setButtonModel:(VRButtonModel *)inValue { // r12s4
	[inValue retain];
	[buttonModel release];
	buttonModel = inValue;
}

- (VRButtonModel *)buttonModel { // r1s3.5.3
    return buttonModel;
}

- (void)setSliderModel:(VRSliderModel *)inValue { // r12s4
	[inValue retain];
	[sliderModel release];
	sliderModel = inValue;
}

- (VRSliderModel *)sliderModel { // r3s1
    return sliderModel;
}

- (void)setTextFieldModel:(VRTextFieldModel *)inValue { // r12s2
	[inValue retain];
	[textFieldModel release];
	textFieldModel = inValue;
}

- (VRTextFieldModel *)textFieldModel { // r4s1
    return textFieldModel;
}

- (void)setDrawerModel:(VRDrawerModel *)inValue { // r16s7
	[inValue retain];
	[drawerModel release];
	drawerModel = inValue;
}

- (VRDrawerModel *)drawerModel { // r16s7
    return drawerModel;
}

#pragma mark WINDOW MANAGEMENT

- (void)makeWindowControllers { // r1s3.3
	// Override method to instantiate controllers for multiple document windows.
    VRMainWindowController *controller = [[VRMainWindowController alloc] init];
    [self addWindowController:controller];
    [controller release];
}

#pragma mark STORAGE

// Keys and values

static NSString *VRDocumentType = @"Vermont Recipes document"; // r1s4.2.1
// The VRDocumentType string must be identical to that declared in the CFBundleTypeName entry in the Application Settings for the Info.plist file.
static NSString *VRDocumentVersionKey = @"Version"; // r1s4.2.1
static int VRDocumentVersion = 8; // r1s4.2.1, r2s1, r3, r4, r9, r12, r16, r17
// Increment VRDocumentVersion when the document format of a new release changes, to facilitate coding for backward compatibility.

static NSString *VRDocumentButtonModelKey = @"VRDocument button model"; // r12s2
static NSString *VRDocumentSliderModelKey = @"VRDocument slider model"; // r12s2
static NSString *VRDocumentTextFieldModelKey = @"VRDocument text field model"; // r12s2
static NSString *VRDocumentDrawerModelKey = @"VRDocument drawer model"; // r16s7

// Saving information to persistent storage

- (BOOL)keepBackupFile {
	// Override method to create automatic backup files.
	return YES;
}

/* REMOVED r12
- (BOOL)writeToFile:(NSString *)fileName ofType:(NSString *)type { // r1s5
	// Override method to write the document's internal data to a file of the specified name and type in XML format, using the dictionaryFromModel method.
	if ([type isEqualToString:VRDocumentType]) {
		[[self undoManager] removeAllActions];
		return [[self dictionaryFromModel] writeToFile:fileName atomically:YES];
	} else {
		return NO;
	}
}

- (NSDictionary *)dictionaryFromModel { // r1s4.2.1
	// Convert the document's internal data into an intermediate NSDictionary object.
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:NSStringFromClass([self class]) forKey:VRDocumentClassKey];
    [dictionary setObject:[NSString stringWithFormat:@"%d", VRDocumentVersion] forKey:VRDocumentVersionKey];
    [[self buttonModel] addDataToDictionary:dictionary];
    [[self sliderModel] addDataToDictionary:dictionary]; // r3s1
    [[self textFieldModel] addDataToDictionary:dictionary]; // r4s1
	// Insert calls to other model objects' addDataToDictionary: methods here.
    return dictionary;
}

// Loading information from persistent storage

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)type { // r1s5
	// Override method to read the document's data from a file of the specified name and type in XML format.
	if ([type isEqualToString:VRDocumentType]) {
		NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:fileName];
		[[self buttonModel] restoreDataFromDictionary:dictionary];
		[[self sliderModel] restoreDataFromDictionary:dictionary]; // r3s1
		[[self textFieldModel] restoreDataFromDictionary:dictionary]; // r4s1
		// Insert calls to other model objects' restoreDataFromDictionary: methods here.
		return (dictionary != nil);
	} else {
		return NO;
	}
}
*/

- (NSData *)dataRepresentationOfType:(NSString *)type { // r12s2, r21s1
	if ([self isJaguarOrNewer]) {
		if ([type isEqualToString:VRDocumentType]) {
			[[self undoManager] removeAllActions];

			NSMutableData *data = [NSMutableData data];
			NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

			[archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
			// Useful choices are NSPropertyListXMLFormat_v1_0 and NSPropertyListBinaryFormat_v1_0

			[archiver setDelegate:[[self windowControllers] objectAtIndex:0]]; // r17s1

			[archiver encodeInt:VRDocumentVersion forKey:VRDocumentVersionKey];
			[archiver encodeObject:[self buttonModel] forKey:VRDocumentButtonModelKey];
			[archiver encodeObject:[self sliderModel] forKey:VRDocumentSliderModelKey];
			[archiver encodeObject:[self textFieldModel] forKey:VRDocumentTextFieldModelKey];
			[archiver encodeObject:[self drawerModel] forKey:VRDocumentDrawerModelKey];
			[archiver finishEncoding];

			[archiver release];
			return data;
		}
	}
	return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type { // r12s2, r21s1
	if ([self isJaguarOrNewer]) {
		if ([type isEqualToString:VRDocumentType]) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

			if ([[self windowControllers] count] > 0) {
				[unarchiver setDelegate:[[self windowControllers] objectAtIndex:0]]; // r17s1
			}

			[self setButtonModel:[unarchiver decodeObjectForKey:VRDocumentButtonModelKey]];
			[[self buttonModel] initAfterUnarchivingWithDocument:self]; // r12s5, r17s1
			[self setSliderModel:[unarchiver decodeObjectForKey:VRDocumentSliderModelKey]];
			[[self sliderModel] initAfterUnarchivingWithDocument:self]; // r12s5, r17s1
			[self setTextFieldModel:[unarchiver decodeObjectForKey:VRDocumentTextFieldModelKey]];
			[[self textFieldModel] initAfterUnarchivingWithDocument:self]; // r12s5, r17s1
			[self setDrawerModel:[unarchiver decodeObjectForKey:VRDocumentDrawerModelKey]]; // r16s7
			[[self drawerModel] initAfterUnarchivingWithDocument:self]; // r16s7, r17s1
			[unarchiver finishDecoding];

			[unarchiver release];
			return YES;
		}
	}
	return NO;
}

@end
