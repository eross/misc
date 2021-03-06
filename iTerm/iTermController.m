// -*- mode:objc -*-
// $Id: iTermController.m,v 1.53 2006/09/24 05:10:51 yfabian Exp $
/*
 **  iTermController.m
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **	     Initial code by Kiichi Kusama
 **
 **  Project: iTerm
 **
 **  Description: Implements the main application delegate and handles the addressbook functions.
 **
 **  This program is free software; you can redistribute it and/or modify
 **  it under the terms of the GNU General Public License as published by
 **  the Free Software Foundation; either version 2 of the License, or
 **  (at your option) any later version.
 **
 **  This program is distributed in the hope that it will be useful,
 **  but WITHOUT ANY WARRANTY; without even the implied warranty of
 **  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 **  GNU General Public License for more details.
 **
 **  You should have received a copy of the GNU General Public License
 **  along with this program; if not, write to the Free Software
 **  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

// Debug option
#define DEBUG_ALLOC           0
#define DEBUG_METHOD_TRACE    0

#import <iTerm/iTermController.h>
#import <iTerm/PreferencePanel.h>
#import <iTerm/PseudoTerminal.h>
#import <iTerm/PTYSession.h>
#import <iTerm/VT100Screen.h>
#import <iTerm/NSStringITerm.h>
#import <iTerm/ITAddressBookMgr.h>
#import <iTerm/Tree.h>
#import <iTerm/ITConfigPanelController.h>
#import <iTerm/iTermGrowlDelegate.h>

static NSString* APPLICATION_SUPPORT_DIRECTORY = @"~/Library/Application Support";
static NSString *SUPPORT_DIRECTORY = @"~/Library/Application Support/iTerm";
static NSString *SCRIPT_DIRECTORY = @"~/Library/Application Support/iTerm/Scripts";

// Comparator for sorting encodings
static int _compareEncodingByLocalizedName(id a, id b, void *unused)
{
	NSString *sa = [NSString localizedNameOfStringEncoding: [a unsignedIntValue]];
	NSString *sb = [NSString localizedNameOfStringEncoding: [b unsignedIntValue]];
	return [sa caseInsensitiveCompare: sb];
}


@implementation iTermController

+ (iTermController*)sharedInstance;
{
    static iTermController* shared = nil;
    
    if (!shared)
        shared = [[iTermController alloc] init];
    
    return shared;
}


// init
- (id) init
{
#if DEBUG_ALLOC
    NSLog(@"%s(%d):-[iTermController init]",
          __FILE__, __LINE__);
#endif
    self = [super init];

    
    // create the iTerm directory if it does not exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // create the "~/Library/Application Support" directory if it does not exist
    if([fileManager fileExistsAtPath: [APPLICATION_SUPPORT_DIRECTORY stringByExpandingTildeInPath]] == NO)
        [fileManager createDirectoryAtPath: [APPLICATION_SUPPORT_DIRECTORY stringByExpandingTildeInPath] attributes: nil];
    
    if([fileManager fileExistsAtPath: [SUPPORT_DIRECTORY stringByExpandingTildeInPath]] == NO)
        [fileManager createDirectoryAtPath: [SUPPORT_DIRECTORY stringByExpandingTildeInPath] attributes: nil];
    
    terminalWindows = [[NSMutableArray alloc] init];
	terminalLock = [[NSLock alloc] init];
    
	// read preferences
	[PreferencePanel sharedInstance];

    // Activate Growl
	/*
	 * Need to add routine in iTerm prefs for Growl support and
	 * PLIST check here.
	 */
    gd = [iTermGrowlDelegate sharedInstance];
    
    return (self);
}

- (void) dealloc
{
#if DEBUG_ALLOC
    NSLog(@"%s(%d):-[iTermController dealloc]",
          __FILE__, __LINE__);
#endif

    // Release the GrowlDelegate
	if( gd )
		[gd release];
    
    [terminalWindows removeAllObjects];
    [terminalWindows release];
    [terminalLock release];
    
    [super dealloc];
}

// Action methods
- (IBAction)newWindow:(id)sender
{
    [self launchBookmark:nil inTerminal: nil];
}

- (void) newSessionInTabAtIndex: (id) sender
{
    [self launchBookmark:[sender representedObject] inTerminal:FRONT];
}

- (void)newSessionInWindowAtIndex: (id) sender
{
    [self launchBookmark:[sender representedObject] inTerminal:nil];
}

// meant for action for menu items that have a submenu
- (void) noAction: (id) sender
{
	
}

- (IBAction)newSession:(id)sender
{
    [self launchBookmark:nil inTerminal: FRONT];
}

