/* AppController */

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppController : NSObject
{
    IBOutlet BigLetterView *inLetterView;
    IBOutlet BigLetterView *outLetterView;
    IBOutlet NSProgressIndicator *progressView;
    int count;		   // How many times has the timer gone off?
    NSTimer *timer;    
    NSArray *letters;  // The array of letters that the user will type
    int lastIndex;     // The index in the array of the
	                   // letter the user is trying to type
}
- (void)showAnotherLetter;
- (IBAction)stopGo:(id)sender;
@end
