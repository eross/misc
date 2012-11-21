#import <Cocoa/Cocoa.h>

extern NSString *BNRTableBgColorKey;
extern NSString *BNREmptyDocKey;

@interface PreferenceController : NSWindowController {
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSButton *checkbox;
}
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;
- (NSColor *)tableBgColor;
- (BOOL)emptyDoc;
@end