// navigation
- (IBAction) previousTerminal: (id) sender
{
    unsigned int currentIndex;

    currentIndex = [[self terminals] indexOfObject: FRONT];
    if(FRONT == nil || currentIndex == NSNotFound)
    {
	NSBeep();
	return;
    }

    // get the previous terminal
    if(currentIndex == 0)
	currentIndex = [[self terminals] count] - 1;
    else
	currentIndex--;

    // make sure that terminal's window active
    [[[[self terminals] objectAtIndex: currentIndex] window] makeKeyAndOrderFront: self];
    
}
- (IBAction)nextTerminal: (id) sender
{
    unsigned int currentIndex;

    currentIndex = [[self terminals] indexOfObject: FRONT];
    if(FRONT == nil || currentIndex == NSNotFound)
    {
	NSBeep();
	return;
    }

    // get the next terminal
    if(currentIndex == [[self terminals] count] - 1)
	currentIndex = 0;
    else
	currentIndex++;

    // make sure that terminal's window active
    [[[[self terminals] objectAtIndex: currentIndex] window] makeKeyAndOrderFront: self];
}

- (PseudoTerminal *) currentTerminal
{
    return (FRONT);
}

- (void) terminalWillClose: (PseudoTerminal *) theTerminalWindow
{
    if(FRONT == theTerminalWindow)
	[self setCurrentTerminal: nil];

    if(theTerminalWindow)
        [self removeFromTerminalsAtIndex: [terminalWindows indexOfObject: theTerminalWindow]];
}

// Build sorted list of encodings
- (NSArray *) sortedEncodingList
{
	NSStringEncoding const *p;
	NSMutableArray *tmp = [NSMutableArray array];
	
	for (p = [NSString availableStringEncodings]; *p; ++p)
		[tmp addObject:[NSNumber numberWithUnsignedInt:*p]];
	[tmp sortUsingFunction: _compareEncodingByLocalizedName context:NULL];
	
	return (tmp);
}



// Build the bookmarks menu
- (NSMenu *) buildAddressBookMenuWithTarget:(id)target withShortcuts: (BOOL) withShortcuts
{
    SEL action;
	TreeNode *bookmarks;
	
	bookmarks = [[ITAddressBookMgr sharedInstance] rootNode];
    
    if (target == nil)
        action = @selector(newSessionInWindowAtIndex:);
    else
        action = @selector(newSessionInTabAtIndex:);
    
	return ([self _menuForNode: bookmarks action: action target: target withShortcuts: withShortcuts]);
}

// Executes an addressbook command in new window or tab
- (void) launchBookmark: (NSDictionary *) bookmarkData inTerminal: (PseudoTerminal *) theTerm
{
    PseudoTerminal *term;
    NSDictionary *aDict;
	
	aDict = bookmarkData;
	if(aDict == nil)
		aDict = [[ITAddressBookMgr sharedInstance] defaultBookmarkData];
		
	// Where do we execute this command?
    if(theTerm == nil)
    {
        term = [[PseudoTerminal alloc] init];
		[term initWindowWithAddressbook: aDict];
		[self addInTerminals: term];
		[term release];
		
    }
    else
        term = theTerm;
		
	[term addNewSession: aDict];
}

- (void) launchScript: (id) sender
{
    NSString *fullPath = [NSString stringWithFormat: @"%@/%@", [SCRIPT_DIRECTORY stringByExpandingTildeInPath], [sender title]];

    NSAppleScript *script;
    NSDictionary *errorInfo = [NSDictionary dictionary];
    NSURL *aURL = [NSURL fileURLWithPath: fullPath];

    // Make sure our script suite registry is loaded
    [NSScriptSuiteRegistry sharedScriptSuiteRegistry];

    script = [[NSAppleScript alloc] initWithContentsOfURL: aURL error: &errorInfo];
    [script executeAndReturnError: &errorInfo];
    [script release];
    
}

- (PTYTextView *) frontTextView
{
    return ([[FRONT currentSession] TEXTVIEW]);
}

@end

// keys for to-many relationships:
NSString *terminalsKey = @"terminals";

// Scripting support
@implementation iTermController (KeyValueCoding)

- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key
{
    BOOL ret;
    // NSLog(@"key = %@", key);
    ret = [key isEqualToString:@"terminals"] || [key isEqualToString:@"currentTerminal"];
    return (ret);
}

// accessors for to-many relationships:
-(NSArray*)terminals
{
    // NSLog(@"iTerm: -terminals");
    return (terminalWindows);
}

-(void)setTerminals: (NSArray*)terminals
{
    // no-op
}

// accessors for to-many relationships:
// (See NSScriptKeyValueCoding.h)
-(id)valueInTerminalsAtIndex:(unsigned)index
{
    //NSLog(@"iTerm: valueInTerminalsAtIndex %d: %@", index, [terminalWindows objectAtIndex: index]);
    return ([terminalWindows objectAtIndex: index]);
}

