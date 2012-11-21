/* BigLetterView */

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView
{
    NSColor *bgColor;
    NSString *string;
    NSMutableDictionary *attributes;
    BOOL highlighted;
	BOOL copyable;
}
- (void)prepareAttributes;
- (void)drawStringCenteredIn:(NSRect)bounds;
- (void)setBgColor:(NSColor *)c;
- (NSColor *)bgColor;
- (void)setString:(NSString *)s;
- (NSString *)string;
- (IBAction)savePDF:(id)sender;
- (void)didEnd:(NSSavePanel *)sheet returnCode:(int)code contextInfo:(void *)contextInfo;
- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (void)writeStringToPasteboard:(NSPasteboard *)pb;
- (BOOL)readStringFromPasteboard:(NSPasteboard *)pb;
- (void)setCopyable:(BOOL)yn;
- (BOOL)copyable;
@end
