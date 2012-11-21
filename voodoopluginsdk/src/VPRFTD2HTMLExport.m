/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/


#import "VPRFTD2HTMLExport.h"

@implementation VPRFTD2HTMLExport


+ (NSAttributedString*) rtfdFromFile:(NSString *)rtfPath {
    
    NSData *d = nil;
    NSAttributedString *s = nil;
    if ([rtfPath hasSuffix:@"rtfd"]) {
    
        NSFileWrapper *tempRTFDData = [[[NSFileWrapper alloc] initWithPath:rtfPath] autorelease];
        
        d = [tempRTFDData serializedRepresentation];
        
        s = [[NSAttributedString alloc] initWithRTFD:d documentAttributes:nil];
        

    }
    else {
        
        d = [NSData dataWithContentsOfFile:rtfPath];
        
        s = [[NSAttributedString alloc] initWithRTF:d documentAttributes:nil];
        
        //d = [s RTFDFromRange:NSMakeRange(0, [s length]) documentAttributes:nil];
    }
    
    return  [s autorelease];;
}

+ (id) VPRFTD2HTMLExportWithDocument:(id<VPPluginDocument>)aDocument {
    
    VPRFTD2HTMLExport *e = [[VPRFTD2HTMLExport alloc] init];
    
    e->document = aDocument;
    
    return [e autorelease];
}


- (id)init {
	self = [super init];
    if (self) {
        [self setFileExtension:@"html"];
    }
    
	return self;
}

- (void)dealloc {
    [fileExtension autorelease];
    
    fileExtension = nil;
    
    [super dealloc];
}

- (NSString*) stringForAlignment:(NSTextAlignment)alignment {
    
    if (alignment == NSLeftTextAlignment)
        return @"left";
    if (alignment == NSRightTextAlignment)
        return @"right";
    if (alignment == NSCenterTextAlignment)
        return @"center";
    if (alignment == NSJustifiedTextAlignment)
        return @"justify";
    
    
    return @"left";
}

