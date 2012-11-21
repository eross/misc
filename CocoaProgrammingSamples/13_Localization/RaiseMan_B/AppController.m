#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize {
	
	 // Create a dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

	// Archive the color object
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
	
	// Put defaults in the dictionary
	[defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
	[defaultValues setObject:[NSNumber numberWithBool:YES]
					  forKey:BNREmptyDocKey];
	
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	NSLog(@"registered defaults: %@", defaultValues);
}

- (IBAction)showPreferencePanel:(id)sender
{
	// Is preferenceController nil?
	if (!preferenceController) {
		preferenceController = [[PreferenceController alloc] init];
	}
	[preferenceController showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	NSLog(@"applicationShouldOpenUntitledFile:");
	return [[NSUserDefaults standardUserDefaults] boolForKey:BNREmptyDocKey];
}

- (void)dealloc
{
	[preferenceController release];
	[super dealloc];
}

@end
