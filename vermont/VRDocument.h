/*
 Vermont Recipes
 VRDocument.h
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.
 
 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r1s1, r1s3.2

@class VRButtonModel; // r1s3.5.3
@class VRSliderModel; // r3s1
@class VRTextFieldModel; // r4s1
@class VRDrawerModel; // r16s7

@interface VRDocument : NSDocument { // r1s1, r1s3.3
    @private // r1s3.5.3
    VRButtonModel *buttonModel; // r1s3.5.3
    VRSliderModel *sliderModel; // r3s1
    VRTextFieldModel *textFieldModel; // r4s1
	VRDrawerModel *drawerModel; // r16s7
}

- (BOOL)isJaguarOrNewer; // r21s1

#pragma mark ACCESSORS

- (void)setButtonModel:(VRButtonModel *)inValue; // r12s4
- (VRButtonModel *)buttonModel; // r1s3.5.3

- (void)setSliderModel:(VRSliderModel *)inValue; // r12s4
- (VRSliderModel *)sliderModel; // r3s1

- (void)setTextFieldModel:(VRTextFieldModel *)inValue; // r12s2
- (VRTextFieldModel *)textFieldModel; // r4s1

- (void)setDrawerModel:(VRDrawerModel *)inValue; // r16s7
- (VRDrawerModel *)drawerModel; // r16s7

	/* REMOVED r12
#pragma mark STORAGE

// Saving information to persistent storage

- (NSDictionary *)dictionaryFromModel; // r1s4.2.1
*/

@end
