#import "PreferenceController.h"

NSString *BNRTableBgColorKey = @"TableBackgroundColor";
NSString *BNREmptyDocKey = @"EmptyDocumentFlag";

@implementation PreferenceController

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	return self;
}

- (NSColor *)tableBgColor
{
	NSUserDefaults *defaults;
	NSData *colorAsData;
	
	defaults = [NSUserDefaults standardUserDefaults];
	colorAsData = [defaults objectForKey:BNRTableBgColorKey];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (BOOL)emptyDoc
{
	NSUserDefaults *defaults;
	
	defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:BNREmptyDocKey];
}

- (void)windowDidLoad
{
	[colorWell setColor:[self tableBgColor]];
	[checkbox setState:[self emptyDoc]];
}

- (IBAction)changeBackgroundColor:(id)sender
{
	NSColor *color = [sender color];
	NSData *colorAsData;
	colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
	NSUserDefaults *defaults;
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:colorAsData
				 forKey:BNRTableBgColorKey];
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender state]
											forKey:BNREmptyDocKey];
}

@end
