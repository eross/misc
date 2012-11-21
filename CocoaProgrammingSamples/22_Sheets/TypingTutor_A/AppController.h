/* AppController */

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppController : NSObject
{
	int count;         // How many times has the timer fired?
    int ticks;         // How high can "count" go?
    IBOutlet NSWindow *speedWindow;
    IBOutlet NSSlider *speedSlider;
    IBOutlet BigLetterView *inLetterView;
    IBOutlet BigLetterView *outLetterView;
    IBOutlet NSProgressIndicator *progressView;
	NSTimer *timer;
    NSArray *letters;  // The array of letters that the user will type
    int lastIndex;     // The index in the array of the
	                   // letter the user is trying to type
}
- (void)showAnotherLetter;
- (IBAction)stopGo:(id)sender;
- (IBAction)raiseSpeedWindow:(id)sender;
- (IBAction)endSpeedWindow:(id)sender;
- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(int)returnCode
        contextInfo:(void *)contextInfo;
@end
