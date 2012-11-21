/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import "VPABLinkables.h"


@implementation VPABLinkables

- (void) didRegister; {
    
    // horray for Mikc McCracken for this bit of code:
    
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    ABAddressBook *book = [ABAddressBook sharedAddressBook];
    
    NSArray *people = [book people];
    NSEnumerator *enumerator = [people objectEnumerator];
    ABPerson *person = nil;
    
    while(person = [enumerator nextObject]){
        
        NSString *firstName = [person valueForProperty:kABFirstNameProperty];
        NSString *lastName = [person valueForProperty:kABLastNameProperty];
        NSString *nameString = [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName : @"")];
        nameString = [nameString trim];
        
        [[self pluginManager] addLinkable:[nameString vpkey] withURL:[NSString stringWithFormat:@"addressbook://%@", [person uniqueId]]];
        
    }
    
    [pluginManager reindexLinkables];
    [pluginManager registerURLHandler:self];
    
    
    
}

- (BOOL) canHandleURL:(NSString*)theUrl; {
    return [theUrl hasPrefix:@"addressbook://"];
}

- (BOOL) handleURL:(NSString*)theURL; {
    
    if (!choiceWindow) {
        [NSBundle loadNibNamed:@"ABChoiceWindow" owner:self];
        debug(@"new choiceWindow: %@", choiceWindow);
    }
    
    [self setUrl:theURL];
    
    
    NSString *address = [self getEmailAddressForURL:[self url]];
    NSSize titleSize;
    
    if (address) {
        
        NSString *title = [NSString stringWithFormat:@"email %@", address];
        
        NSFont *font = [NSFont fontWithName:@"Lucida Grande" size:13];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        titleSize = [title sizeWithAttributes:attributes];
        
        [emailButton setTitle:title];
        
        #warning get rid of the selector check when we drop 10.2
        if ([emailButton respondsToSelector:@selector(setHidden:)]) {
            [emailButton setHidden:NO];
        }
        else {
            [emailButton setEnabled:YES];
        }
    }
    else {
        #warning get rid of the selector check when we drop 10.2
        if ([emailButton respondsToSelector:@selector(setHidden:)]) {
            [emailButton setHidden:YES];
        }
        else {
            [emailButton setEnabled:NO];
        }
        
    }
    
    
    // make sure the window is big enough to hold this guy.
    if (address && titleSize.width > [openAddressButton bounds].size.width) {
        NSRect windowFrame = [choiceWindow frame];
        windowFrame.size.width = titleSize.width + 20;
        [choiceWindow setFrame:windowFrame display:YES];
    }
    
    
    NSPoint windowPosition = [NSEvent mouseLocation];
    
    NSRect windowFrame = [choiceWindow frame];
    
    windowPosition.x -= windowFrame.size.width / 2;
    windowPosition.y += 10; //windowFrame.size.height / 2;
    
    if (!address) {
        // move it up a little bit if there's no address.
        windowPosition.y += [emailButton frame].size.height;
    }
    
    /*
    NSScreen *screen = [NSScreen mainScreen];
    
    
    NSRect screenRect = [screen frame];


    if (windowPosition.y > screenRect.size.height) {
        windowPosition.y = screenRect.size.height;
    }
    */
    
    [choiceWindow setFrameTopLeftPoint:windowPosition];
    
    [choiceWindow makeKeyAndOrderFront:self];
    
    return YES;
}


- (void)dealloc {
    [url autorelease];
    
    url = nil;
    
    [super dealloc];
}



- (NSString *)url {
    return url; 
}

- (void)setUrl:(NSString *)newUrl {
    [newUrl retain];
    [url release];
    url = newUrl;
}

-  (void) close {
    // the window is set to release on close.
    [choiceWindow close];
    
    choiceWindow = nil;
}

- (IBAction) sendEmail:(id)sender {
    
    NSString *address = [self getEmailAddressForURL:[self url]];
    
    if (address) {
        
        NSString *mailURL = [NSString stringWithFormat:@"mailto:%@", address];
        
        if (![[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mailURL]]) {
            NSLog(@"Could not send email to %@", address);
            NSBeep();
        }
    }
    
    [self close];
}

- (NSString*) getEmailAddressForURL:(NSString *)abURL {
    
    ABAddressBook *book = [ABAddressBook sharedAddressBook];
    NSString *uniqueId = [abURL substringFromIndex:14];
    
    ABRecord *record = [book recordForUniqueId:uniqueId];
    if (record) {
        
        ABPerson *person = (ABPerson*)record;   
        ABMultiValue *values = [person valueForProperty:kABEmailProperty];
        
        if (values) {
            
            if ([values count] > 0) {
                // just grab the first one I guess..
                NSString *address = [values valueAtIndex:0];
                
                return address;
            }
        }
    }
    
    return nil;
}


- (NSString*) getIMAddressForURL:(NSString *)abURL {
    
    ABAddressBook *book = [ABAddressBook sharedAddressBook];
    NSString *uniqueId = [abURL substringFromIndex:14];
    
    ABRecord *record = [book recordForUniqueId:uniqueId];
    if (record) {
        
        ABPerson *person = (ABPerson*)record;   
        ABMultiValue *values = [person valueForProperty:kABAIMInstantProperty];
        
        if (values) {
            
            if ([values count] > 0) {
                // just grab the first one I guess..
                NSString *address = [values valueAtIndex:0];
                
                return address;
            }
        }
    }
    
    return nil;
}

- (IBAction) sendInstantMessage:(id)sender {
    [self close];
}

- (IBAction) openInAddressBook:(id)sender {
    if (![[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[self url]]])
        NSBeep();
    
    [self close];
}

- (IBAction) cancel:(id)sender {
    [self close];
}

@end
