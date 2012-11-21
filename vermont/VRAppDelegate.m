/*
 Vermont Recipes
 VRAppDelegate.m
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRAppDelegate.h"

@implementation VRAppDelegate // r15s2

- (BOOL)isPumaOrNewer { // r21s1
	// Mac OS X 10.1 or newer
	return (floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_1);
}

- (BOOL)isJaguarOrNewer { // r21s1
	// Mac OS X 10.2 or newer
	return (floor(NSAppKitVersionNumber) >= 663); // Mac OS X 10.2
}

#pragma mark DELEGATE METHODS

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender { // r21s1
	// Delegate method per NSApplication to suppress or allow untitled window at launch.
	return [self isJaguarOrNewer];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification { // r21s1
	// Delegate method per NSApplication to signal application is launching.
	if (![self isPumaOrNewer]) {
		// present alert and abort launch
		NSString *alertTitle = NSLocalizedString(@"Newer version of Mac OS X required", @"Title for 10.0 launch alert");
		NSString *alertInformation = NSLocalizedString(@"Vermont Recipes will not run in Mac OS X 10.0. Mac OS X 10.2 or newer is recommended. Go to www.apple.com/macosx for information about upgrading.", @"Informative text for 10.0 launch alert");
		NSRunAlertPanel(alertTitle, alertInformation, @"Quit", nil, nil);
		[NSApp terminate:self];
	} else if (![self isJaguarOrNewer]) {
		// present alert
		NSString *alertTitle = NSLocalizedString(@"Newer version of Mac OS X recommended", @"Title for 10.1 launch alert");
		NSString *alertInformation = NSLocalizedString(@"Vermont Recipes will not save or read documents in Mac OS X 10.1. Mac OS X 10.2 or newer is recommended. Go to www.apple.com/macosx for information about upgrading.", @"Informative text for 10.1 launch alert");
		NSRunCriticalAlertPanel(alertTitle, alertInformation, nil, nil, nil);
	}
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender { // r15s2
	// Delegate method per NSApplication to provide dynamic dock menu.

	// Load DockMenu.nib lazily for basic dock menu before customizing it dynamically.
	if (dynamicDockMenu == nil) {
		if (![NSBundle loadNibNamed:@"DockMenu" owner:self]) {
			return nil;
		}
	}

	// Add and remove Close All menu item depending on whether windows are open and visible.
	BOOL visibleWindows = NO;
	NSEnumerator *windowEnumerator = [[sender windows] objectEnumerator];
	NSWindow *window;
	while (window = [windowEnumerator nextObject]) {
		if ([window isVisible]) {
			visibleWindows = YES;
			break;
		}
	}
	
	NSMenuItem *closeAllMenuItem = [dynamicDockMenu itemWithTitle:NSLocalizedString(@"Close All", @"Name of Close All dock menu item")];
	if (!visibleWindows) {
		if (closeAllMenuItem != nil) {
			[dynamicDockMenu removeItem:closeAllMenuItem];
		}
	} else {
		if (closeAllMenuItem == nil) {
			[dynamicDockMenu addItemWithTitle:NSLocalizedString(@"Close All", @"Name of Close All dock menu item") action:@selector(closeAllWindowsAction:) keyEquivalent:@""];
		}
	}

	// Add and remove checkmark on About Vermont Recipes menu item depending on whether it is key.
	// (Won't work until Apple implements images in dynamic dock menu items.)
	int menuItemIndex = [dynamicDockMenu indexOfItemWithTarget:nil andAction:@selector(orderFrontStandardAboutPanel:)];
	[[dynamicDockMenu itemAtIndex:menuItemIndex] setState:([[[[sender keyWindow] delegate] description] hasPrefix:@"<NSSystemInfoPanel:"]) ? NSOnState : NSOffState];

	return dynamicDockMenu;
}

#pragma mark ACTIONS

- (void)closeAllWindowsAction:(id)sender { // r15s2
	[[NSApp windows] makeObjectsPerformSelector:@selector(performClose:)];
}

- (IBAction)openPreferencesWindowAction:(id)sender { // r18s2
	if (!preferencesWindowController) {
		// Create a new preferences window controller if it does not already exist.
		preferencesWindowController = [[VRPreferencesWindowController alloc] init];
	}
	[preferencesWindowController showWindow:sender];
}

- (IBAction)showReadMeAction:(id)sender { // r20s3
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ReadMe" ofType:@"rtf"];
	if (path) {
		if (![[NSWorkspace sharedWorkspace] openFile:path withApplication:@"TextEdit"]) NSBeep();
	}
}

@end
