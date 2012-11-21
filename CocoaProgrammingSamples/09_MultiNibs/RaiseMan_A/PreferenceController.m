#import "PreferenceController.h"

@implementation PreferenceController

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	return self;
}

- (void)windowDidLoad
{
	NSLog(@"Nib file is loaded");
}

- (IBAction)changeBackgroundColor:(id)sender
{
	NSLog(@"Color changed: %@", [sender color]);
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
	NSLog(@"Checkbox changed %d", [sender state]);
}

@end