- (void) exportAttributedString:(NSAttributedString*) str
                         toPath:(NSString*) path
                   imagesFolder:(NSString*) imagesFolder
                    imagePrefix:(NSString*) imagePrefix
                   HTMLTemplate:(NSMutableString*) theTemplate
                   shouldMarkup:(BOOL)shouldMarkup
{

    int length = [str length];
    
    NSMutableString *html = [NSMutableString string];
    
    debug(@"shouldMarkup2: %d", shouldMarkup);
    
    if (length > 0 && shouldMarkup) {
        
        NSTextAttachment  *attachment;
        NSRange r;
        NSDictionary *attributes = [str attributesAtIndex:0 effectiveRange:&r];
        NSFont *font;
        NSParagraphStyle *pStyle;
        NSTextAlignment currentAlignment = NSLeftTextAlignment;
        NSString *link;
        BOOL inBold = NO;
        BOOL inItalic = NO;
        int imgNumber = 1;
        BOOL started = NO;
        //BOOL inEscape = YES;
        
        while (r.location + r.length <= length) {
            
            
            if ((pStyle = [attributes objectForKey:@"NSParagraphStyle"])) {
                if ([pStyle alignment] != currentAlignment) {
                    
                    if (started) {
                        [html appendString:@"</div>"];
                    }
                    else {
                        started = YES;
                    }
                    [html appendString:[NSString stringWithFormat:@"<div align=\"%@\">", [self stringForAlignment:[pStyle alignment]]]];
                    
                    currentAlignment = [pStyle alignment];
                }
            }
            
            if ((attachment = [attributes objectForKey:@"NSAttachment"])) {
                NSFileWrapper *wrap = [attachment fileWrapper];
                
                NSString *pngFile  = [NSString stringWithFormat:@"%@/%@_img_%d.png",[path stringByDeletingLastPathComponent], imagePrefix, imgNumber];
                
                NSImage *img = [[NSImage alloc] initWithData:[wrap regularFileContents]];
                
                NSData *tiff = [img TIFFRepresentation];                
                
                NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:tiff];
                
                NSData *data = [bitmap representationUsingType:NSPNGFileType properties:nil];

                [data writeToFile:pngFile atomically:NO];
                
                [img release];
                
                [html appendString:[NSString stringWithFormat:@"<img src=\"%@_img_%d.png\" alt=\"\" />",imagePrefix, imgNumber]];
                
                imgNumber++;
                
            }
            else {
                if ((font = [attributes objectForKey:NSFontAttributeName])) {
    
                    [html appendString:[NSString stringWithFormat:@"<font style=\"font: %@; font-size: %dpt;\">", [font fontName], (int)[font pointSize]]];
                    
                    if ([[font fontName] rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        inBold = YES;
                        [html appendString:@"<b>"];
                    }
                    
                    
                    if ([[font fontName] rangeOfString:@"italic" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        inItalic = YES;
                        [html appendString:@"<i>"];
                    }
                }
                
                
                if (link = [attributes objectForKey:NSLinkAttributeName]) {
                    
                    if ([link hasPrefix:@"voodoo://"]) {
                        
                        NSString *key = [[link substringFromIndex:9] vpkey];
                        
                        // make sure it's got a data with it...
                        
                        id<VPData> vpd = [document vpDataForKey:key];
                        
                        if (!vpd) {
                            vpd = [document vpDataForAlias:key];
                        }
                        
                        if (vpd) {
                            if ([vpd isURL]) {
                                [html appendString:[NSString stringWithFormat:@"<a href=\"%@\">", [vpd url]]];
                            }
                            else {
                                link = [[vpd key] fmStringByAddingPercentEscapes];
                                //link = [link escapeForHTMLString];
                                [html appendString:[NSString stringWithFormat:@"<a href=\"%@.%@\">", link, fileExtension]];
                            }
                        }
                        else {
                            // the link was no good, so let's not close it.
                            link = nil; 
                        }
                    }
                    else if ([link hasPrefix:@"addressbook://"] ) {
                        // let's not worry about this- doesn't make much sense when we're viewing this on a website.
                        link = nil; 
                    }
                    else {
                        
                        // escape out the naughty chars.
                        link = [link escapeForHTMLString];
                        
                        //debug(@"link: %@", link);
                        
                        [html appendString:[NSString stringWithFormat:@"<a href=\"%@\">", link]];
                    }
                }                
                
                
                
                NSString *theStringToWrite = [[str attributedSubstringFromRange:r] string];
                
                // escape out the <'s and such.
                NSString *escaped = [theStringToWrite escapeForHTMLString];
                
                [html appendString:escaped];
                
                
                if (link) {
                    [html appendString:@"</a>"];
                    link = nil;
                }
                
                if (inBold) {
                    [html appendString:@"</b>"];
                    inBold = NO;
                }
                
                if (inItalic) {
                    [html appendString:@"</i>"];
                    inItalic = NO;
                }
                
                if (font) {
                    [html appendString:@"</font>"];
                }
                
            }
            
            if (r.location + r.length == length) {
                break;
            }
    
            attributes = [str attributesAtIndex:r.location+r.length effectiveRange:&r];
        }
        
        // normalize the line endings.
        [html replaceOccurrencesOfString:@"\r\n" withString:@"\n" options:0 range:NSMakeRange(0, [html length])];
        [html replaceOccurrencesOfString:@"\r" withString:@"\n"   options:0 range:NSMakeRange(0, [html length])];
        
        [html replaceOccurrencesOfString:@"\n" withString:@"<br />\n" options:0 range:NSMakeRange(0, [html length])];
        
        [html appendString:@"</div>"];
    }
    
    if (!shouldMarkup) {
        [html appendString:[str string]];
    }
    
    [theTemplate replaceOccurrencesOfString:@"$vppage$" withString:html options:0 range:NSMakeRange(0, [theTemplate length])];
    
    // keep the old style around for this release...
    [theTemplate replaceOccurrencesOfString:@"$vppage" withString:html options:0 range:NSMakeRange(0, [theTemplate length])];
    
    if (![[theTemplate dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES]) {
        NSLog(@"Could not write... %@", path);
    }
}

- (NSString *)fileExtension {
    return fileExtension; 
}

- (void)setFileExtension:(NSString *)newFileExtension {
    [newFileExtension retain];
    [fileExtension release];
    fileExtension = newFileExtension;
}


@end
