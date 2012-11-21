#import "PreferenceController.h"

NSString *BNRTableBgColorKey = @"TableBackgroundColor";
NSString *BNREmptyDocKey = @"EmptyDocumentFlag";


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
	NSColor *color = [sender color];
	NSData *colorAsData;
	colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
	NSUserDefaults *defaults;
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:colorAsData forKey:BNRTableBgColorKey];
	
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	NSLog(@"Sending notification BNRColorChanged");
	[nc postNotificationName:@"BNRColorChanged" object:self];
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:BNREmptyDocKey];
}

- (BOOL)emptyDoc
{
	NSUserDefaults *defaults;
	
	defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:BNREmptyDocKey];
}

- (NSColor *)tableBgColor
{
	NSUserDefaults *defaults;
	NSData *colorAsData;
	
	defaults = [NSUserDefaults standardUserDefaults];
	colorAsData = [defaults objectForKey:BNRTableBgColorKey];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}
	
- (IBAction)resetDefaults:(id)sender
{
	NSLog(@"resetDefaults");
	NSUserDefaults *defaults;
	
	defaults = [NSUserDefaults standardUserDefaults];
	
	//Archive the color object
	
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject: [NSColor yellowColor]];
	
	
	//Put default in the dictionary
	[defaults setObject:colorAsData forKey:BNRTableBgColorKey];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:BNREmptyDocKey];
	
}


@end
