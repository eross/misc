/*
 Vermont Recipes
 VRMainWindowController.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRMainWindowController.h" // r1s2.7
#import "VRIntegerNumberFilter.h" // r6s1
#import "VRDecimalNumberFilter.h" // r6s2
#import "VRTelephoneFormatter.h" // r6s3
#import "VRTextFieldModel.h" // r11s8
#import "VRDrawerModel.h" // r16s5
#import "VRTextWindowController.h" // r17s4

#pragma mark MENU ITEM TAGS

#define newAntiqueRecordMenuItemTag 25000 // r13s2
#define deleteAntiqueRecordMenuItemTag 25001 // r13s2
#define addAntiqueKindMenuItemTag 25002 // r14s2

@implementation VRMainWindowController // r1s2.7

#pragma mark INITIALIZATION

- (id)init { // r1s3.3
    if (self = [super initWithWindowNibName:@"VRDocument"]) {
        [self setShouldCloseDocument:YES];

		// Combo Box
		antiqueKinds = [[NSArray arrayWithObjects:@"Dry Sinks", @"Game Boards", @"Milking Stools", @"Pocket Knives", @"Quilts", @"Rag Dolls", nil] retain]; // r10s3, r11s9; not internationalized on the provincial pretense that these are distinctively American kinds of antiques called by the same names in every language
		antiqueKindCommands = [[NSArray arrayWithObjects:NSLocalizedString(@"All", @"Kind of all antique records"), NSLocalizedString(@"New", @"Kind of new antique record"), nil] retain]; // r11s9
		antiqueKindsForMenu = [[NSMutableArray alloc] init]; // r11s9
    }
    return self;
}

- (void)dealloc { // r1s3.3
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[[self fieldEditorForUndoableTextControl] release]; // r7s2

	// Combo Box
	[antiqueKinds release]; // r10s3
	[antiqueKindCommands release]; // r11s9
	[antiqueKindsForMenu release]; // r11s9

	// Antiques table view
	[[self filteredAntiques] release]; // r11s7

	// Drawer
	[[self textWindowController] release]; // r17s4

	[super dealloc];
}

#pragma mark ACCESSORS

- (NSTabView *)tabView { // r2s7
    return tabView;
}

// Navigation push buttons

- (NSButton *)backButton { // r2s7
    return backButton;
}

- (NSButton *)nextButton { // r2s7
    return nextButton;
}

- (void)setControlUpdatingDisabled:(NSControl *)inValue { // r2s2
    controlUpdatingDisabled = inValue;
}

// Control Updating

- (NSControl *)controlUpdatingDisabled { // r2s2
    return controlUpdatingDisabled;
}

// Field editors

- (void)setfieldEditorForUndoableTextControl:(NSTextView *)fieldEditor { // r7s2, r9s5
	fieldEditorForUndoableTextControl = fieldEditor;
}

- (NSTextView *)fieldEditorForUndoableTextControl { // r7s2, r9s5
	return fieldEditorForUndoableTextControl;
}

#pragma mark UNDO MANAGEMENT

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window { // r1s6.1
	// Delegate method to tell undo manager that the document handles updating the user interface after undo and redo.
    return [[self document] undoManager];
}

- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)object { // r7s2, r9s5, r11s5
	// Delegate method per NSWindow to provide a separate field editor to the window for the object. Called from the window's fieldEditor:forObject: method whenever Cocoa needs a reference to the window's field editor; for example, when a text field becomes first responder. It is used here to create a separate field editor lazily, if and when needed, and to turn its allowsUndo setting on or off as needed.
	if ((sender == [self window]) && ([object isKindOfClass:[VRUndoableTextField class]] || [object isKindOfClass:[VRUndoableForm class]] || [object isKindOfClass:[VRUndoableTableView class]])) {
		if (![self fieldEditorForUndoableTextControl]) {
			// Create separate field editor lazily.
			[self setfieldEditorForUndoableTextControl:[[NSText alloc] init]];
			[[self fieldEditorForUndoableTextControl] setFieldEditor:YES];
		}
		[[self fieldEditorForUndoableTextControl] setAllowsUndo:YES]; // Initialize default.

		// Turn off "live" undo and redo here for individual fields of multifield undoable text controls, as desired. For controls that have only one text field, it is preferred simply to declare it as its native type instead of its undoable subclass.
		if ((object == [self addressForm]) && ([object indexOfSelectedItem] == 3)) {
			[[self fieldEditorForUndoableTextControl] setAllowsUndo:NO];
		}
		
		return [self fieldEditorForUndoableTextControl];
	}
	return nil;
}

#pragma mark WINDOW MANAGEMENT

- (void)awakeFromNib { // r1s4, r1s6.3
	// Override method to update user interface when user creates new document or opens existing document, after nib file is unarchived, initialization is completed, and connections are instantiated, but before window becomes visible.
	[self prepareAntiqueKindsForMenu]; // r11s9
	if ([[self antiqueKindsForMenu] count] <= 12) [[self antiqueKindComboBox] setHasVerticalScroller:NO]; // r10s3, r11s9
	[[self antiqueKindComboBox] setStringValue:[[self antiqueKindsForMenu] objectAtIndex:[self comboBox:[self antiqueKindComboBox] indexOfItemWithStringValue:NSLocalizedString(@"All", @"Kind of all antique records")]]]; // r10s3, r11s9

	[[self allPegsCheckbox] setAllowsMixedState:YES]; // r2s2

	//[[[self notesView] textStorage] setDelegate:self]; // r16s5, REMOVED r17s1

    [self makeFormatters]; // r6s1
	[self registerNotificationObservers]; // r1s6.3
	[self registerDragTypes]; // r8
	[self updateWindow]; // r1s6.3
	[self setContextHelp]; // r20s2; added more context help and moved it to separate method

	if (![[self document] fileName]) { // r4s1, r18s1
		// For new documents only, check status of preferences file and center window.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; // r18s1
		if (![defaults objectForKey:@"UserPreferencesValidated"]) { // r18s1
			// If user defaults database does not contain a userPrefsValidated entry (or entry is NO), warn user and set entry to suppress this check for subsequent new documents even after relaunching the application. This check will only be made the first time a user runs the application and after the com.stepwise.VermontRecipes.plist file has been removed from the user's Preferences folder.
			[defaults setBool:YES forKey:@"UserPreferencesValidated"]; // suppress future prefs checks
			[self openPrefsAlertPanel];
		}
		[[self window] center]; // r1s4.3
	}

	// Development build checks to ensure that the window is properly configured in the nib file. These will be optimized out of the deployment build of the application.
    NSAssert(([[[self tabView] tabViewItemAtIndex:0] tabState] == NSSelectedTab), @"First tab view item should be selected in VRDocument.nib."); // r4s1
    NSAssert((![[self backButton] isEnabled]), @"Back button should be disabled in VRDocument.nib."); // r4s1
    NSAssert(([[self nextButton] isEnabled]), @"Next button should be enabled in VRDocument.nib."); // r4s1
}

- (void)openPrefsAlertPanel { // r18s1
	NSPanel *prefsAlertPanel = NSGetAlertPanel(NSLocalizedString(@"Default document settings will be used", @"Message text for new document alert if preferences for new document settings not found"), NSLocalizedString(@"Your user preferences aren't currently available. Choose Preferences in the Application Menu to customize settings for your new documents.", @"Informative text for new document alert if preferences for new document settings not found"), @"OK", nil, nil);
	NSModalSession prefsAlertModalSession = [NSApp beginModalSessionForWindow:prefsAlertPanel];
	
	NSDictionary *timerInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSData dataWithBytes:&prefsAlertModalSession length:sizeof(prefsAlertModalSession)], @"ModalSessionKey", prefsAlertPanel, @"AlertPanelKey", nil];
	NSTimer *prefsAlertTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(closePrefsAlertPanel:) userInfo:timerInfo repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:prefsAlertTimer forMode:@"NSModalPanelRunLoopMode"];
	
	int modalResult;
	do {
		modalResult = [NSApp runModalSession:prefsAlertModalSession];
		if (modalResult == NSOKButton) { // OK button clicked
			[prefsAlertTimer invalidate]; // required only if timer did not fire
			[NSApp abortModal];
			[NSApp endModalSession:prefsAlertModalSession];
			NSReleaseAlertPanel(prefsAlertPanel);
		}
	} while (modalResult == NSRunContinuesResponse);
}

- (void)closePrefsAlertPanel:(NSTimer *)timer { // r18s1
	[NSApp abortModal];
	NSModalSession prefsAlertModalSession;
	[[[timer userInfo] objectForKey:@"ModalSessionKey"] getBytes:&prefsAlertModalSession];
	[NSApp endModalSession:prefsAlertModalSession];
	NSReleaseAlertPanel([[timer userInfo] objectForKey:@"AlertPanelKey"]);
}

- (void)makeFormatters { // r6s1
    [self makeIntegerNumberFilter];
    [self makeDecimalNumberFilter]; // r6s2
    [self makeTelephoneFormatter]; // r6s3
}

- (void)registerNotificationObservers { // r1s6.3
	// Convenience method to register all user control notification observers at once.
	[self registerNotificationObserversForButtonsTab]; // r2s1
	[self registerNotificationObserversForSlidersTab]; // r3s1
	[self registerNotificationObserversForTextFieldsTab]; // r4s1
//	[self registerNotificationObserversForDrawer]; // r16s5, REMOVED r17s1
}

- (void)registerDragTypes { // r8
	[self registerDragTypesForSlidersTab];
	[self registerDragTypesForTextFieldsTab];
}

- (void)updateWindow { // r1s6.3
	// Convenience method to update the visible state of the window's user controls all at once.
	[self updateButtonsTab]; // r2s1
	[self updateSlidersTab]; // r3s1
	[self updateTextFieldsTab]; // r4s1
	[self updateDrawer]; // r16s5
}

- (void)setContextHelp { // r20s2
	// Convenience method to set context help for all user controls and views at once.
	[self setContextHelpForButtonsTab];
	[self setContextHelpForSlidersTab];
	[self setContextHelpForTextFieldsTab];
	[self setContextHelpForDrawer];
}

- (void)tabView:(NSTabView *)theTabView willSelectTabViewItem:(NSTabViewItem *)theTabViewItem { // r2s7
	// Delegate method per NSTabView to provide the tab view item that is about to be selected, so the window controller can enable or disable the navigation buttons depending on whether the first, last or another tab view item is being selected.
    if (theTabView == [self tabView]) {
        [[self backButton] setEnabled:([theTabView indexOfTabViewItem:theTabViewItem] > 0)];
        [[self nextButton] setEnabled:([theTabView indexOfTabViewItem:theTabViewItem] + 1 < [theTabView numberOfTabViewItems])];
    }
}

#pragma mark INTERFACE MANAGEMENT - View update utilities

- (void)disableControlUpdating:(NSControl *)control { // r2s2
    [self setControlUpdatingDisabled:control];
}

- (void)enableControlUpdating { // r2s2
    [self setControlUpdatingDisabled:nil];
}

#pragma mark INTERFACE MANAGEMENT - Generic updaters

- (void)updateTwoStateCheckbox:(NSButton *)control setting:(BOOL)value { // r1s6.3
	// Updates any checkbox user control having only two states.
    if (value != [control state]) {
        [control setState:(value ? NSOnState : NSOffState)];
    }
}

- (void)updateMixedStateCheckbox:(NSButton *)control setting:(int)inValue { // r2s2
	// Updates a mixed-state checkbox user control having three states.
	// The inValue parameter must be one of NSOnState, NSOffState, or NSMixedState.
    if (inValue != [control state]) {
        [control setState:inValue];
    }
}

- (void)updateRadioCluster:(NSMatrix *)control setting:(int)inValue { // r2s4
	// Updates a radio cluster matrix having any number of radio buttons.
	// The inValue parameter must be an integer.
    if (inValue != [control selectedTag]) {
        [control selectCellWithTag:inValue];
    }
}

- (void)updatePopUpButton:(NSPopUpButton *)control setting:(int)inValue { // r2s5
	// Updates a pop-up button. The inValue parameter must be an integer.
    if (inValue != [control indexOfSelectedItem]) {
        [control selectItemAtIndex:inValue];
    }
}

- (void)updateSlider:(NSSlider *)control setting:(float)inValue { // r3s1
	// Updates a slider. The inValue parameter must be a float.
    if (inValue != [control floatValue]) {
        [control setFloatValue:inValue];
    }
}

#pragma mark MENU MANAGEMENT

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem { // r13s2
	int tag = [menuItem tag];
	NSString *identifier = [[[self tabView] selectedTabViewItem] identifier];

	NSTableView *table = [self antiquesTable]; // r14s2

	NSString *selectedKind; // r14s2
	if ([table selectedRow] != -1) {
		selectedKind = [[table dataSource] tableView:table objectValueForTableColumn:[table tableColumnWithIdentifier:@"antiqueKind"] row:[table selectedRow]]; // r14s2
	}

	if (tag == newAntiqueRecordMenuItemTag) {
		return ([identifier isEqualToString:@"text fields"] && [[self newAntiqueButton] isEnabled]);
	} else if (tag == deleteAntiqueRecordMenuItemTag) {
		return ([identifier isEqualToString:@"text fields"] && ([table selectedRow] != -1) && [[self deleteAntiqueButton] isEnabled]);
	} else if (tag == addAntiqueKindMenuItemTag) {
		return ([identifier isEqualToString:@"text fields"] && ([table selectedRow] != -1) && [[self newAntiqueButton] isEnabled] && ![[self antiqueKindsForMenu] containsObject:selectedKind]); // r14s2
	}
	return YES;
}

#pragma mark DATA SOURCES

// Combo boxes

- (int)numberOfItemsInComboBox:(NSComboBox *)comboBox { // r10s3, r11s9
	if (comboBox == [self antiqueKindComboBox]) {
		return [[self antiqueKindsForMenu] count];
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -numberOfItemsInComboBox: - comboBox not known"];
	return 0;
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(int)index { // r10s3, r11s9
	if (comboBox == [self antiqueKindComboBox]) {
		return [[self antiqueKindsForMenu] objectAtIndex:index];
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -comboBox:objectValueForItemAtIndex: - comboBox not known"];
	return nil;
}

- (unsigned int)comboBox:(NSComboBox *)comboBox indexOfItemWithStringValue:(NSString *)string { // r10s3, r11s9
	if (comboBox == [self antiqueKindComboBox]) {
		return [[self antiqueKindsForMenu] indexOfObject: string];
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -comboBox:indexOfItemWithStringValue: - comboBox not known"];
	return -1;
}

- (NSString *)comboBox:(NSComboBox *)comboBox datasource:(NSString *)partialString { // r10s3, r11s9
	if (comboBox == [self antiqueKindComboBox]) {
		int idx; // loop counter
		for (idx = 0; idx < [[self antiqueKindsForMenu] count]; idx++) {
			NSString *testItem = [[self antiqueKindsForMenu] objectAtIndex:idx];
			if ([[testItem commonPrefixWithString:partialString options:NSCaseInsensitiveSearch] length] == [partialString length]) {
				return testItem;
			}
		}
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -comboBox:dataSource: - comboBox not known"];
	return @"";
}

// Table views

- (int)numberOfRowsInTableView:(NSTableView *)tableView { // r11s8
	// Required datasource protocol method to return number of records. Uses filteredAntiques array if it exists, otherwise model antiques array.
	if (tableView == [self antiquesTable]) {
		NSMutableArray *whichArray = [self filteredAntiques] ? [self filteredAntiques] : [[self textFieldModel] antiques];
		return [whichArray count];
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -numberOfRowsInTableView: - tableView not known"];
	return -1;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row { // r11s8
	// Required datasource protocol method to get object in cell. Uses filteredAntiques array if it exists, otherwise model antiques array.
	if (tableView == [self antiquesTable]) {
		NSMutableArray *whichArray = ([self filteredAntiques]) ? [self filteredAntiques] : [[self textFieldModel] antiques];
		NSParameterAssert(row >= 0 && row < [whichArray count]);
		return [[whichArray objectAtIndex:row] valueForKey:[tableColumn identifier]];
	}
	[NSException raise:NSInvalidArgumentException format:@"Exception raised in VRMainWindowController -tableView:objectValueForTableColumn:row: - tableView not known"];
	return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row { // r11s8
	// Optional datasource protocol method to set object in cell. Uses filteredAntiques array if it exists, otherwise model antiques array.
	if (tableView == [self antiquesTable]) {
		NSString *identifier = [tableColumn identifier];
		VRAntiqueRecord *record;

		NSMutableArray *whichArray = [self filteredAntiques] ? [self filteredAntiques] : [[self textFieldModel] antiques];
		NSParameterAssert(row >= 0 && row < [whichArray count]);
		record = [whichArray objectAtIndex:row];

		if ((![[[self document] undoManager] isUndoing] && ![object isEqual:[record valueForKey:identifier]]) || [[self antiquesTable] isEditing]) {
			[record takeValue:object forKey:identifier];
			[[[self document] undoManager] setActionName:[NSString stringWithFormat:NSLocalizedString(@"Set %@ of Antique ID %@", @"Name of undo/redo menu item after antique record was edited"), [[tableColumn headerCell] stringValue], [record valueForKey:@"antiqueID"]]];
		}
		[self validateAntiquesTableButtons]; // r11s9
	}
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row { // r11s7
	// Delegate method per NSTableView to alter cell's appearance before it is displayed in table.
	if (tableView == [self antiquesTable]) {
		[cell setFont:([[cell stringValue] isEqualToString:NSLocalizedString(@"New", @"Kind of new antique record")] ? [NSFont boldSystemFontOfSize:[NSFont systemFontSize]] : [NSFont controlContentFontOfSize:[NSFont systemFontSize]])];
	}
}

#pragma mark ACTIONS

// Navigation

- (IBAction)backAction:(id)sender { // r2s7
    [[self tabView] selectPreviousTabViewItem:sender];
}

- (IBAction)nextAction:(id)sender { // r2s7
    [[self tabView] selectNextTabViewItem:sender];
}

#pragma mark INPUT VALIDATION AND FORMATTING

// Validation of pending edits

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem { // r5s3
	// Delegate method per NSTabView to intercept attempt to select another tab view item; used here to validate and commit a pending text field entry (forces invocation of control:textShouldEndEditing: or control:didFailToFormatString:errorDescription:).
    return [[self window] makeFirstResponder:[self window]]; // text field must resign first responder status
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor { // r5s2
	// Delegate method per NSControl to intercept attempt to resign first responder status.
    if (control == [self speedTextField]) {
		if ([[fieldEditor string] isEqualToString:@""]) {
            // Prevent blank entries (which are not caught by formatters)
            return [self sheetForBlankTextField:control name:NSLocalizedString(@"Speed Limiter", @"Name of Speed Limiter text field")];
        }
	} else if (control == [self integerTextField]) { // r6s1
		if ([[fieldEditor string] isEqualToString:@""]) {
            // Prevent blank entries (which are not caught by formatters)
			return [self sheetForBlankTextField:control name:NSLocalizedString(@"Integer", @"Name of Integer text field")];
		}
    } else if (control == [self decimalTextField]) { // r6s2
		if ([[fieldEditor string] isEqualToString:@""]) {
            // Prevent blank entries (which are not caught by formatters)
			return [self sheetForBlankTextField:control name:NSLocalizedString(@"Decimal", @"Name of Decimal text field")];
		}
    } else if (control == [self addressForm]) { // r9s2
		if (([[self addressForm] indexOfSelectedItem] == 1 || [[self addressForm] indexOfSelectedItem] == 2) && ([[fieldEditor string] isEqualToString:@""])) {
            // Prevent blank entries (which are not caught by formatters)
			return [self sheetForBlankTextField:control name:nil];
		}
    } else if (control == [self antiquesTable] && ![[self antiquesTable] isUndoing]) { // r11s10
		if ([[self antiquesTable] editedColumn] == [[self antiquesTable] columnWithIdentifier:@"antiqueID"]) {
			if ([[fieldEditor string] isEqualToString:@""]) { // empty string
				return NO; // should call alert sheet here
			} else if (![[[self document] textFieldModel] isUniqueAntiqueID:[NSNumber numberWithInt:[[fieldEditor string] intValue]]]) { // non-unique ID
				return NO; // should call alert sheet here
			} else { // new unique ID
				[[[self document] textFieldModel] setLastAntiqueID:[[fieldEditor string] intValue]];
				return YES; // let this field resign
			}
		} else if ([[self antiquesTable] editedColumn] == [[self antiquesTable] columnWithIdentifier:@"antiqueKind"]) {
			if ([[fieldEditor string] isEqualToString:@""]) { // empty string
				return NO; // should call alert sheet here
			}
		}
	}
	return YES; // let other controls resign
}

/* REMOVED r17s1
- (void)textStorageDidProcessEditing:(NSNotification *)notification { // r16s5
	// Delegate method per NSTextStorage to intercept changes to a text view's model layer.
	if ([notification object] == [[self notesView] textStorage]) {
		[[self drawerModel] setNotesWhileEditing:[[self notesView] RTFFromRange:NSMakeRange(0, [[[self notesView] string] length])]];
	}
}
*/

