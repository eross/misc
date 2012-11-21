#import "AppController.h"
#import "DirEntry.h"


@implementation AppController
- (id) init 
{
	[super init];
	NSMutableArray *top;
	top = [DirEntry entriesAtPath:@"/"withParent:nil];
	[self setTopLevelDirectories:top];
	return self;
}

- (void)setTopLevelDirectories:(NSMutableArray *)top
{
	[top retain];
	[topLevelDirectories release];
	topLevelDirectories = top;
}


- (IBAction)deleteSelection:(id)sender
{
	NSLog(@"-[Appcontroler deleteSelection:] to be implemented");
}

@end
