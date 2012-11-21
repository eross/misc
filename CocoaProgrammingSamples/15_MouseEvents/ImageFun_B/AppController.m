#import "AppController.h"
#import "StretchView.h"

@implementation AppController

- (void)awakeFromNib
{
    // Make sure the slider and the stretch view 
	// agree on the initial opacity
    [slider setFloatValue:0.5];
    [stretchView setOpacity:0.5];
}

- (IBAction)fade:(id)sender
{
    // The sender is the slider
    [stretchView setOpacity:[sender floatValue]];
}

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
             returnCode:(int)returnCode
            contextInfo:(void *)x
{
    NSString *path;
    NSImage *image;
    
    // Did they choose "Open"?
    if (returnCode == NSOKButton) {
		path = [openPanel filename];
        image = [[NSImage alloc] initWithContentsOfFile:path];
        [stretchView setImage:image];
        [image release];
    }
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
                   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
                      contextInfo:NULL];
}

@end