- (BOOL)sheetForBlankTextField:(NSControl *)control name:(NSString *)fieldName { // r5s2
	// Method to present sheet regarding invalid blank text field entry.

    NSString *alertMessage;

    NSString *alertInformation = NSLocalizedString(@"A value must be entered in this field.",  @"Informative text for alert posed by any text field if blank when attempting to resign first responder status");
    NSString *defaultButtonString = NSLocalizedString(@"Edit", @"Name of Edit button");
    NSString *otherButtonString = NSLocalizedString(@"Cancel", @"Name of Cancel button");

    if (fieldName == nil) {
        alertMessage = NSLocalizedString(@"The field is blank.", @"Message text for alert posed by any unnamed field if blank when attempting to resign first responder status");
    } else {
        alertMessage = [NSString stringWithFormat:NSLocalizedString(@"The %@ field is blank.", @"Message text for alert posed by any named text field if blank when attempting to resign first responder status"), fieldName];
    }

    NSBeginAlertSheet(alertMessage, defaultButtonString, nil, otherButtonString, [self window], self, @selector(blankTextFieldSheetDidEnd:returnCode:contextInfo:), NULL, control, alertInformation);

    return NO; // reject bad string
}

- (void)blankTextFieldSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo { // r5s2
	// Modal delegate callback method for NSBeginAlertSheet() function; called in the sheetForBlankTextField:name: method
    if (returnCode == NSAlertOtherReturn) { // Cancel
		// Cancel user entry by aborting text field and reinstating original value
        NSTextField *field = (NSTextField *)contextInfo;
        [field abortEditing];
        [field selectText:self];
    }
}

