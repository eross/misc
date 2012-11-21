/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import "VPWordCountPlugin.h"

@implementation VPWordCountPlugin

- (void) didRegister {
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    [pluginManager addPluginsMenuTitle:@"Word Count"
                    withSuperMenuTitle:nil
                                target:self
                                action:@selector(doWordCount:)
                         keyEquivalent:@""
                         keyEquivalentModifierMask:0];
    
    
}



- (void) doWordCount:(id<VPPluginWindowController>)windowController; {
    
    // woot, we've got a text view.
    NSTextStorage *ts = [[windowController textView] textStorage];
    
    // thanks to Doug Leffert suggesting to use the spell checker
    NSSpellChecker *sc = [NSSpellChecker sharedSpellChecker];
    int wordCount      = [sc countWordsInString:[ts string] language:@""];
    
    NSString *msg = NSLocalizedString(@"There are %d words in this page",
                                      @"There are %d words in this page");
    
    msg = [NSString stringWithFormat:msg, wordCount];
    
    NSRunAlertPanel(@"Word Count", msg, nil, nil, nil);
}

- (void) doWordCountViaAppleScript:(id<VPPluginWindowController>)windowController 
                    withProperties:(NSDictionary*)d; {
    
    [self doWordCount:windowController];
    NSRunAlertPanel(@"From AppleScript!", @"", nil, nil, nil);
}

@end
