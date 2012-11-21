/*
 Copyright (c) 2004, Flying Meat Inc.
 All rights reserved. 
 */

#import "VPWordExport.h"
#import <VPPlugin/VPPlugin.h>

@implementation VPWordExport


- (void) didRegister {
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    // the word export is only good for 10.3 and up.
    if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) {
        
        [pluginManager addPluginsMenuTitle:@"Export as Word Documents..."
                        withSuperMenuTitle:@"Export"
                                    target:self
                                    action:@selector(selectDirectoryToExport:)
                             keyEquivalent:@""
                 keyEquivalentModifierMask:0];
    }
}

- (void) exportToPathViaThread:(NSDictionary*)d; {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSString *path = [d objectForKey:@"path"];
    id<VPPluginDocument> document = [d objectForKey:@"document"];
    
    [VPTasks addActivity:self];
    
    [VPTasks setStatus:@"exporting..." forActivity:self];
    
    [document synchronizeDocs];
    
    int count = [document numberOfVPDatas];
    int idx = 0;
    NSArray *keys = [document keys];
    NSEnumerator *enumerator = [keys objectEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject])  && (![self shouldCancel])) {
        NSAutoreleasePool * pool2 = [[NSAutoreleasePool alloc] init];
        
        id <VPData> vpd = [document vpDataForKey:key];
    	idx ++;
        debug(@"%@", vpd);
        
        if (!vpd) {
            NSLog(@"Word export could not find vpd: %@", key);
            continue;
        }
        
        // don't export the url's
        if ([vpd isURL])
            continue;
        
        // can't export encrypted stuff either.
        if ([vpd isEncrypted])
            continue;
        
        NSMutableAttributedString *content = nil;
        
        content = [vpd dataAsAttributedString];
        
        if (!content) {
            content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Cound not unarchive %@", [vpd title]]];
            [content autorelease];
        }
        
        
        [VPTasks setStatus:[NSString stringWithFormat:@"Exporting %d of %d as Word.", idx, count] forActivity:self];
        
        NSString *docPath = [NSString stringWithFormat:@"%@/%@.doc", path, [[vpd title] fmFilenameFriendlyString]];
        
        NSData *d = [content docFormatFromRange:NSMakeRange(0, [content length]) documentAttributes:nil];
        if (![d writeToFile:docPath atomically:YES]) {
            
            NSRunAlertPanel(@"Could not save file.",
                            [NSString stringWithFormat:@"Sorry, but I could not save to the file %@", docPath],
                            @"OK", nil, nil);
            
        }
        
        [pool2 release];
    }
    
    [VPTasks removeActivity:self];
    
    [pool release];
    [d release];
}




@end