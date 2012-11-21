/* BigLetterView */

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView
{
	NSColor *bgColor;
	NSString *string;
	NSMutableDictionary *attributes;
}
- (void)prepareAttributes;
- (void)drawStringCenteredIn:(NSRect)r;
- (void)setBgColor:(NSColor *)c;
- (NSColor *)bgColor;
- (void)setString:(NSString *)c;
- (NSString *)string;
- (IBAction)savePDF:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (void)writeStringToPasteboard:(NSPasteboard *)pb;
- (BOOL)readStringFromPasteBoard:(NSPasteboard *)pb;

- (void)didEnd:(NSSavePanel *)sheet
	returnCode:(int)code
	contextInfo:(void *)contextInfo;
	

@end
