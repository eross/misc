#import "AppController.h"
#import "BigLetterView.h"

@implementation AppController

- (id)init
{
    if (self = [super init]) {
        ticks = 10;
        letters = [[NSArray alloc] initWithObjects:@"a", @"s", @"d", @"f", @"j", @"k", @"l", @";", nil];
        
        lastIndex = 0;
        
        // Seed the random number generator
        srandom(time(NULL));
    }
    return self;
}

- (void)awakeFromNib
{
    [self showAnotherLetter];
}

- (void)showAnotherLetter
{
    int x;
    // Choose random numbers until you get a different number than last time
    x = lastIndex;
    while (x == lastIndex) {
        x = random() % [letters count];
    }
    lastIndex =x;
    [outLetterView setString:[letters objectAtIndex:x]];
    
    [progressView setDoubleValue:0.0];
    count = 0;
}

- (IBAction)stopGo:(id)sender
{
    if ([sender state] == NSOnState) {
        NSLog(@"Starting");
        
        // Create a timer
        timer = [[NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(checkThem:)
                                                userInfo:nil
                                                 repeats:YES] retain];
    } else {
        NSLog(@"Stopping");
        
        // Invalid and release the timer
        [timer invalidate];
        [timer release];
    }
}

- (void)checkThem:(NSTimer *)aTimer
{
    if ([[inLetterView string] isEqual:[outLetterView string]]) {
        [self showAnotherLetter];
    }
    count++;
    if (count > ticks) {
        NSBeep();
        count = 0;
    }
    [progressView setDoubleValue:(100.0 * count) / ticks];
}

- (IBAction)raiseSpeedWindow:(id)sender
{
    [speedSlider setIntValue:ticks];
    [NSApp beginSheet:speedWindow
       modalForWindow:[inLetterView window]
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:NULL];
}

- (IBAction)endSpeedWindow:(id)sender
{
    // Hide the sheet
    [speedWindow orderOut:sender];
    
    // Return to normal event handling
    [NSApp endSheet:speedWindow returnCode:1];
}

- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(int)returnCode
        contextInfo:(void *)contextInfo
{
    // Read the slider's value
    ticks = [speedSlider intValue];
    
    // Reset the count
    count = 0;
    
    NSLog(@"sheetDidEnd: Return code = %d", returnCode);
}

@end
