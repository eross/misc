#import "converter.h"
#import "IconFamily.h"

@implementation converter

BOOL outType = 0;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
NSLog(@"Img2icns ready!");
}


- (IBAction)setDir:(id)sender
{
    outType = 1;
    NSLog(@"Setting output type -> directory with icon");
}

- (IBAction)setIcns:(id)sender
{
    outType = 0;
    NSLog(@"Setting output type -> .icns");
}

- (void)awakeFromNib{
    //NSLog(@"Ready 2");
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [prefWin makeKeyAndOrderFront:self];
    NSLog(@"Click!");
    return 1;
}



- (void)application:(NSApplication *)sender openFiles:(NSArray *)filePaths
{

unsigned numImg = [filePaths count];

int i = 0;
for (i; i < numImg; ++i) {
	//NSLog([filePaths objectAtIndex:i]);
	
	NSString* path = [filePaths objectAtIndex:i];
	unsigned int length = [path length];
	NSString* pathFin = @"NULL";
    NSString* pathDir = @"NULL";
	
	// Creating new path target
	if([[path lowercaseString] hasSuffix:@".jpg"] 
	|| [[path lowercaseString] hasSuffix:@".gif"] 
	|| [[path lowercaseString] hasSuffix:@".png"]){
	pathFin = [[path substringToIndex:length-4] stringByAppendingPathExtension:@"icns"];
    pathDir = [path substringToIndex:length-4];
	}
	if([[path lowercaseString] hasSuffix:@".jpeg"] 
	|| [[path lowercaseString] hasSuffix:@".tif"]){
	pathFin = [[path substringToIndex:length-5] stringByAppendingPathExtension:@"icns"];
    pathDir = [path substringToIndex:length-5];
	}
	
	// If the image is not a supported image tipe, show an error
	if([pathFin isEqualToString:@"NULL"]){
	NSAlert *alert = [[NSAlert alloc] init];	
	[alert addButtonWithTitle:@"OK"];
	NSString* msg = [@"This is not an Image: " stringByAppendingString:path];	
	[alert setMessageText:msg];	
	[alert setInformativeText:@"Error"];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert runModal];
	[alert release];
	continue;
	}

// Creating the icns	
NSImage* image = [[NSImage alloc] initWithContentsOfFile:path];
IconFamily* icon;
icon = [IconFamily iconFamilyWithThumbnailsOfImage:image];
if(outType == 0){
    [icon writeToFile:pathFin];
}
else{
    [[NSFileManager defaultManager] createDirectoryAtPath:pathDir attributes:nil];
    [icon setAsCustomIconForDirectory:pathDir];
}

}



}

@end
