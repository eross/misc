/*
 Vermont Recipes
 VRTextFieldController.m
 Copyright Љ 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRMainWindowController.h" // r4s1
#import "VRTextFieldModel.h" // r4s1

@implementation VRMainWindowController (VRTextFieldController)

#pragma mark ACCESSORS

- (VRTextFieldModel *)textFieldModel { // r4s1
    return [[self document] textFieldModel];
}

// Formatted text fields

- (VRUndoableTextField *)integerTextField { // r4s1, r7s6
    return integerTextField;
}

- (NSTextField *)decimalTextField { // r4s1
    return decimalTextField;
}

- (NSTextField *)telephoneTextField { // r4s1
    return telephoneTextField;
}

// Form

- (VRUndoableForm *)addressForm { // r9s2, r9s5
	return addressForm;
}

// Combo box

- (NSComboBox *)antiqueKindComboBox { // r10s2
	return antiqueKindComboBox;
}

- (NSArray *)antiqueKinds { // r11s9
	return antiqueKinds;
}

- (NSArray *)antiqueKindCommands { // r11s9
	return antiqueKindCommands;
}

- (NSMutableArray *)antiqueKindsForMenu { // r11s9
	return antiqueKindsForMenu;
}

// Antiques table

- (VRAntiquesTableView *)antiquesTable { // r11s2
	return antiquesTable;
}

- (NSButton *)newAntiqueButton { // r11s2
	return newAntiqueButton;
}

- (NSButton *)deleteAntiqueButton { // r11s2
	return deleteAntiqueButton;
}

- (NSButton *)addAntiqueKindButton { // r11s2
	return addAntiqueKindButton;
}

- (NSMutableArray *)filteredAntiques { // r11s7
	return filteredAntiques;
}


#pragma mark INTERFACE MANAGEMENT - Specific updaters

// Formatted text fields

- (void)updateIntegerTextField:(NSNotification *)notification { // r4s1, r12s5
	if (([[self textFieldModel] integerValue] != [[self integerTextField] intValue]) || ([[[self integerTextField] stringValue] isEqualToString:@""])) {
		[[self integerTextField] setIntValue:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRTextFieldModelIntegerValueChangedNotification] intValue] : [[self textFieldModel] integerValue]];
	}
}

- (void)updateDecimalTextField:(NSNotification *)notification { // r4s1, r12s5
	if (([[self textFieldModel] decimalValue] != [[self decimalTextField] floatValue])  || ([[[self decimalTextField] stringValue] isEqualToString:@""])) {
		[[self decimalTextField] setFloatValue:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRTextFieldModelDecimalValueChangedNotification] floatValue] : [[self textFieldModel] decimalValue]];
	}
}

- (void)updateTelephoneTextField:(NSNotification *)notification { // r4s1, r12s5
	if ((![[[self textFieldModel] telephoneValue] isEqualToString:[[self telephoneTextField] stringValue]])) {
		[[self telephoneTextField] setStringValue:([notification userInfo]) ? [[notification userInfo] objectForKey:VRTextFieldModelTelephoneValueChangedNotification] : [[self textFieldModel] telephoneValue]];
	}
}

// Form

- (void)updateFormNameEntry:(NSNotification *)notification { // r9s2, r12s5
	if (![[[self textFieldModel] formNameValue] isEqualToString:[[[self addressForm] cellAtIndex:0] stringValue]]) {
		[[[self addressForm] cellAtIndex:0] setStringValue:([notification userInfo]) ? [[notification userInfo] objectForKey:VRTextFieldModelFormNameValueChangedNotification] : [[self textFieldModel] formNameValue]];
	}
}

- (void)updateFormIdEntry:(NSNotification *)notification { // r9s2, r12s5
	if (([[[self addressForm] cellAtIndex:1] objectValue] == nil) || (![[[self textFieldModel] formIdValue] isEqualToNumber:[[[self addressForm] cellAtIndex:1] objectValue]])) {
		[[[self addressForm] cellAtIndex:1] setObjectValue:([notification userInfo]) ? [[notification userInfo] objectForKey:VRTextFieldModelFormIdValueChangedNotification] : [[self textFieldModel] formIdValue]];
	}
}

- (void)updateFormDateEntry:(NSNotification *)notification { // r9s2, r12s5
	if (([[[self addressForm] cellAtIndex:2] objectValue] == nil) || (![[[self textFieldModel] formDateValue] isEqualToDate:[[[self addressForm] cellAtIndex:2] objectValue]])) {
		[[[self addressForm] cellAtIndex:2] setObjectValue:([notification userInfo]) ? [[notification userInfo] objectForKey:VRTextFieldModelFormDateValueChangedNotification] : [[self textFieldModel] formDateValue]];
	}
}

- (void)updateFormFaxEntry:(NSNotification *)notification { // r9s2, r12s5
	if (![[[self textFieldModel] formFaxValue] isEqualToString:[[[self addressForm] cellAtIndex:3] stringValue]]) {
		[[[self addressForm] cellAtIndex:3] setStringValue:([notification userInfo]) ? [[notification userInfo] objectForKey:VRTextFieldModelFormFaxValueChangedNotification] : [[self textFieldModel] formFaxValue]];
	}
}

// Antiques table

- (void)updateAntiquesTable:(NSNotification *)notification { // r11s2, r11s6
	// Notification method per VRTextFieldModelAntiquesArrayChangedNotification.
	[[self antiquesTable] abortEditing]; // in case record was selected for editing when deleted
	[self filterAntiqueRecords];
}

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForTextFieldsTab { // r4s1
	// Formatted text fields
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIntegerTextField:) name:VRTextFieldModelIntegerValueChangedNotification object:[self document]]; // r4s1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIntegerTextField:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDecimalTextField:) name:VRTextFieldModelDecimalValueChangedNotification object:[self document]]; // r4s1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDecimalTextField:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTelephoneTextField:) name:VRTextFieldModelTelephoneValueChangedNotification object:[self document]]; // r4s1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTelephoneTextField:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5

    // Form
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormNameEntry:) name:VRTextFieldModelFormNameValueChangedNotification object:[self document]]; // r9s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormNameEntry:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormIdEntry:) name:VRTextFieldModelFormIdValueChangedNotification object:[self document]]; // r9s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormIdEntry:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormDateEntry:) name:VRTextFieldModelFormDateValueChangedNotification object:[self document]]; // r9s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormDateEntry:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormFaxEntry:) name:VRTextFieldModelFormFaxValueChangedNotification object:[self document]]; // r9s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFormFaxEntry:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5

	// Antiques table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAntiquesTable:) name:VRTextFieldModelAntiquesArrayChangedNotification object:[self document]]; // r11s2
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAntiquesTable:) name:VRAntiqueRecordChangedNotification object:[self document]]; // r11s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAntiquesTable:) name:VRTextFieldModelUnarchivedNotification object:[self document]]; // r12s5
}

- (void)registerDragTypesForTextFieldsTab { // r8
	[[self integerTextField] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
	[[self decimalTextField] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
	[[self telephoneTextField] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
	[[self addressForm] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]]; // r9s6
	[[self antiqueKindComboBox] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]]; // r10s4
    [[self antiquesTable] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]]; // r11s11
}

- (void)updateTextFieldsTab { // r4s1
	// Formatted text fields
    [self updateIntegerTextField:nil];
    [self updateDecimalTextField:nil];
    [self updateTelephoneTextField:nil];

    // Form
    [self updateFormNameEntry:nil]; // r9s2
    [self updateFormIdEntry:nil]; // r9s2
    [self updateFormDateEntry:nil]; // r9s2
    [self updateFormFaxEntry:nil]; // r9s2

	// Antiques table
	[self updateAntiquesTable:nil]; // r11s2
}

- (void)setContextHelpForTextFieldsTab { // r20s2
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"integerContextHelp.rtf"] forObject:[self integerTextField]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"decimalContextHelp.rtf"] forObject:[self decimalTextField]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"telephoneContextHelp.rtf"] forObject:[self telephoneTextField]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"formNameContextHelp.rtf"] forObject:[[self addressForm] cellAtIndex:0]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"formIDContextHelp.rtf"] forObject:[[self addressForm] cellAtIndex:1]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"formDateContextHelp.rtf"] forObject:[[self addressForm] cellAtIndex:2]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"formFaxContextHelp.rtf"] forObject:[[self addressForm] cellAtIndex:3]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"kindContextHelp.rtf"] forObject:[self antiqueKindComboBox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"antiquesContextHelp.rtf"] forObject:[self antiquesTable]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"addKindContextHelp.rtf"] forObject:[self addAntiqueKindButton]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"plusMinusContextHelp.rtf"] forObject:[self newAntiqueButton]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"plusMinusContextHelp.rtf"] forObject:[self deleteAntiqueButton]];
}

#pragma mark ACTIONS

// Formatted text fields

- (IBAction)integerTextFieldAction:(id)sender { // r4s1, r7s6
    if (([[self textFieldModel] integerValue] != [sender intValue]) || [sender isEditing]) { // r4s2, r7s6
		[[self textFieldModel] setIntegerValue:[sender intValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Integer Value", @"Name of undo/redo menu item after Integer text field was set")];
	}
}

- (IBAction)decimalTextFieldAction:(id)sender { // r4s1
    if ([[self textFieldModel] decimalValue] != [sender floatValue]) { // r4s2
		[[self textFieldModel] setDecimalValue:[sender floatValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Decimal Value", @"Name of undo/redo menu item after Decimal text field was set")];
	}
}

- (IBAction)telephoneTextFieldAction:(id)sender { // r4s1
    if (![[[self textFieldModel] telephoneValue] isEqualToString:[sender stringValue]]) { // r4s2
		[[self textFieldModel] setTelephoneValue:[sender stringValue]];
		[[[self document] undoManager] setActionName:NSLocalizedString(@"Set Telephone Value", @"Name of undo/redo menu item after Telephone text field was set")];
	}
}

// Form

- (IBAction)formNameEntryAction:(id)sender { // r9s2
    if (![[[self textFieldModel] formNameValue] isEqualToString:[sender stringValue]] || [sender isEditing]) {
        [[self textFieldModel] setFormNameValue:[sender stringValue]];
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Form Name Value", @"Name of undo/redo menu item after Form Name text field was set")];
    }
}

- (IBAction)formIdEntryAction:(id)sender { // r9s2
    if (![[[self textFieldModel] formIdValue] isEqualToNumber:[sender objectValue]] || [sender isEditing]) {
        [[self textFieldModel] setFormIdValue:[sender objectValue]];
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Form ID Value", @"Name of undo/redo menu item after Form ID text field was set")];
    }
}

- (IBAction)formDateEntryAction:(id)sender { // r9s2
    if (![[[[self textFieldModel] formDateValue] descriptionWithCalendarFormat:@"%B %e, %Y"] isEqualToString:[sender stringValue]] || [sender isEditing]) {
        [[self textFieldModel] setFormDateValue:[sender objectValue]];
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Form Date Value", @"Name of undo/redo menu item after Form Date text field was set")];
    }
}

- (IBAction)formFaxEntryAction:(id)sender { // r9s2
    if (![[[self textFieldModel] formFaxValue] isEqualToString:[sender stringValue]] || [sender isEditing]) {
        [[self textFieldModel] setFormFaxValue:[sender stringValue]];
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Form Fax Value", @"Name of undo/redo menu item after Form Fax text field was set")];
    }
}

// Combo box

- (IBAction)filterAntiqueRecordsAction:(id)sender { // r10s2
	[self filterAntiqueRecords]; // r11s7
}

// Antiques table

- (IBAction)newAntiqueRecordAction:(id)sender { // r11s2, r11s6
	// Adds new record to antiques table with a unique antiqueID and selects it for editing in the Antiques table. Adding a new record is undoable at the model layer.
	VRAntiquesTableView *table = [self antiquesTable];
	int newRow = [table numberOfRows]; // current count is index of next available row
	NSMutableArray *antiques = [[self textFieldModel] antiques];

	// Create empty record at end of model array with a unique ID.
	[[self textFieldModel] newAntiqueRecord];
	[[[self document] undoManager] setActionName:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Add Antique ID ", @"Name of undo/redo menu item after antique record was added"), [[[antiques lastObject] antiqueID] stringValue]]];

	// Select a cell in the new row for editing.
	[table selectRow:newRow byExtendingSelection:NO]; // must select row before editing it
	[table editColumn:[table columnWithIdentifier:@"antiqueKind"] row:newRow withEvent:nil select:YES]; // select cell for editing and scroll it into view
}

- (IBAction)deleteAntiqueRecordAction:(id)sender { // r11s2, r11s6
	// Deletes selected record from Antiques table. Deleting a record is undoable at the model layer.
	VRAntiquesTableView *table = [self antiquesTable];
	NSMutableArray *whichArray = ([self filteredAntiques]) ? [self filteredAntiques] : [[self textFieldModel] antiques];
	VRAntiqueRecord *record = [whichArray objectAtIndex:[table selectedRow]]; // selected record

	[[self textFieldModel] deleteAntiqueRecord:record];
	[[[self document] undoManager] setActionName:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Delete Antique ID ", @"Name of undo/redo menu item after antique record was deleted"), [[record antiqueID] stringValue]]];
}

- (void)validateAntiquesTableButtons { // r11s6
	NSTableView *table = [self antiquesTable];
	
	NSString *selectedKind; // r11s9
	if ([table selectedRow] != -1) {
		selectedKind = [[table dataSource] tableView:table objectValueForTableColumn:[table tableColumnWithIdentifier:@"antiqueKind"] row:[table selectedRow]]; // r11s9
	}

	[[self deleteAntiqueButton] setEnabled:([table selectedRow] != -1)];
	[[self addAntiqueKindButton] setEnabled:(([table selectedRow] != -1) && (![[self antiqueKindsForMenu] containsObject:selectedKind]))]; // r11s9
}

- (IBAction)addAntiqueKindAction:(id)sender { // r11s2, r11s9
	NSTableView *table = [self antiquesTable];
	NSString *selectedKind = [[table dataSource] tableView:table objectValueForTableColumn:[table tableColumnWithIdentifier:@"antiqueKind"] row:[table selectedRow]];

	[[[self textFieldModel] antiqueAddedKinds] addObject:selectedKind];
	[self prepareAntiqueKindsForMenu];
	[[self antiqueKindComboBox] reloadData];
	[[self antiqueKindComboBox] setHasVerticalScroller:[[self antiqueKindsForMenu] count] > 12];
	[[self addAntiqueKindButton] setEnabled:NO];
}

- (void)prepareAntiqueKindsForMenu { // r11s9
	// Combines built-in antiqueKinds and antiqueAddedKinds, alphabetizes them, and adds general commands at top ("All", "New") before showing menu.
	NSMutableArray *tempKinds = [[NSMutableArray alloc] init];

	[tempKinds addObjectsFromArray:[self antiqueKinds]];
	[tempKinds addObjectsFromArray:[[self textFieldModel] antiqueAddedKinds]];
	[tempKinds sortUsingSelector:@selector(caseInsensitiveCompare:)];

	[[self antiqueKindsForMenu] removeAllObjects];
	[[self antiqueKindsForMenu] addObjectsFromArray:[self antiqueKindCommands]];
	[[self antiqueKindsForMenu] addObjectsFromArray:tempKinds];

	[tempKinds release];
}

- (void)filterAntiqueRecords { // r11s7
	// Creates filtered array from model array according to current filter chosen in Kind combo box if filter is not "All" and updates Antiques table. Always displays records whose kind = "New" to encourage assignment of a real kind.
	NSString *kind = [[self antiqueKindComboBox] stringValue];

	if ([kind isEqualToString:NSLocalizedString(@"All", @"Kind of all antique records")]) { // no filtering needed
		// Set filteredAntiques to nil to force data source methods defined in VRMainWindowController.m to use model antiques array to reload data into table.
		if ([self filteredAntiques]) {
			[[self filteredAntiques] release];
			filteredAntiques = nil;
		}
	} else { // populate filtered array from model array
		// Create filteredAntiques array to force data source methods defined in VRMainWindowController.m to use filteredAntiques array to reload data into table.
		NSMutableArray *antiques = [[self textFieldModel] antiques]; // model array
		NSEnumerator *enumerator = [antiques objectEnumerator];
		VRAntiqueRecord *record;

		if ([self filteredAntiques]) {
			[[self filteredAntiques] removeAllObjects];
		} else {
			filteredAntiques = [[NSMutableArray alloc] init];
		}
		while (record = [enumerator nextObject]) { // iterate through model array
			if ([[record antiqueKind] isEqualToString:kind] || [[record antiqueKind] isEqualToString:NSLocalizedString(@"New", @"Kind of new antique record")]) {
				// Always display "New" records
				[filteredAntiques addObject:record]; // add record to filtered array
			}
		}
	}
	[[self antiquesTable] reloadData]; // update table from either array, according to data source methods defined in VRMainWindowController.m.
}

#pragma mark INPUT VALIDATION AND FORMATTING

// Formatter errors

// Decimal text field

- (BOOL)sheetForDecimalTextFieldValidationFailure:(NSString *)string errorDescription:(NSString *)error { // r6s2
	// Method to present sheet regarding an illegal character in the Decimal text field.

    NSString *alertInformation = NSLocalizedString(@"Type any of the digits в0гав9г and a single decimal point for a decimal number, such as в1,472.34г.", @"Informative text for alert posed by Decimal text field when invalid character is typed");

    NSBeginAlertSheet(error, nil, nil, nil, [self window], self, NULL, NULL, nil, alertInformation);

    return NO; // reject bad string
}

// Telephone text field

- (BOOL)sheetForTelephoneTextFieldValidationFailure:(NSString *)string errorDescription:(NSString *)error { // r6s3
	// Method to present sheet regarding an illegal character in the Telephone text field.

    NSString *alertInformation = NSLocalizedString(@"Type ten digits в0гав9г for a telephone number, such as в(800) 555-1212г.", @"Informative text for alert posed by Telephone text field when invalid character is typed");

    NSBeginAlertSheet(error, nil, nil, nil, [self window], self, NULL, NULL, nil, alertInformation);

    return NO; // reject bad string
}

- (BOOL)sheetForTelephoneTextFieldFormatFailure:(NSString *)string errorDescription:(NSString *)error { // r6s3
	// Method to present sheet regarding an incomplete string in the Telephone text field.

    NSString *alertInformation = NSLocalizedString(@"Type ten digits в0гав9г for a telephone number, such as в(800) 555-1212г.", @"Informative text for alert posed by Telephone text field when incomplete phone number is entered");

    NSBeginAlertSheet(error, nil, nil, nil, [self window], self, NULL, NULL, nil, alertInformation);

    return NO; // reject bad string
}

@end
