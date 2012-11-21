/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

// Mail code contributed by by Michael McCracken on 7/13/2004

#import "VPSuperPlugin.h"

@implementation VPSuperPlugin

- (void) didRegister {
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    unichar c = (unichar)8;
    NSString *deleteKey = [NSString stringWithCharacters:&c length:1];
    
    
    
    [pluginManager addPluginsMenuTitle:@"Strike-Out and Move to Bottom of Page"
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doParaMove:)
                         keyEquivalent:deleteKey
             keyEquivalentModifierMask:NSControlKeyMask | NSCommandKeyMask];
    
    [pluginManager addPluginsMenuTitle:@"Alphabetize"
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doAlpha:)
                         keyEquivalent:@""
             keyEquivalentModifierMask:0];

    
    [pluginManager addPluginsMenuTitle:NSLocalizedString(@"Send Page by Email", @"Send page as email string for plugin menu")
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doMailPage:)
                         keyEquivalent:@""
             keyEquivalentModifierMask:0];
    
    [pluginManager addPluginsMenuTitle:NSLocalizedString(@"Apply Default Font to Page", @"Apply Default Font to Page")
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doMakeDefaultFont:)
                         keyEquivalent:@""
             keyEquivalentModifierMask:0];
    
    /*
    [pluginManager addPluginsMenuTitle:@"New Meeting Notes" //NSLocalizedString(@"New Meeting Notes", "New Meeting Notes")
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doMeetingNotes:)
                         keyEquivalent:@""
             keyEquivalentModifierMask:0];
    */
}


- (void) doAlpha:(id<VPPluginWindowController>)windowController {
    
    NSTextView *textView = [windowController textView];
    NSRange r = [textView selectedRange];
    
    if (r.length == 0) {
        r = NSMakeRange(0, [[textView textStorage] length]);
    }
    
    NSMutableArray *lines = [[textView textStorage] componentsSeparatedByNewline];
    
    [lines sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableAttributedString *newText  = [[[NSMutableAttributedString alloc] init] autorelease];
    NSAttributedString *newline         = [[[NSAttributedString alloc] initWithString:@"\n"] autorelease];
    NSEnumerator *enumerator            = [lines objectEnumerator];
    NSAttributedString *line;
    
    while (line = [enumerator nextObject]) {
    	
        [newText appendAttributedString:line];
        [newText appendAttributedString:newline];
    }
    
    // we don't use r for the range here, because we might have stripped out some \r's in there somewhere.
    //NSData *data    = [newText RTFDFromRange:NSMakeRange(0, [newText length]) documentAttributes:nil];
    
    [textView fmReplaceCharactersInRange:r withAttributedString:newText];
    
    // vptextview takes care of the undo for this.
    //[textView replaceCharactersInRange:r withRTFD:data];
}

- (void) doParaMove:(id<VPPluginWindowController>)windowController; {
    
    // woot, we've got a text view.
    NSTextView *textView = [windowController textView];
    NSTextStorage *ts = [textView textStorage];
    
    // find out the current location of the cursor (and what may be selected) so 
    // we can selected it back to it if we undo
    NSRange cursorLoc = [textView selectedRange];
    
    // find the paragraph range, to delete it.
    NSRange r = [textView selectionRangeForProposedRange:cursorLoc granularity:NSSelectByParagraph];
    
    NSMutableAttributedString *para  = [[[NSMutableAttributedString alloc] init] autorelease];
    
    //make sure there is a newline at the end..
    if ([ts length] > 0 && [[ts mutableString] characterAtIndex:[ts length]-1] != '\n') {
        [para appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n"] autorelease]];
    }
    
    // find the text that's to be deleted, so we can replace it with the undo
    [para appendAttributedString:[[[[textView textStorage] attributedSubstringFromRange:r] copy] autorelease]];
    
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_2) {
        
        NSNumber *styleMask = [NSNumber numberWithInt:NSNoUnderlineStyle|NSUnderlineStrikethroughMask];
        
        
        [para addAttribute:NSUnderlineStyleAttributeName
                     value:styleMask
                     range:NSMakeRange(0, [para length])];
        
    }
    else {
        
        #warning use NSStrikethroughStyleAttributeName when 10.2 is dropped.
        [para addAttribute:@"NSStrikethrough"
                     value:[NSNumber numberWithInt:1]
                     range:NSMakeRange(0, [para length])];
    }
    
    
    NSAttributedString *blankString = [[[NSAttributedString alloc] initWithString:@""] autorelease];
    
    // blank out what's there.
    [textView fmReplaceCharactersInRange:r withAttributedString:blankString];
    
    // put our para at the end.
    [textView fmReplaceCharactersInRange:NSMakeRange([[textView textStorage] length], 0)
                    withAttributedString:para];
}


- (void) doMakeDefaultFont:(id<VPPluginWindowController>)windowController; {
    
    // FIXME - how do I undo a font change?
    
    NSFont *f = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:  @"defaultFont"]];
    
    if (!f) {
        f = [NSFont systemFontOfSize:12];
    }
    
    if (!f) {
        f = [NSFont fontWithName:@"Helvetica" size:12];
    }
    
    if (!f) {
        NSLog(@"Can't find a good font for Make Default Font.  Bailing.");
        return; // sheesh.
    }
    
    // woot, we've got a text view.
    NSTextStorage *ts = [[windowController textView] textStorage];
    
    [ts addAttribute:NSFontAttributeName value:f range:NSMakeRange(0, [ts length])];
    
}