// Formatter constructors

- (void)makeIntegerNumberFilter { // r6s1
	// Instantiate an input filter. Uses a custom NSNumberFormatter subclass to catch non-numeric input characters for an integer number text field.
    VRIntegerNumberFilter *integerNumberFilter = [[VRIntegerNumberFilter alloc] init];
    [integerNumberFilter setFormat:@"##0"];
    [[[self integerTextField] cell] setFormatter:integerNumberFilter];
	[[[[self antiquesTable] tableColumnWithIdentifier:@"antiqueID"] dataCell] setFormatter:integerNumberFilter]; // r11s10
	[integerNumberFilter release];
}

- (void)makeDecimalNumberFilter { // r6s2
	// Instantiate an input filter and formatter. Uses a custom NSNumberFormatter subclass to catch non-decimal input characters and format a decimal number text field.
    VRDecimalNumberFilter *decimalNumberFilter = [[VRDecimalNumberFilter alloc] init];
    [decimalNumberFilter setFormat:@"#,##0.00"];
    [[[self decimalTextField] cell] setFormatter:decimalNumberFilter];
	[decimalNumberFilter release];
}

- (void)makeTelephoneFormatter { // r6s3
	// Instantiate an input filter and formatter. Uses a custom NSFormatter subclass to catch non-telephone number input characters and format a telephone text field.
    VRTelephoneFormatter *telephoneFormatter = [[VRTelephoneFormatter alloc] init];
    [[[self telephoneTextField] cell] setFormatter:telephoneFormatter];
	[[[self addressForm] cellAtIndex:3] setFormatter:telephoneFormatter]; // r9s4
	[telephoneFormatter release];
}

