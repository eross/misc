/*
 Vermont Recipes
 VRButtonController.m
 Copyright © 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "VRMainWindowController.h" // r2s1
#import "VRButtonModel.h" // r2s1

@implementation VRMainWindowController (VRButtonController) // r2s1

#pragma mark ACCESSORS

- (VRButtonModel *)buttonModel { // r1s3.5.5
    return [[self document] buttonModel];
}

- (NSButton *)checkbox { // r1s3.4
    return checkbox;
}

// Pegs switch button group

- (NSButton *)trianglePegsCheckbox { // r2s2
    return trianglePegsCheckbox;
}

- (NSButton *)squarePegsCheckbox { // r2s2
    return squarePegsCheckbox;
}

- (NSButton *)roundPegsCheckbox { // r2s2
    return roundPegsCheckbox;
}

- (NSButton *)allPegsCheckbox { // r2s2
    return allPegsCheckbox;
}

// Music switch button group

- (NSButton *)playMusicCheckbox { // r2s3
    return playMusicCheckbox;
}

- (NSButton *)rockCheckbox { // r2s3
    return rockCheckbox;
}

- (NSButton *)recentRockCheckbox { // r2s3
    return recentRockCheckbox;
}

- (NSButton *)oldiesRockCheckbox { // r2s3
    return oldiesRockCheckbox;
}

- (NSButton *)classicalCheckbox { // r2s3
    return classicalCheckbox;
}

// Party radio button cluster

- (NSMatrix *)partyRadioCluster { // r2s4
    return partyRadioCluster;
}

// State pop-up menu button

- (NSPopUpButton *)statePopUpButton { // r2s5
    return statePopUpButton;
}

#pragma mark WINDOW MANAGEMENT

- (void)registerNotificationObserversForButtonsTab { // r2s1
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCheckbox:) name:VRButtonModelCheckboxValueChangedNotification object:[self document]]; // r1s6.3
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5

    // Pegs
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrianglePegsCheckbox:) name:VRButtonModelTrianglePegsValueChangedNotification object:[self document]]; // r2s2
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrianglePegsCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSquarePegsCheckbox:) name:VRButtonModelSquarePegsValueChangedNotification object:[self document]]; // r2s2
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSquarePegsCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoundPegsCheckbox:) name:VRButtonModelRoundPegsValueChangedNotification object:[self document]]; // r2s2
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoundPegsCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllPegsCheckbox:) name:VRButtonModelTrianglePegsValueChangedNotification object:[self document]]; // r2s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllPegsCheckbox:) name:VRButtonModelSquarePegsValueChangedNotification object:[self document]]; // r2s2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllPegsCheckbox:) name:VRButtonModelRoundPegsValueChangedNotification object:[self document]]; // r2s2
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllPegsCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5

    // Music
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayMusicCheckbox:) name:VRButtonModelPlayMusicValueChangedNotification object:[self document]]; // r2s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayMusicCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRockCheckbox:) name:VRButtonModelRockValueChangedNotification object:[self document]]; // r2s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRockCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecentRockCheckbox:) name:VRButtonModelRecentRockValueChangedNotification object:[self document]]; // r2s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecentRockCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOldiesRockCheckbox:) name:VRButtonModelOldiesRockValueChangedNotification object:[self document]]; // r2s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOldiesRockCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClassicalCheckbox:) name:VRButtonModelClassicalValueChangedNotification object:[self document]]; // r2s3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClassicalCheckbox:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5

    // Party
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePartyRadioCluster:) name:VRButtonModelPartyValueChangedNotification object:[self document]]; // r2s4
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePartyRadioCluster:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5

    // State
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatePopUpButton:) name:VRButtonModelStateValueChangedNotification object:[self document]]; // r2s5
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatePopUpButton:) name:VRButtonModelUnarchivedNotification object:[self document]]; // r12s5
}

- (void)updateButtonsTab { // r2s1
	[self updateCheckbox:nil];

    // Pegs
    [self updateTrianglePegsCheckbox:nil]; // r2s2
    [self updateSquarePegsCheckbox:nil]; // r2s2
    [self updateRoundPegsCheckbox:nil]; // r2s2
    [self updateAllPegsCheckbox:nil]; // r2s2

    // Music
    [self updatePlayMusicCheckbox:nil]; // r2s3
    [self updateRockCheckbox:nil]; // r2s3
    [self updateRecentRockCheckbox:nil]; // r2s3
    [self updateOldiesRockCheckbox:nil]; // r2s3
    [self updateClassicalCheckbox:nil]; // r2s3

    // Party
    [self updatePartyRadioCluster:nil]; // r2s4

    // State
    [self updateStatePopUpButton:nil]; // r2s5
}

- (void)setContextHelpForButtonsTab { // r20s2
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"checkboxContextHelp.rtf"] forObject:[self checkbox]]; // r20s2
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"pegsContextHelp.rtf"] forObject:[self trianglePegsCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"pegsContextHelp.rtf"] forObject:[self squarePegsCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"pegsContextHelp.rtf"] forObject:[self roundPegsCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"pegsContextHelp.rtf"] forObject:[self allPegsCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"musicContextHelp.rtf"] forObject:[self playMusicCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"musicContextHelp.rtf"] forObject:[self rockCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"musicContextHelp.rtf"] forObject:[self recentRockCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"musicContextHelp.rtf"] forObject:[self oldiesRockCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"musicContextHelp.rtf"] forObject:[self classicalCheckbox]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"partyContextHelp.rtf"] forObject:[self partyRadioCluster]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"stateContextHelp.rtf"] forObject:[self statePopUpButton]];
	[[NSHelpManager sharedHelpManager] setContextHelp:[[NSBundle mainBundle] contextHelpForKey:@"beeperContextHelp.rtf"] forObject:beeperPopUpButton];
}

#pragma mark INTERFACE MANAGEMENT - Specific updaters

- (void)updateCheckbox:(NSNotification *)notification { // r1s6.3, r12s5
	// Updates user control when VRButtonModelCheckboxValueChangedNotification is received from VRButtonModel object after user chooses Undo or Redo menu item to change value of checkboxValue variable, and when awakeFromNib calls this method.
    [self updateTwoStateCheckbox:[self checkbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelCheckboxValueChangedNotification] boolValue] : [[self buttonModel] checkboxValue]];
	[[self checkbox] setToolTip:([[self checkbox] state] == NSOnState) ? NSLocalizedString(@"The checkbox is checked", @"Tool tip for checkbox on state") : NSLocalizedString(@"The checkbox is not checked", @"Tool tip for checkbox off state")]; // r20s1
	}

// Pegs

- (void)updateTrianglePegsCheckbox:(NSNotification *)notification { // r2s2, r12s5
    [self updateTwoStateCheckbox:[self trianglePegsCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelTrianglePegsValueChangedNotification] boolValue] : [[self buttonModel] trianglePegsValue]];
}

- (void)updateSquarePegsCheckbox:(NSNotification *)notification { // r2s2, r12s5
    [self updateTwoStateCheckbox:[self squarePegsCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelSquarePegsValueChangedNotification] boolValue] : [[self buttonModel] squarePegsValue]];
}

- (void)updateRoundPegsCheckbox:(NSNotification *)notification { // r2s2, r12s5
    [self updateTwoStateCheckbox:[self roundPegsCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelRoundPegsValueChangedNotification] boolValue] : [[self buttonModel] roundPegsValue]];
}

- (int)wantAllPegsCheckboxState { // r2s2
    if ([[self buttonModel] trianglePegsValue] == YES && [[self buttonModel] squarePegsValue] == YES && [[self buttonModel] roundPegsValue] == YES) {
        return NSOnState;
    }
    else if ([[self buttonModel] trianglePegsValue] == NO && [[self buttonModel] squarePegsValue] == NO && [[self buttonModel] roundPegsValue] == NO) {
        return NSOffState;
    }
    else {
        return NSMixedState;
    }
}

- (void)updateAllPegsCheckbox:(NSNotification *)notification { // r2s2
    if ([self controlUpdatingDisabled] != [self allPegsCheckbox]) {
		[self updateMixedStateCheckbox:[self allPegsCheckbox] setting:[self wantAllPegsCheckboxState]];
	}
}

// Music

- (void)updatePlayMusicCheckbox:(NSNotification *)notification { // r2s3, r12s5
    [self updateTwoStateCheckbox:[self playMusicCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelPlayMusicValueChangedNotification] boolValue] : [[self buttonModel] playMusicValue]];
    [self enableMusicGroup:[[self buttonModel] playMusicValue]];
}

- (void)enableMusicGroup:(BOOL)flag { // r2s3
    [[self rockCheckbox] setEnabled:flag];
    [[self recentRockCheckbox] setEnabled:flag && [[self buttonModel] rockValue]];
    [[self oldiesRockCheckbox] setEnabled:flag && [[self buttonModel] rockValue]];
    [[self classicalCheckbox] setEnabled:flag];
}

- (void)updateRockCheckbox:(NSNotification *)notification { // r2s3, r12s5
    [self updateTwoStateCheckbox:[self rockCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelRockValueChangedNotification] boolValue] : [[self buttonModel] rockValue]];
    [[self recentRockCheckbox] setEnabled:[[self buttonModel] rockValue] && [[self buttonModel] playMusicValue]];
    [[self oldiesRockCheckbox] setEnabled:[[self buttonModel] rockValue] && [[self buttonModel] playMusicValue]];
}

- (void)updateRecentRockCheckbox:(NSNotification *)notification { // r2s3, r12s5
    [self updateTwoStateCheckbox:[self recentRockCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelRecentRockValueChangedNotification] boolValue] : [[self buttonModel] recentRockValue]];
}

- (void)updateOldiesRockCheckbox:(NSNotification *)notification { // r2s3, r12s5
    [self updateTwoStateCheckbox:[self oldiesRockCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelOldiesRockValueChangedNotification] boolValue] : [[self buttonModel] oldiesRockValue]];
}

- (void)updateClassicalCheckbox:(NSNotification *)notification { // r2s3, r12s5
    [self updateTwoStateCheckbox:[self classicalCheckbox] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelClassicalValueChangedNotification] boolValue] : [[self buttonModel] classicalValue]];
}

// Party

- (void)updatePartyRadioCluster:(NSNotification *)notification { // r2s4, r12s5
    [self updateRadioCluster:[self partyRadioCluster] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelPartyValueChangedNotification] intValue] : [[self buttonModel] partyValue]];
}

// State

- (void)updateStatePopUpButton:(NSNotification *)notification { // r2s5, r12s5
    [self updatePopUpButton:[self statePopUpButton] setting:([notification userInfo]) ? [[[notification userInfo] objectForKey:VRButtonModelStateValueChangedNotification] intValue] : [[self buttonModel] stateValue]];
}

#pragma mark ACTIONS

- (IBAction)checkboxAction:(id)sender { // r1s2.7
	[[self buttonModel] setCheckboxValue:([sender state] == NSOnState)]; // r1s3.6
    if ([sender state] == NSOnState) { // r1s6.2
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Checkbox", @"name of undo/redo menu item after checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Checkbox", @"name of undo/redo menu item after checkbox control was cleared")];
    }
}

// Pegs

- (IBAction)trianglePegsAction:(id)sender { // r2s2
    [[self buttonModel] setTrianglePegsValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Triangle Pegs", @"Name of undo/redo menu item after Triangle checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Triangle Pegs", @"Name of undo/redo menu item after Triangle checkbox control was cleared")];
    }
}

- (IBAction)squarePegsAction:(id)sender { // r2s2
    [[self buttonModel] setSquarePegsValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Square Pegs", @"Name of undo/redo menu item after Square checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Square Pegs", @"Name of undo/redo menu item after Square checkbox control was cleared")];
    }
}

- (IBAction)roundPegsAction:(id)sender { // r2s2
    [[self buttonModel] setRoundPegsValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Round Pegs", @"Name of undo/redo menu item after Round checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Round Pegs", @"Name of undo/redo menu item after Round checkbox control was cleared")];
    }
}

- (IBAction)allPegsAction:(id)sender { // r2s2
    int newState;

    // skip default progression from off to mixed state when clicked
    if ([sender state] == NSMixedState) {
        [sender setState:NSOnState];
    }
    newState = [sender state];

    [self disableControlUpdating:sender];
    [[self buttonModel] setTrianglePegsValue:newState];
    [[self buttonModel] setSquarePegsValue:newState];
    [[self buttonModel] setRoundPegsValue:newState];
    [self enableControlUpdating];

    if (newState == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set All Pegs", @"Name of undo/redo menu item after Select All checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear All Pegs", @"Name of undo/redo menu item after Select All checkbox control was cleared")];
    }
}

// Music

- (IBAction)playMusicAction:(id)sender { // r2s3
    [[self buttonModel] setPlayMusicValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Play Music", @"Name of undo/redo menu item after Play Music checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Play Music", @"Name of undo/redo menu item after Play Music checkbox control was cleared")];
    }
}

- (IBAction)rockAction:(id)sender { // r2s3
    [[self buttonModel] setRockValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Allow Rock", @"Name of undo/redo menu item after Allow Rock checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Allow Rock", @"Name of undo/redo menu item after Allow Rock checkbox control was cleared")];
    }
}

- (IBAction)recentRockAction:(id)sender { // r2s3
    [[self buttonModel] setRecentRockValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Recent Hits", @"Name of undo/redo menu item after Recent Hits checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Recent Hits", @"Name of undo/redo menu item after Recent Hits checkbox control was cleared")];
    }
}

- (IBAction)oldiesRockAction:(id)sender { // r2s3
    [[self buttonModel] setOldiesRockValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Oldies", @"Name of undo/redo menu item after Oldies checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Oldies", @"Name of undo/redo menu item after Oldies checkbox control was cleared")];
    }
}

- (IBAction)classicalAction:(id)sender { // r2s3
    [[self buttonModel] setClassicalValue:([sender state] == NSOnState)];
    if ([sender state] == NSOnState) {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Set Classical", @"Name of undo/redo menu item after Classical checkbox control was set")];
    } else {
        [[[self document] undoManager] setActionName:NSLocalizedString(@"Clear Classical", @"Name of undo/redo menu item after Classical checkbox control was cleared")];
    }
}

// Party

- (IBAction)partyAction:(id)sender { // r2s4
    if ([[self buttonModel] partyValue] != [sender selectedTag]) { // r4s2
		[[self buttonModel] setPartyValue:[sender selectedTag]];
		switch ([[sender selectedCell] tag]) {
			case 0:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select Democratic Party", @"Name of undo/redo menu item after Democratic radio button was selected")];
				break;
			case 1:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select Republican Party", @"Name of undo/redo menu item after Republican radio button was selected")];
				break;
			case 2:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select Socialist Party", @"Name of undo/redo menu item after Socialist radio button was selected")];
				break;
		}
    }
}

// State

- (IBAction)stateAction:(id)sender { // r2s5
    if ([[self buttonModel] stateValue] != [sender indexOfSelectedItem]) { // r4s2
		[[self buttonModel] setStateValue:[sender indexOfSelectedItem]];
		switch ([sender indexOfSelectedItem]) {
			case 0:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select ME", @"Name of undo/redo menu item after Maine pop-up menu button was selected")];
				break;
			case 1:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select MA", @"Name of undo/redo menu item after Massachusetts pop-up menu button was selected")];
				break;
			case 2:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select NH", @"Name of undo/redo menu item after New Hampshire pop-up menu button was selected")];
				break;
			case 3:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select RI", @"Name of undo/redo menu item after Rhode Island pop-up menu button was selected")];
				break;
			case 4:
				[[[self document] undoManager] setActionName:NSLocalizedString(@"Select VT", @"Name of undo/redo menu item after Vermont pop-up menu button was selected")];
				break;
		}
    }
}

// Beeper

- (IBAction)beep1Action:(id)sender { // r2s6
	NSBeep();
}

- (IBAction)beep2Action:(id)sender { // r2s6
	NSBeep();
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(beepAgain:) userInfo:nil repeats:NO];
}

- (void)beepAgain:(NSTimer *)timer { // r2s6
	NSBeep();
}

@end