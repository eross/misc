/* AppController */

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppController : NSObject
{
	IBOutlet NSWindow *speedWindow;
    IBOutlet NSSlider *speedSlider;
    int count;
    int ticks;
    IBOutlet BigLetterView *inLetterView;
    IBOutlet BigLetterView *outLetterView;
    IBOutlet NSProgressIndicator *progressView;
    NSTimer *timer;
    NSArray *letters;
    int lastIndex;
	IBOutlet NSColorWell *colorWell;
    IBOutlet NSTextField *textField;
}
- (void)showAnotherLetter;
- (IBAction)stopGo:(id)sender;  // Triggered by text field
- (IBAction)takeColorFromTextField:(id)sender;  // Triggered by colorwell
- (IBAction)takeColorFromColorWell:(id)sender;
- (IBAction)raiseSpeedWindow:(id)sender;
- (IBAction)endSpeedWindow:(id)sender;
- (IBAction)print:(id)sender;
- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(int)returnCode
        contextInfo:(void *)contextInfo;
@end
