/*
 Vermont Recipes
 VRPreferencesWindowController.m
 Copyright � 2000-2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 IMPORTANT: This software is provided to you by Bill Cheeseman (the "Author"), courtesy of the Stepwise Web site and its webmaster, Scott Anguish, and Peachpit Press, Inc. (together, the "Publishers"), in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

 In consideration of your agreement to abide by the following terms, and subject to these terms, the Author, with the consent of the Publishers, grants you a personal, non-exclusive license, under the copyrights in this original software (the "Software"), to use, reproduce, modify and redistribute the Software, with or without modifications, in source and/or binary forms; provided that you may not redistribute the Software in its entirety and without modifications. Neither the name, trademarks, service marks nor logos of the Author or either of the Publishers may be used to endorse or promote products derived from the Software without specific prior written permission of the owner. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Software may be incorporated.

 The Software is provided on an "AS IS" basis. THE AUTHOR AND THE PUBLISHERS MAKE NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL THE AUTHOR OR EITHER OF THE PUBLISHERS BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF THE AUTHOR OR EITHER OF THE PUBLISHERS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "VRPreferencesWindowController.h"

@implementation VRPreferencesWindowController

#pragma mark INITIALIZATION

- (id) init { // r18s2
	self = [super initWithWindowNibName:@"VRPreferences"];
	return self;
}

#pragma mark ACCESSORS

- (NSButton *)checkbox { // r18s2
	return checkbox;
}

- (NSTextField *)speedTextField { // r18s2
	return speedTextField;
}

#pragma mark WINDOW MANAGEMENT

- (void)awakeFromNib { // r18s2
	[[self checkbox] setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"CheckboxValue"]];
	[[self speedTextField] setFloatValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SpeedValue"]];
	[[self window] center];
}

#pragma mark ACTIONS

- (IBAction)checkboxAction:(id)sender { // r18s2
	[[NSUserDefaults standardUserDefaults] setBool:[[self checkbox] state] forKey:@"CheckboxValue"];
}

- (IBAction)speedTextFieldAction:(id)sender { // r18s2
	[[NSUserDefaults standardUserDefaults] setFloat:[[self speedTextField] floatValue] forKey:@"SpeedValue"];
}

- (IBAction)closeButtonAction:(id)sender { // r18s2
	[[self window] makeFirstResponder:[self window]]; // force commit pending edits
	[[self window] close];
}

@end
