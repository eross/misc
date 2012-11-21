/* AppController */

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject
{
    IBOutlet NSTextField *textField;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *stopButton;
    NSSpeechSynthesizer *speechSynth;
}
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
- (IBAction)changeTextColor:(id)sender;

// Speech Synthesizer delegate methods
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender 
        didFinishSpeaking:(BOOL)finishedSpeaking;
@end
