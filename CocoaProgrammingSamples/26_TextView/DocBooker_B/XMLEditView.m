#import "XMLEditView.h"

@implementation XMLEditView

- (void)awakeFromNib
{
	int i;
	NSString *path;
	NSArray *tagArray;
	
	// Read and sort the plist
	path = [[NSBundle mainBundle] pathForResource:@"Tags"
										   ofType:@"plist"];
	tagArray = [NSArray arrayWithContentsOfFile:path];
	tagArray = [tagArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSLog(@"tags = %@", tagArray);
	
	// Create the menu
	wrappingMenu = [[NSMenu alloc] initWithTitle:@"Wrap in"];
	for (i = 0; i < [tagArray count]; i++) {
		NSMenuItem *item;
		NSString *title = [tagArray objectAtIndex:i];
		item = [[NSMenuItem alloc] initWithTitle:title
										  action:@selector(wrap:)
								   keyEquivalent:@""];
		[wrappingMenu addItem:item];
		// item is retained by menu
		[item release];
	}
}

- (NSMenu *)menuForEvent:(NSEvent *)e
{
	NSRange selection = [self selectedRange];
	if (selection.length > 0) {
		return wrappingMenu;
	} else {
		return [self menu];
	}
}

- (IBAction)wrap:(id)sender
{
	NSString *title = [sender title];
	NSLog(@"The user chose %@", title);
}

- (void)dealloc
{
	[wrappingMenu release];
	[super dealloc];
}

@end
