/*
 Vermont Recipes
 VRMainWindowController.h
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

#import <Cocoa/Cocoa.h> // r1s2.7, r1s3.2
#import "VRUndoableTextField.h" // r7s1
#import "VRUndoableForm.h" // r9s5
#import "VRAntiquesTableView.h" // r11s2

@class VRButtonModel; // r1s3.5.5
@class VRSliderModel; // r3s1
@class VRTextFieldModel; // r4s1
@class VRDrawerModel; // r16s5
@class VRTextWindowController; // r17s4

@interface VRMainWindowController : NSWindowController { // r1s2.7
    @private // r1s3.4
	
    IBOutlet NSTabView *tabView; // r2s7

    IBOutlet NSButton *checkbox; // r1s2.7, r1s3.4
	
	// Pegs switch button group
    IBOutlet NSButton *trianglePegsCheckbox; // r2s2
    IBOutlet NSButton *squarePegsCheckbox; // r2s2
    IBOutlet NSButton *roundPegsCheckbox; // r2s2
    IBOutlet NSButton *allPegsCheckbox; // r2s2

    // Music switch button group
    IBOutlet NSButton *playMusicCheckbox; // r2s3
    IBOutlet NSButton *rockCheckbox; // r2s3
    IBOutlet NSButton *recentRockCheckbox; // r2s3
    IBOutlet NSButton *oldiesRockCheckbox; // r2s3
    IBOutlet NSButton *classicalCheckbox; // r2s3

    // Party radio button cluster
    IBOutlet NSMatrix *partyRadioCluster; // r2s4

    // State pop-up menu button
    IBOutlet NSPopUpButton *statePopUpButton; // r2s5

	// Beeper command pop-down menu button
	IBOutlet NSPopUpButton *beeperPopUpButton; // r20s2; added for Context Help

    // Navigation push buttons
    IBOutlet NSButton *backButton; // r2s7
    IBOutlet NSButton *nextButton; // r2s7

    // Personality slider
    IBOutlet NSSlider *personalitySlider; // r3s1

    // Speed slider
    IBOutlet NSSlider *speedSlider; // r3s2
    IBOutlet NSTextField *speedTextField; // r3s2

    // Quantum slider
    IBOutlet NSSlider *quantumSlider; // r3s3
    IBOutlet NSButton *quantumButtonLo; // r3s3
    IBOutlet NSButton *quantumButtonHi; // r3s3
    IBOutlet NSTextField *quantumTextField; // r3s3

    // Formatted text fields
    IBOutlet VRUndoableTextField *integerTextField; // r4s1, r7s6
    IBOutlet NSTextField *decimalTextField; // r4s1
    IBOutlet NSTextField *telephoneTextField; // r4s1

    // Form
    IBOutlet VRUndoableForm *addressForm; // r9s2, r9s5

	// Combo box
	IBOutlet NSComboBox *antiqueKindComboBox; // r10s2
	NSArray *antiqueKinds; // r10s3, r11s9
	NSArray *antiqueKindCommands; // r11s9
	NSMutableArray *antiqueKindsForMenu; // r11s9
	
	// Antiques table
	IBOutlet VRAntiquesTableView *antiquesTable; // r11s2
	IBOutlet NSButton *newAntiqueButton; // r11s2
	IBOutlet NSButton *deleteAntiqueButton; // r11s2
	IBOutlet NSButton *addAntiqueKindButton; // r11s2
	NSMutableArray *filteredAntiques; // r11s7

	// Drawer
	IBOutlet NSTextView *notesView; //r16s5
	IBOutlet NSButton *openInWindowButton; // r17s4
	VRTextWindowController *textWindowController; // r17s4
		
    // Control Updating
	NSControl *controlUpdatingDisabled; // r2s2

    // Field Editors
    NSTextView *fieldEditorForUndoableTextControl; // r7s2, r9s5
}

#pragma mark ACCESSORS

- (NSTabView *)tabView; // r2s7

// Navigation push buttons
- (NSButton *)backButton; // r2s7
- (NSButton *)nextButton; // r2s7

// Control Updating

- (void)setControlUpdatingDisabled:(NSControl *)inValue; // r2s2
- (NSControl *)controlUpdatingDisabled; // r2s2

// Field Editors

- (void)setfieldEditorForUndoableTextControl:(NSTextView *)fieldEditor; // r7s2, r9s5
- (NSTextView *)fieldEditorForUndoableTextControl; // r7s2, r9s5

#pragma mark WINDOW MANAGEMENT

- (void)openPrefsAlertPanel; // r18s1
- (void)closePrefsAlertPanel:(NSTimer *)timer; // r18s1

- (void)makeFormatters; // r6s1
- (void)registerNotificationObservers; // r1s6.3
- (void)registerDragTypes; // r8
- (void)updateWindow; // r1s6.3
- (void)setContextHelp; // r20s2
	
#pragma mark INTERFACE MANAGEMENT - View update utilities

- (void)disableControlUpdating:(NSControl *)control; // r2s2
- (void)enableControlUpdating; // r2s2

#pragma mark INTERFACE MANAGEMENT - Generic updaters

- (void)updateTwoStateCheckbox:(NSButton *)control setting:(BOOL)inValue; // r1s6.3
- (void)updateMixedStateCheckbox:(NSButton *)control setting:(int)inValue; // r2s2
- (void)updateRadioCluster:(NSMatrix *)control setting:(int)inValue; // r2s4
- (void)updatePopUpButton:(NSPopUpButton *)control setting:(int)inValue; // r2s5
- (void)updateSlider:(NSSlider *)control setting:(float)inValue; // r3s1

#pragma mark ACTIONS

// Navigation
- (IBAction)backAction:(id)sender; // r2s7
- (IBAction)nextAction:(id)sender; // r2s7

#pragma mark INPUT VALIDATION AND FORMATTING

// Validation of pending edits

- (BOOL)sheetForBlankTextField:(NSControl *)control name:(NSString *)fieldName; // r5s2
- (void)blankTextFieldSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo; // r2s2

// Formatter constructors
- (void)makeIntegerNumberFilter; // r6s1
- (void)makeDecimalNumberFilter; // r6s2
- (void)makeTelephoneFormatter; // r6s3

@end


@interface VRMainWindowController (VRButtonController) //r2s1

#pragma mark ACCESSORS

- (VRButtonModel *)buttonModel; // r1s3.5.5

- (NSButton *)checkbox; // r1s3.4

    // Pegs switch button group
- (NSButton *)trianglePegsCheckbox; // r2s2
- (NSButton *)squarePegsCheckbox; // r2s2
- (NSButton *)roundPegsCheckbox; // r2s2
- (NSButton *)allPegsCheckbox; // r2s2

    // Music switch button group
- (NSButton *)playMusicCheckbox; // r2s3
- (NSButton *)rockCheckbox; // r2s3
- (NSButton *)recentRockCheckbox; // r2s3
- (NSButton *)oldiesRockCheckbox; // r2s3
- (NSButton *)classicalCheckbox; // r2s3

    // Party radio button cluster
- (NSMatrix *)partyRadioCluster; // r2s4

    // State pop-up menu button
- (NSPopUpButton *)statePopUpButton; // r2s5

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForButtonsTab; // r2s1
- (void)updateButtonsTab; // r2s1
- (void)setContextHelpForButtonsTab; // r20s2

#pragma mark INTERFACE MANAGEMENT - Specific updaters

- (void)updateCheckbox:(NSNotification *)notification; // r1s6.3

	// Pegs
- (void)updateTrianglePegsCheckbox:(NSNotification *)notification; // r2s2
- (void)updateSquarePegsCheckbox:(NSNotification *)notification; // r2s2
- (void)updateRoundPegsCheckbox:(NSNotification *)notification; // r2s2

- (int)wantAllPegsCheckboxState; // r2s2
- (void)updateAllPegsCheckbox:(NSNotification *)notification; // r2s2

	// Music
- (void)updatePlayMusicCheckbox:(NSNotification *)notification; // r2s3
- (void)enableMusicGroup:(BOOL)flag; // r2s3
- (void)updateRockCheckbox:(NSNotification *)notification; // r2s3
- (void)updateRecentRockCheckbox:(NSNotification *)notification; // r2s3
- (void)updateOldiesRockCheckbox:(NSNotification *)notification; // r2s3
- (void)updateClassicalCheckbox:(NSNotification *)notification; // r2s3

	// Party
- (void)updatePartyRadioCluster:(NSNotification *)notification; // r2s4

	// State
- (void)updateStatePopUpButton:(NSNotification *)notification; // r2s5

#pragma mark ACTIONS

- (IBAction)checkboxAction:(id)sender; // r1s2.7

    // Pegs
- (IBAction)trianglePegsAction:(id)sender; // r2s2
- (IBAction)squarePegsAction:(id)sender; // r2s2
- (IBAction)roundPegsAction:(id)sender; // r2s2
- (IBAction)allPegsAction:(id)sender; // r2s2

    // Music
- (IBAction)playMusicAction:(id)sender; // r2s3
- (IBAction)rockAction:(id)sender; // r2s3
- (IBAction)recentRockAction:(id)sender; // r2s3
- (IBAction)oldiesRockAction:(id)sender; // r2s3
- (IBAction)classicalAction:(id)sender; // r2s3

    // Party
- (IBAction)partyAction:(id)sender; // r2s4

    // State
- (IBAction)stateAction:(id)sender; // r2s5

    // Beeper
- (IBAction)beep1Action:(id)sender; // r2s6
- (IBAction)beep2Action:(id)sender; // r2s6
- (void)beepAgain:(NSTimer *)timer; // r2s6

@end

@interface VRMainWindowController (VRSliderController) // r3s1

#pragma mark ACCESSORS

- (VRSliderModel *)sliderModel; // r3s1

// Personality slider
- (NSSlider *)personalitySlider; // r3s1

// Speed slider
- (NSSlider *)speedSlider; // r3s2
- (NSTextField *)speedTextField; // r3s2

// Quantum slider
- (NSSlider *)quantumSlider; // r3s3
- (NSButton *)quantumButtonLo; // r3s3
- (NSButton *)quantumButtonHi; // r3s3
- (NSTextField *)quantumTextField; // r3s3

#pragma mark INTERFACE MANAGEMENT - Specific updaters

// Personality
- (void)updatePersonalitySlider:(NSNotification *)notification; // r3s1

// Speed
- (void)updateSpeedSlider:(NSNotification *)notification; // r3s2
- (void)updateSpeedTextField:(NSNotification *)notification; // r3s2

// Quantum
- (void)updateQuantumSlider:(NSNotification *)notification; // r3s3

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForSlidersTab; // r3s1
- (void)registerDragTypesForSlidersTab; // r8
- (void)updateSlidersTab; // r3s1
- (void)setContextHelpForSlidersTab; // r20s2

#pragma mark ACTIONS

// Personality
- (IBAction)personalityAction:(id)sender; // r3s1

// Speed
- (IBAction)speedSliderAction:(id)sender; // r3s2
- (IBAction)speedTextFieldAction:(id)sender; // r3s2

// Quantum
- (IBAction)quantumSliderAction:(id)sender; // r3s3
- (IBAction)quantumButtonLoAction:(id)sender; // r3s3
- (IBAction)quantumButtonHiAction:(id)sender; // r3s3

#pragma mark INPUT VALIDATION AND FORMATTING

// Formatter errors

- (BOOL)sheetForSpeedTextFieldFormatFailure:(NSString *)string errorDescription:(NSString *)error; // r5s1
- (void)speedSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo; // r5s1

@end

@interface VRMainWindowController (VRTextFieldController) // r4s1

#pragma mark ACCESSORS

- (VRTextFieldModel *)textFieldModel; // r4s1

//  Formatted text fields
- (VRUndoableTextField *)integerTextField; // r4s1, r7s6
- (NSTextField *)decimalTextField; // r4s1
- (NSTextField *)telephoneTextField; // r4s1

// Form
- (VRUndoableForm *)addressForm; // r9s2, r9s5

// Combo box
- (NSComboBox *)antiqueKindComboBox; // r10s2
- (NSArray *)antiqueKinds; // r11s9
- (NSArray *)antiqueKindCommands; // r11s9
- (NSMutableArray *)antiqueKindsForMenu; // r11s9

// Antiques table
- (VRAntiquesTableView *)antiquesTable; // r11s2
- (NSButton *)newAntiqueButton; // r11s2
- (NSButton *)deleteAntiqueButton; // r11s2
- (NSButton *)addAntiqueKindButton; // r11s2
- (NSMutableArray *)filteredAntiques; // r11s7

#pragma mark INTERFACE MANAGEMENT - Specific updaters

// Formatted text fields
- (void)updateIntegerTextField:(NSNotification *)notification; // r4s1
- (void)updateDecimalTextField:(NSNotification *)notification; // r4s1
- (void)updateTelephoneTextField:(NSNotification *)notification; // r4s1

// Form
- (void)updateFormNameEntry:(NSNotification *)notification; // r9s2
- (void)updateFormIdEntry:(NSNotification *)notification; // r9s2
- (void)updateFormDateEntry:(NSNotification *)notification; // r9s2
- (void)updateFormFaxEntry:(NSNotification *)notification; // r9s2

// Antiques table
- (void)updateAntiquesTable:(NSNotification *)notification; // r11s2

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForTextFieldsTab; // r4s1
- (void)registerDragTypesForTextFieldsTab; // r8
- (void)updateTextFieldsTab; // r4s1
- (void)setContextHelpForTextFieldsTab; // r20s2

#pragma mark ACTIONS

// Formatted text fields
- (IBAction)integerTextFieldAction:(id)sender; // r4s1
- (IBAction)decimalTextFieldAction:(id)sender; // r4s1
- (IBAction)telephoneTextFieldAction:(id)sender; // r4s1

// Form
- (IBAction)formNameEntryAction:(id)sender; // r9s2
- (IBAction)formIdEntryAction:(id)sender; // r9s2
- (IBAction)formDateEntryAction:(id)sender; // r9s2
- (IBAction)formFaxEntryAction:(id)sender; // r9s2

// Combo box
- (IBAction)filterAntiqueRecordsAction:(id)sender; // r10s2

// Antiques table
- (IBAction)newAntiqueRecordAction:(id)sender; // r11s2
- (IBAction)deleteAntiqueRecordAction:(id)sender; // r11s2
- (void)validateAntiquesTableButtons; // r11s6
- (IBAction)addAntiqueKindAction:(id)sender; // r11s2
- (void)prepareAntiqueKindsForMenu; // r11s9
- (void)filterAntiqueRecords; // r11s7

#pragma mark INPUT VALIDATION AND FORMATTING

// Formatter errors

// Decimal text field

- (BOOL) sheetForDecimalTextFieldValidationFailure:(NSString *)string errorDescription:(NSString *)error; // r6s2

// Telephone text field

- (BOOL)sheetForTelephoneTextFieldValidationFailure:(NSString *)string errorDescription:(NSString *)error; // r6s3
- (BOOL)sheetForTelephoneTextFieldFormatFailure:(NSString *)string errorDescription:(NSString *)error; // r6s3

@end

@interface VRMainWindowController (VRDrawerController) // r16s5

#pragma mark ACCESSORS

- (VRDrawerModel *)drawerModel; // r16s5

- (NSTextView *)notesView; // r16s5
- (NSButton *)openInWindowButton; // r17s4

- (void)setTextWindowController:(VRTextWindowController *)inValue; // r17s4
- (VRTextWindowController *)textWindowController; // r17s4

#pragma mark INTERFACE MANAGEMENT - Specific updaters

- (void)updateNotesView; // r16s5, r17s1
- (void)setContextHelpForDrawer; // r21s2

#pragma mark WINDOW MANAGEMENT

//- (void)registerNotificationObserversForDrawer; // r16s5, REMOVED r17s1
- (void)updateDrawer; // r16s5

#pragma mark ACTIONS

-(IBAction)openInWindowAction:(id)sender; // r17s4

@end
