/* AppController */

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppController : NSObject
{
    IBOutlet BigLetterView *inLetterView;
    IBOutlet BigLetterView *outLetterView;
    IBOutlet NSProgressIndicator *progressView;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSTextField *textField;
    int count;
    int ticks;
    IBOutlet NSWindow *speedWindow;
    IBOutlet NSSlider *speedSlider;
    NSTimer *timer;
    NSArray *letters;
    int lastIndex;
}
- (void)showAnotherLetter;
- (IBAction)stopGo:(id)sender;
- (IBAction)takeColorFromTextField:(id)sender;
- (IBAction)takeColorFromColorWell:(id)sender;
- (IBAction)raiseSpeedWindow:(id)sender;
- (IBAction)endSpeedWindow:(id)sender;
- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(int)returnCode
        contextInfo:(void *)contextInfo;
- (IBAction)print:(id)sender;
@end
