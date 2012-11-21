#import "AppController.h"
#import "BigLetterView.h"

// Number of times the timer will fire
#define TICKS 10

@implementation AppController

- (id)init
{
    if (self = [super init]) {
		
		// Create an array of letters
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
    // Choose random numbers until you get a different 
	// number than last time
    x = lastIndex;
    while (x == lastIndex) {
        x = random() % [letters count];
    }
    lastIndex = x;
    [outLetterView setString:[letters objectAtIndex:x]];
    
    [progressView setDoubleValue:0.0];
    count = 0;
}

- (IBAction)stopGo:(id)sender
{
    if ([sender state] == 1) {
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
    if (count > TICKS) {
        NSBeep();
        count = 0;
    }
    [progressView setDoubleValue:(100.0 * count) / TICKS];
}

@end
