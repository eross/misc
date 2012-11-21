#import "AppController.h"

@implementation AppController

- (id)init
{
    [super init];
    
    // Logs can help the beginner understand what is happening and
    // hunt down bugs
    NSLog(@"init");
    
    // Create a new instance of NSSpeechSynthesizer with the default voice
    speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    [speechSynth setDelegate:self];
    return self;
}

// Make sure that the text field and the color well start off on the
// same color
- (void)awakeFromNib
{
    NSColor *initialColor = [textField textColor];
    NSLog(@"Setting initial color for the color well");
    [colorWell setColor:initialColor];
}

- (IBAction)sayIt:(id)sender
{
    NSString *string = [textField stringValue];
    [speechSynth startSpeakingString:string];
    NSLog(@"Have started to say: %@", string);
    [stopButton setEnabled:YES];
}

- (IBAction)stopIt:(id)sender
{
    NSLog(@"Stopping");
    [speechSynth stopSpeaking];
}

- (IBAction)changeTextColor:(id)sender
{
    NSColor *newColor = [sender color];
    NSLog(@"Changing the color");
    [textField setTextColor:newColor];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender 
        didFinishSpeaking:(BOOL)finishedSpeaking
{
    NSLog(@"didFinish = %d", finishedSpeaking);
    [stopButton setEnabled:NO];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[NSSpeechSynthesizer availableVoices] count];
}

- (id)tableView:(NSTableView *)tableView
    objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(int)row
{
    NSString *voice = [[NSSpeechSynthesizer availableVoices] objectAtIndex:row];
    return [[NSSpeechSynthesizer attributesForVoice:voice] valueForKey:NSVoiceName];
}


- (void)dealloc
{
    NSLog(@"dealloc");
    [speechSynth release];
    [super dealloc];
}

@end
