/*
 Vermont Recipes
 VRSliderController.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRMainWindowController.h" // r3s1
#import "VRSliderModel.h" // r3s1

@implementation VRMainWindowController (VRSliderController) // r3s1

#pragma mark ACCESSORS

- (VRSliderModel *)sliderModel { // r3s1
    return [[self document] sliderModel];
}

// Personality slider

- (NSSlider *)personalitySlider { // r3s1
    return personalitySlider;
}

// Speed slider

- (NSSlider *)speedSlider { // r3s2
    return speedSlider;
}

- (NSTextField *)speedTextField { // r3s2
    return speedTextField;
}

// Quantum slider

- (NSSlider *)quantumSlider { // r3s3
    return quantumSlider;
}

- (NSButton *)quantumButtonLo { // r3s3
    return quantumButtonLo;
}

- (NSButton *)quantumButtonHi { // r3s3
    return quantumButtonHi;
}

- (NSTextField *)quantumTextField { // r3s3
    return quantumTextField;
}

#pragma mark INTERFACE MANAGEMENT - Specific updaters

// Personality

- (void)updatePersonalitySlider:(NSNotification *)notification { // r3s1, r12s5
    [self updateSlider:[self personalitySlider] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRSliderModelPersonalityValueChangedNotification] floatValue] : [[self sliderModel] personalityValue]];
}

// Speed

- (void)updateSpeedSlider:(NSNotification *)notification { // r3s2, r12s5
    [self updateSlider:[self speedSlider] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRSliderModelSpeedValueChangedNotification] floatValue] : [[self sliderModel] speedValue]];
}

- (void)updateSpeedTextField:(NSNotification *)notification { // r3s2, r12s5
	if (([[self sliderModel] speedValue] != [[self speedTextField] floatValue]) || ([[[self speedTextField] stringValue] isEqualToString:@""])) {
		[[self speedTextField] setFloatValue:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRSliderModelSpeedValueChangedNotification] floatValue] : [[self sliderModel] speedValue]];
	}
}

// Quantum

- (void)updateQuantumSlider:(NSNotification *)notification { // r3s3, r12s5
    [self updateSlider:[self quantumSlider] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRSliderModelQuantumValueChangedNotification] floatValue] : [[self sliderModel] quantumValue]];
    [[self quantumTextField] takeIntValueFrom:[self quantumSlider]];
}

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForSlidersTab { // r3s1
	// Personality
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalitySlider:) name:VRSliderModelPersonalityValueChangedNotification object:[self document]]; // r3s1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalitySlider:) name:VRSliderModelUnarchivedNotification object:[self document]]; // r12s5

    // Speed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpeedSlider:) name:VRSliderModelSpeedValueChangedNotification object:[self document]]; // r3s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpeedSlider:) name:VRSliderModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpeedTextField:) name:VRSliderModelSpeedValueChangedNotification object:[self document]]; // r3s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpeedTextField:) name:VRSliderModelUnarchivedNotification object:[self document]]; // r12s5

    // Quantum
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuantumSlider:) name:VRSliderModelQuantumValueChangedNotification object:[self document]]; // r3s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuantumSlider:) name:VRSliderModelUnarchivedNotification object:[self document]]; // r12s5
}

- (void)registerDragTypesForSlidersTab { // r8
	[[self speedTextField] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
}

- (void)updateSlidersTab { // r3s1

    // Personality
    [self updatePersonalitySlider:nil];

    // Speed
    [self updateSpeedSlider:nil]; // r3s2
    [self updateSpeedTextField:nil]; // r3s2

    // Quantum
    [self updateQuantumSlider:nil]; // r3s3
}

- (void)setContextHelpForSlidersTab { // r20s2
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"personalityContextHelp.rtf"] forObject:[self personalitySlider]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"speedSliderContextHelp.rtf"] forObject:[self speedSlider]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"speedTextContextHelp.rtf"] forObject:[self speedTextField]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"quantumSliderContextHelp.rtf"] forObject:[self quantumSlider]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"quantumButtonLoContextHelp.rtf"] forObject:[self quantumButtonLo]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"quantumButtonHiContextHelp.rtf"] forObject:[self quantumButtonHi]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"quantumTextContextHelp.rtf"] forObject:[self quantumTextField]];
}

#pragma mark ACTIONS

// Personality

- (IBAction)personalityAction:(id)sender { // r3s1
    if ([[self sliderModel] personalityValue] != [sender floatValue]) { // r4s2
		[[self sliderModel] setPersonalityValue:[sender floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Personality", @"Name of undo/redo menu item after Personality slider was set")];

		NSString *alertMessage = [NSString localizedStringWithFormat:NSLocalizedString(@"The personality type %f is not compatible with a computer programming career.", @"Message text of alert posed by Personality slider to report value set by user"), [[self sliderModel] personalityValue]];
		NSString *alertInformation = NSLocalizedString(@"0 is Type A, 100 is Type B.", @"Informative text of alert posed by Personality slider to report value set by user");
		NSBeginAlertSheet(alertMessage, nil, nil, nil, [self window], nil, NULL, NULL, nil, alertInformation);
	}
}

// Speed

- (IBAction)speedSliderAction:(id)sender { // r3s2
    if ([[self sliderModel] speedValue] != [sender floatValue]) { // r4s2
		[[self sliderModel] setSpeedValue:[sender floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Speed Limiter", @"Name of undo/redo menu item after Speed slider was set")];
	}
}

- (IBAction)speedTextFieldAction:(id)sender { // r3s2, r4s2
    if ([[self sliderModel] speedValue] != [sender floatValue]) { // r4s2
		[[self sliderModel] setSpeedValue:[sender floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Speed Limiter", @"Name of undo/redo menu item after Speed text field was set")];
	}
}

// Quantum

- (IBAction)quantumSliderAction:(id)sender { // r3s3
    if ([[self sliderModel] quantumValue] != [sender floatValue]) { // r4s2
		[[self sliderModel] setQuantumValue:[sender floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Quantum Electron State Slider", @"Name of undo/redo menu item after Quantum slider was set")];
	}
}

- (IBAction)quantumButtonLoAction:(id)sender { // r3s3
    if ([[self sliderModel] quantumValue] != [[self quantumSlider] minValue]) { // r4s2
		[[self sliderModel] setQuantumValue:[[self quantumSlider] minValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Lowest Quantum Electron State", @"Name of undo/redo menu item after Quantum button Low was set")];
	}
}

- (IBAction)quantumButtonHiAction:(id)sender { // r3s3
    if ([[self sliderModel] quantumValue] != [[self quantumSlider] maxValue]) { // r4s2
		[[self sliderModel] setQuantumValue:[[self quantumSlider] maxValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Highest Quantum Electron State", @"Name of undo/redo menu item after Quantum button High was set")];
	}
}

#pragma mark INPUT VALIDATION AND FORMATTING

// Formatter errors

- (BOOL) sheetForSpeedTextFieldFormatFailure:(NSString *)string errorDescription:(NSString *)error { // r5s1
	// Method to present sheet regarding an illegal entry in the Speed Limiter text field.

    NSString *alertMessage;
    NSString *alternateButtonString;
    float proposedValue;
    NSDecimalNumber *proposedValueObject;

    NSString *alertInformation = [NSString localizedStringWithFormat:NSLocalizedString(@"The Speed Limiter must be set to a speed between %1.1f mph and %1.1f mph.", @"Informative text for alert posed by Speed Limiter text field when invalid value is entered"), [[self speedSlider] minValue], [[self speedSlider] maxValue]];
    NSString *defaultButtonString = NSLocalizedString(@"Edit", @"Name of Edit button");
    NSString *otherButtonString = NSLocalizedString(@"Cancel", @"Name of Cancel button");

    if ([error isEqualToString:NSLocalizedStringFromTableInBundle(@"Fell short of minimum", @"Formatter", [NSBundle bundleForClass:[NSFormatter class]], @"Presented when user value smaller than minimum")]) {
        proposedValue = [[self speedSlider] minValue];
        alertMessage = [NSString stringWithFormat:NSLocalizedString(@"%@ mph is too slow for the Speed Limiter.", @"Message text for alert posed by Speed Limiter text field when value smaller than minimum is entered"), string];
        alternateButtonString = [NSString localizedStringWithFormat:NSLocalizedString(@"Set %1.1f mph", @"Name of alternate button for alert posed by Speed Limiter text field when value smaller than minimum is entered"), proposedValue];

    } else if ([error isEqualToString:NSLocalizedStringFromTableInBundle(@"Maximum exceeded", @"Formatter", [NSBundle bundleForClass:[NSFormatter class]], @"Presented when user value larger than maximum")]) {
        proposedValue = [[self speedSlider] maxValue];
        alertMessage = [NSString stringWithFormat:NSLocalizedString(@"%@ mph is too fast for the Speed Limiter.", @"Message text for alert posed by Speed Limiter text field when value larger than maximum is entered"), string];
        alternateButtonString = [NSString localizedStringWithFormat:NSLocalizedString(@"Set %1.1f mph", @"Name of alternate button for alert posed by Speed Limiter text field when value larger than maximum is entered"), proposedValue];

    } else if ([error isEqualToString:NSLocalizedStringFromTableInBundle(@"Invalid number", @"Formatter", [NSBundle bundleForClass:[NSFormatter class]], @"Presented when user typed illegal characters -- No valid object")]) {
        alertMessage = [NSString stringWithFormat:NSLocalizedString(@"Ò%@Ó is not a valid entry for the Speed Limiter.", @"Message text for alert posed by Speed Limiter text field when invalid value is entered"), string];
        alternateButtonString = nil; // suppress the alternate button
    }

    proposedValueObject = [[NSDecimalNumber numberWithFloat:proposedValue] retain];
    NSBeep();
    NSBeginAlertSheet(alertMessage, defaultButtonString, alternateButtonString, otherButtonString, [self window], self, @selector(speedSheetDidEnd:returnCode:contextInfo:), NULL, proposedValueObject, alertInformation);

    return NO; // reject bad string
}

- (void)speedSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo { // r5s1
	// Modal delegate callback method for NSBeginAlertSheet() function; called in the sheetForSpeedTextField:errorDescription: method
    if (returnCode == NSAlertOtherReturn) { // Cancel
		// Abort text field edit session and reinstate original value
        [[self speedTextField] abortEditing];
        [[self speedTextField] selectText:self];
    } else if (returnCode == NSAlertAlternateReturn) { // Set to minValue mph, Set to maxValue mph
		// Update text field to a new minimum or maximum value, then call its action method to set data variable to match, with undo manager registration
		[[self sliderModel] setSpeedValue:[(NSDecimalNumber *)contextInfo floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Speed Limiter", @"Name of undo/redo menu item after Speed text field was set")];
    }
    [(NSString *)contextInfo release];
}

@end