- (void) setCurrentTerminal: (PseudoTerminal *) thePseudoTerminal
{
    FRONT = thePseudoTerminal;

    // make sure this window is the key window
    if([thePseudoTerminal windowInited] && [[thePseudoTerminal window] isKeyWindow] == NO)
		[[thePseudoTerminal window] makeKeyAndOrderFront: self];

    // Post a notification
    [[NSNotificationCenter defaultCenter] postNotificationName: @"iTermWindowBecameKey" object: nil userInfo: nil];    

}

-(void)replaceInTerminals:(PseudoTerminal *)object atIndex:(unsigned)index
{
    // NSLog(@"iTerm: replaceInTerminals 0x%x atIndex %d", object, index);
    [terminalLock lock];
    [terminalWindows replaceObjectAtIndex: index withObject: object];
    [terminalLock unlock];
}

- (void) addInTerminals: (PseudoTerminal *) object
{
    // NSLog(@"iTerm: addInTerminals 0x%x", object);
    [self insertInTerminals: object atIndex: [terminalWindows count]];
}

- (void) insertInTerminals: (PseudoTerminal *) object
{
    // NSLog(@"iTerm: insertInTerminals 0x%x", object);
    [self insertInTerminals: object atIndex: [terminalWindows count]];
}

-(void)insertInTerminals:(PseudoTerminal *)object atIndex:(unsigned)index
{
    if([terminalWindows containsObject: object] == YES)
		return;
    [terminalLock lock];
    [terminalWindows insertObject: object atIndex: index];
    [terminalLock unlock];
    // make sure we have a window
    [object initWindowWithAddressbook:NULL];
}

-(void)removeFromTerminalsAtIndex:(unsigned)index
{
    // NSLog(@"iTerm: removeFromTerminalsAtInde %d", index);
    [terminalLock lock];
    [terminalWindows removeObjectAtIndex: index];
    [terminalLock unlock];
	if([terminalWindows count] == 0)
		[ITConfigPanelController close];
}

// a class method to provide the keys for KVC:
- (NSArray*)kvcKeys
{
    static NSArray *_kvcKeys = nil;
    if( nil == _kvcKeys ){
	_kvcKeys = [[NSArray alloc] initWithObjects:
	    terminalsKey,  nil ];
    }
    return _kvcKeys;
}

@end

@implementation iTermController (Private)

- (NSMenu *) _menuForNode: (TreeNode *) theNode action: (SEL) aSelector target: (id) aTarget withShortcuts: (BOOL) withShortcuts
{
	NSMenu *aMenu, *subMenu;
	NSMenuItem *aMenuItem;
	NSEnumerator *entryEnumerator;
	NSDictionary *dataDict;
	TreeNode *childNode;
	NSString *shortcut;
	unsigned int modifierMask;
		
	aMenu = [[NSMenu alloc] init];
	
	entryEnumerator = [[theNode children] objectEnumerator];
	
	while ((childNode = [entryEnumerator nextObject]))
	{
		dataDict = [childNode nodeData];
		aMenuItem = [[[NSMenuItem alloc] initWithTitle: [dataDict objectForKey: KEY_NAME] action:aSelector keyEquivalent:@""] autorelease];
		if([childNode isGroup])
		{
			subMenu = [self _menuForNode: childNode action: aSelector target: aTarget withShortcuts: withShortcuts];
			[aMenuItem setSubmenu: subMenu];
			[aMenuItem setAction: @selector(noAction:)];
			[aMenuItem setTarget: self];
		}
		else
		{
			if(withShortcuts)
			{
				
				if([[ITAddressBookMgr sharedInstance] defaultBookmarkData] == dataDict)
				{
					if(aTarget == nil)
						shortcut = @"n";
					else
						shortcut = @"t";
					modifierMask = NSCommandKeyMask;
					
					[aMenuItem setKeyEquivalent: shortcut];
					[aMenuItem setKeyEquivalentModifierMask: modifierMask];
				}
				else if ([dataDict objectForKey: KEY_SHORTCUT] != nil)
				{
					modifierMask = NSCommandKeyMask | NSControlKeyMask;
					if(aTarget == nil)
						modifierMask |= NSAlternateKeyMask;
					
					shortcut=[dataDict objectForKey: KEY_SHORTCUT];
					shortcut = [shortcut lowercaseString];

					[aMenuItem setKeyEquivalent: shortcut];
					[aMenuItem setKeyEquivalentModifierMask: modifierMask];
				}
			}
			[aMenuItem setRepresentedObject: dataDict];
			[aMenuItem setTarget: aTarget];
		}
		[aMenu addItem: aMenuItem];
	}
	
	return ([aMenu autorelease]);
}



@end