- (void) doMailPage:(id<VPPluginWindowController>)windowController; {
    
    NSWindow *window = [windowController window];
    NSTextView *tv = [windowController textView];
    
//		NSData *rtfdata  = [tv RTFDFromRange:	NSMakeRange(0,[[tv string] length])];
    NSString *s = [NSString stringWithFormat:@"%@\n%@", [window title], [tv string]];
    
//		NSLog(@"s is %@", s);
    
    NSPasteboard *mypb = [NSPasteboard pasteboardWithUniqueName];
    
//		[mypb declareTypes:[NSArray arrayWithObject:NSRTFDPboardType] owner:self];
    
    [mypb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    
//		[mypb setData:rtfdata forType:NSRTFDPboardType];
    
    [mypb setString:s forType:NSStringPboardType];
    
    BOOL success = NSPerformService(@"Mail/Send Selection", mypb);
    
    if(success){
        [windowController setStatus:NSLocalizedString(@"Mail message prepared successfully.",@"")];
    }else{
        [windowController setStatus:NSLocalizedString(@"Problem sending Mail message.",@"")];			
    }

}


- (IBAction) doMeetingNotes:(id<VPPluginWindowController>)windowController; {
    
    // note- this date pref is totaly unsupported right now, and may change in the future...
    NSString *dateFormat = [[NSUserDefaults standardUserDefaults] stringForKey: @"dateFormat"];
    
    NSCalendarDate *now = [NSCalendarDate calendarDate];
    
    NSString *dateLine = [NSString stringWithFormat:@"MeetingOn%@", [now descriptionWithCalendarFormat:dateFormat]];
    
    id <VPPluginDocument> document = [windowController document];
    
    [document synchronizeDocs];
    
    id <VPData> vpd = [document vpDataForKey:[@"MeetingNotes" vpkey]];
    
    if (!vpd) {
        // we don't have a meeting notes page... well, let's fix that.
        vpd = [document createNewVPDataWithKey:[@"MeetingNotes" vpkey]];
    }
    
    debug(@"vpd: %@", vpd);
    
    NSMutableAttributedString *as = [vpd dataAsAttributedString];
    
    // what about undo?  eeeek
    [[as mutableString] insertString:[NSString stringWithFormat:@"%@\n", dateLine] atIndex:0];
    
    [vpd setDataAsAttributedString:as];
    
    // this method returns the vpdata, but we dont' really need it, we just want the window to open up..
    [document createNewVPDataWithKey:[dateLine vpkey]];
    
    [document openPageWithTitle:dateLine];
}



@end
