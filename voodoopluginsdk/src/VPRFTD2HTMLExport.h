/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

#import <Foundation/Foundation.h>
#import <VPPlugin/VPPlugin.h>

@interface VPRFTD2HTMLExport : NSObject {
    id<VPPluginDocument> document;
    
    NSString *fileExtension;
    
}

+ (NSAttributedString*) rtfdFromFile:(NSString *)rtfPath;

+ (id) VPRFTD2HTMLExportWithDocument:(id<VPPluginDocument>)aDocument;

- (void) exportAttributedString:(NSAttributedString*) str
                         toPath:(NSString*) path
                   imagesFolder:(NSString*) imagesFolder
                    imagePrefix:(NSString*) imagePrefix
                   HTMLTemplate:(NSMutableString*) theTemplate
                   shouldMarkup:(BOOL)shouldMarkup;

- (NSString *)fileExtension;
- (void)setFileExtension:(NSString *)newFileExtension;


@end
