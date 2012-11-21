/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/
#import "VPExporter.h"


@implementation VPExporter


- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
    returnCode:(int)returnCode
    contextInfo:(void *)contextInfo
{
    if (returnCode == NSOKButton) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        
        [d setObject:[[openPanel filenames] objectAtIndex:0] forKey:@"path"];
        [d setObject:(id)contextInfo forKey:@"document"];
        
        [self doExportWithInfo:d];
    }
}



- (void) selectDirectoryToExportViaAppleScript:(id<VPPluginWindowController>)windowController 
                                withProperties:(NSDictionary*)asProperties; {
    
    id<VPPluginDocument> document = [windowController document];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setObject:document forKey:@"document"];
    id junk = nil;
    
    if (junk = [asProperties objectForKey:@"filepath"]) {
        [d setObject:junk forKey:@"path"];
    }
    else {
        // FIXME - is there anyway we can pass back a message to the applescript
        // that called this?
        NSLog(@"Hey- there was no path given for the export!");
        return;
    }
    
    [d addEntriesFromDictionary:asProperties];
    
    [self doExportWithInfo:d];
}



- (void) selectDirectoryToExport:(id<VPPluginWindowController>)windowController {
    
    NSOpenPanel *exportPanel = [NSOpenPanel openPanel];
    
    id<VPPluginDocument> document = [windowController document];
    
    // this wasn't public in 10.2.. should really do a check to see if the selector is there yet
    if ([exportPanel respondsToSelector:@selector(_setIncludeNewFolderButton:)])
        [exportPanel performSelector:@selector(_setIncludeNewFolderButton:) withObject:(id)YES];
    
    // 10.3 and up.
    else if ([exportPanel respondsToSelector:@selector(setCanCreateDirectories:)])
        [exportPanel performSelector:@selector(setCanCreateDirectories:) withObject:(id)YES];
    
    [exportPanel setPrompt:NSLocalizedString(@"Export", @"Export")];
    [exportPanel setTitle:NSLocalizedString(@"Export to folder", @"Export to folder")];
    [exportPanel setCanChooseFiles:NO];
    [exportPanel setCanChooseDirectories:YES];
    [exportPanel setAllowsMultipleSelection:NO];
    [exportPanel beginSheetForDirectory:nil file:nil
        types:[NSArray arrayWithObjects:nil]
        modalForWindow:[NSApp mainWindow]
        modalDelegate:self
        didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
        contextInfo:document];
}

- (SEL) menuSelector {
    return @selector(selectDirectoryToExport:);
}

- (void) doExportWithInfo:(NSDictionary*)d {
    
    // make sure to release this in the exportToPathViaThread
    [d retain];
    
    [NSThread detachNewThreadSelector:@selector(exportToPathViaThread:) toTarget:self withObject:d];
}

- (void) cancel:(id)sender; {
    [self setShouldCancel:YES];
}

- (BOOL)shouldCancel {
    return shouldCancel;
}

- (void)setShouldCancel:(BOOL)flag {
    shouldCancel = flag;
}


@end
