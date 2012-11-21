/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import "VPTextExport.h"

@implementation VPTextExport

- (void) didRegister {
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    [pluginManager registerPluginAppleScriptName:@"Export as Plain Text..."
                                          target:self
                                          action:@selector(selectDirectoryToExport:)];
    
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
        
        // don't export the url's
        if ([vpd isURL])
            continue;
        
        // can't export encrypted stuff either.
        if ([vpd isEncrypted])
            continue;
        
        [VPTasks setStatus:[NSString stringWithFormat:@"Exporting %d of %d as text.", idx, count] forActivity:self];
        
        NSString *page = [[vpd dataAsAttributedString] string];
        
        NSString *pagePath = [NSString stringWithFormat:@"%@/%@.txt", path, [[vpd title] fmFilenameFriendlyString]];
        
        if (![[page dataUsingEncoding:NSUTF8StringEncoding] writeToFile:pagePath atomically:YES]) {
            NSLog(@"Could not write... %@", pagePath);
        }
    
        [pool2 release];
    }
    
    
    [VPTasks removeActivity:self];
    
    [pool release];
    [d release];
}





@end