/* BigLetterView */

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView
{
    NSColor *bgColor;
    NSString *string;
    NSMutableDictionary *attributes;
}
- (void)prepareAttributes;
- (void)drawStringCenteredIn:(NSRect)bounds;
- (void)setBgColor:(NSColor *)c;
- (NSColor *)bgColor;
- (void)setString:(NSString *)s;
- (NSString *)string;
- (IBAction)savePDF:(id)sender;
- (void)didEnd:(NSSavePanel *)sheet 
	returnCode:(int)code 
   contextInfo:(void *)contextInfo;
@end
