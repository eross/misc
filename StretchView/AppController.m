#import "AppController.h"

@implementation AppController
- (void)awakeFromNib
{
	[slider setFloatValue:0.5];
	[stretchView setOpacity:0.5];
}

- (IBAction)fade:(id)sender
{
	[stretchView setOpacity:[sender floatValue]];
}

- (IBAction)open:(id)sender
{
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	// Run the open panel
	[panel beginSheetForDirectory:nil
							 file:nil
							types:[NSImage imageFileTypes]
				   modalForWindow:[stretchView window]
					modalDelegate:self
				   didEndSelector:
		@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:NULL];
}

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
			 returnCode:(int)returnCode
			contextInfo:(void *)x
{
	NSString *path;
	NSImage *image;
	
	//did hey choose open
	if (returnCode == NSOKButton)
	{
		path = [openPanel filename];
		image = [[NSImage alloc] initWithContentsOfFile:path];
		[stretchView setImage:image];
		[image release];
	}
}
@end