// Formatter errors

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error { // r5s1
	// Delegate method per NSControl to intercept completed entry format errors based on the formatter for the control's cell.
    if (control == [self speedTextField]) {
        return [self sheetForSpeedTextFieldFormatFailure:string errorDescription:error];
    } else if (control == [self telephoneTextField]) { // r6s3
		NSBeep();
		return [self sheetForTelephoneTextFieldFormatFailure:string errorDescription:error];
    } else if (control == [self addressForm]) { // r9s4
		NSBeep();
		if ([[self addressForm] indexOfSelectedItem] == 3) {
			return [self sheetForTelephoneTextFieldFormatFailure:string errorDescription:error];
		}
		return NO;
    }
	return YES;
}

- (void)control:(NSControl *)control didFailToValidatePartialString:(NSString *)string errorDescription:(NSString *)error { // r6s1
	// Delegate method per NSControl to intercept on-the-fly entry format errors based on the formatter for the control's cell.
    if (control == [self integerTextField]) {
        NSBeep();
    } else if (control == [self decimalTextField]) { // r6s2
        if (error != nil) {
            // By convention, VRDecimalNumberFilter returns nil in the errorDescription parameter when it substitutes an edited string for the string the user typed.
            NSBeep();
            [self sheetForDecimalTextFieldValidationFailure:string errorDescription:error];
        }
    } else if (control == [self telephoneTextField]) { // r6s3
        if (error != nil) {
            // By convention, VRTelephoneNumberFilter returns nil in the errorDescription parameter when it substitutes an edited string for the string the user typed.
            NSBeep();
            [self sheetForTelephoneTextFieldValidationFailure:string errorDescription:error];
        }
    } else if ((control == [self addressForm]) && ([[self addressForm] indexOfSelectedItem] == 3)) { // r9s4
		if (error != nil) {
			NSBeep();
			[self sheetForTelephoneTextFieldValidationFailure:string errorDescription:error];
		}
	} else if ((control == [self antiquesTable]) && ([[self antiquesTable] editedColumn] == [[self antiquesTable] columnWithIdentifier:@"antiqueID"])) { // r11s10
		NSBeep();
	}
}

