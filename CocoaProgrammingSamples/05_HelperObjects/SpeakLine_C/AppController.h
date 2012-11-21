/* AppController */

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject
{
    IBOutlet NSTextField *textField;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *stopButton;
    IBOutlet NSTableView *tableView;
    NSSpeechSynthesizer *speechSynth;
}

// Action methods
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
- (IBAction)changeTextColor:(id)sender;

// Speech synthesizer delegate methods
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender 
        didFinishSpeaking:(BOOL)finishedSpeaking;

// Table view data source methods
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
    row:(int)rowIndex;

@end
