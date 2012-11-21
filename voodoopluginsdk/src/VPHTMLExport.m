/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import "VPHTMLExport.h"
#import "VPRFTD2HTMLExport.h"


BOOL folderExistsAtPath(NSString* path) {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    return ([fm fileExistsAtPath:path isDirectory:&isDir] && isDir);
}

@implementation VPHTMLExport


- (void) didRegister {
    
    id <VPPluginManager> pluginManager = [self pluginManager];
    
    [pluginManager registerPluginAppleScriptName:@"Export as HTML..."
                                          target:self
                                          action:@selector(selectDirectoryToExport:)];
    
    /*
    Yes, we handle the exporting of html, but we don't need to have this item show up
    twice in the menus.
    [pluginManager addPluginsMenuTitle:@"Export as HTML..."
                    withSuperMenuTitle:@"Export"
                                target:self
                                action:@selector(selectDirectoryToExport:)
                         keyEquivalent:@""
             keyEquivalentModifierMask:0];
    */
    
}


- (void) exportToPathViaThread:(NSDictionary*)d {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSString *fileExtension = @"html";
    BOOL shouldMarkup = YES;
    NSString *path = [d objectForKey:@"path"];
    
    id<VPPluginDocument> document = [d objectForKey:@"document"];
    
    debug(@"exporting html to %@! ... ", path);
    
    [VPTasks addActivity:self];
    
    [VPTasks setStatus:@"exporting..." forActivity:self];
    
    [document synchronizeDocs];
    
    if (!folderExistsAtPath(path)) {
        NSRunAlertPanel(@"Sorry", [NSString stringWithFormat:@"The folder '%@' does not seem to exist.", path], @"OK", nil, nil);
        return;
    }
    
    // what file extension do they want for this guy?
    NSString *junk = [d objectForKey:@"fileextension"];
    if (junk) {
        if ([junk hasPrefix:@"."] && ([junk length] > 1)) {
            junk = [junk substringFromIndex:1];
        }
        
        if ([junk length] > 1) {
            fileExtension = junk;
        }
        else {
            NSLog(@"Invalid file extension: '%@'", junk);
        }
    }
    
    debug(@"%@", d);
    
    shouldMarkup = !([d objectForKey:@"shouldmarkup"] == (id)kCFBooleanFalse);
    
    
    int count = [document numberOfVPDatas];
    int idx = 0;
    NSArray *keys = [document keys];
    NSEnumerator *enumerator = [keys objectEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject])  && (![self shouldCancel])) {
        NSAutoreleasePool * pool2 = [[NSAutoreleasePool alloc] init];

        id <VPData> vpd = [document vpDataForKey:key];
    	idx ++;
        //debug(@"vpd: %@", vpd);
        
        if (!vpd) {
            NSLog(@"HTML export could not find vpd: %@", key);
            continue;
        }
        
        // don't export the url's
        if ([vpd isURL])
            continue;
            
        // can't export encrypted stuff either.
        if ([vpd isEncrypted])
            continue;
        
        
        [VPTasks setStatus:[NSString stringWithFormat:@"Exporting %d of %d as HTML.", idx, count] forActivity:self];
        
        NSMutableString *template = [NSMutableString stringWithContentsOfFile:
                                        [NSString stringWithFormat:@"%@/vphtmltemplate.html", [[NSBundle bundleForClass:[self class]] resourcePath]]
                                    ];
        id<VPData> vphtmltemplate;
        
        if (vphtmltemplate = [document vpDataForKey:@"vphtmltemplate"]) {
            
            // make sure the page isn't actually a url in disguise
            if (![vphtmltemplate isURL]) {
                template = [NSMutableString stringWithString:[[vphtmltemplate dataAsAttributedString] string]];
            }
        }
        
        if (!template)
            NSRunAlertPanel(@"Can't find the template.", @"", nil, nil, nil);
        
        NSCalendarDate *now = [NSCalendarDate calendarDate];
        
        NSString *dateFormat = [[NSUserDefaults standardUserDefaults] stringForKey: @"dateFormat"];
        
        [template replaceOccurrencesOfString:@"$vptitle$"  withString:[vpd title] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [template length])];
        
        // look for the old style as well.
        [template replaceOccurrencesOfString:@"$vptitle"  withString:[vpd title] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [template length])];
        
        [template replaceOccurrencesOfString:@"$vpdate$" withString:[now descriptionWithCalendarFormat:dateFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [template length])];
        
        NSCalendarDate *modifiedDate = [NSCalendarDate dateWithTimeIntervalSince1970:[[vpd modifiedDate] timeIntervalSince1970]];
        
        [template replaceOccurrencesOfString:@"$dateUpdated$" withString:[modifiedDate descriptionWithCalendarFormat:dateFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [template length])];
        
        
        
        // if the .vdoc is saved, add that info as well
        if ([document fileName]) {
            [template replaceOccurrencesOfString:@"$vpvdoc$" withString:[document fileName] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [template length])];
        }
        
        
        NSString *title = [vpd key];
        NSString *savePath = [NSString stringWithFormat:@"%@/%@.%@", path, [title fmStringByAddingPercentEscapes], fileExtension];
        
        
        //[fh setDatas:keysAndAliases];
        
        NSMutableAttributedString *str = [vpd dataAsAttributedString];
        
        [document markupAttributedString:str];
        
        VPRFTD2HTMLExport* fh = [VPRFTD2HTMLExport VPRFTD2HTMLExportWithDocument:document];
        [fh exportAttributedString:str
                            toPath:savePath
                    imagesFolder:[NSString stringWithFormat:@"%@/images/", path]
                    imagePrefix:[title fmStringByAddingPercentEscapes]
                    HTMLTemplate:template
                    shouldMarkup:shouldMarkup];
        
        [pool2 release];
    }
    
    
    [VPTasks removeActivity:self];
    
    [pool release];
    [d release];
}


@end