#pragma mark CONTROL VALIDATION

- (void) tableViewSelectionDidChange:(NSNotification *)notification { // r11s6
	// Delegate method per NSTableView to enable or disable deleteAntiqueButton based on whether a row containing a new kind is currently selected in the antiques table.
	if ([notification object] == [self antiquesTable]) {
		[self validateAntiquesTableButtons];
	}
}

- (void)controlTextDidBeginEditing:(NSNotification *)notification { // r11s6
	// Delegate method per NSControl to disable newAntiquebutton and deleteAntiqueButton when editing begins in a cell in the antiques table.
	if ([notification object] == [self antiquesTable]) {
		[[self newAntiqueButton] setEnabled:NO];
		[[self deleteAntiqueButton] setEnabled:NO];
	}
}

- (void)controlTextDidEndEditing:(NSNotification *)notification { // r11s6
	// Delegate method per NSControl to enable newAntiquebutton and deleteAntiqueButton when editing ends in a cell in the antiques table.
	if ([notification object] == [self antiquesTable]) {
		[[self newAntiqueButton] setEnabled:YES];
		[[self deleteAntiqueButton] setEnabled:YES];
	}
}

#pragma mark ARCHIVING

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object { // r17s1
	// Delegate method per NSKeyedUnarchiver to track object just unarchived
	if ([object isKindOfClass:[[self drawerModel] class]]) {
		[[self notesView] replaceCharactersInRange:NSMakeRange(0, [[[self notesView] string] length]) withRTF:[[object notes] RTFFromRange:NSMakeRange(0, [[[object notes] string] length]) documentAttributes:nil]];
		[object setNotes:nil];
		return object;
	}
	return object;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object { // r17s1
	// Delegate method per NSKeyedArchiver to modify object about to be archived.
	if (object == [self drawerModel]) {
		[object setNotes:[[self notesView] textStorage]];
		return object;
	}
	return object;
}

@end

