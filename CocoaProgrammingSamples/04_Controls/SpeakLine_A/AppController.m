#import "AppController.h"

@implementation AppController

- (id)init
{
    [super init];
    
    // Logs can help the beginner understand what 
	// is happening and hunt down bugs.
    NSLog(@"init");
    
    // Create a new instance of NSSpeechSynthesizer 
	// with the default voice.
    speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    return self;
}

- (IBAction)sayIt:(id)sender
{
    NSString *string = [textField stringValue];
	
	// Is the string zero-length?
	if ([string length] == 0) {
		return;
	}
    [speechSynth startSpeakingString:string];
    NSLog(@"Have started to say: %@", string);
}

- (IBAction)stopIt:(id)sender
{
    NSLog(@"Stopping");
    [speechSynth stopSpeaking];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [speechSynth release];
    [super dealloc];
}

@end
