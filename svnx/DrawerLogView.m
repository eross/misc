
#import "DrawerLogView.h"

@class MySvn;

@implementation DrawerLogView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
	
		if ([NSBundle loadNibNamed:@"DrawerLogView" owner:self])
		{
		  [_view setFrame:[self bounds]];
		  [self addSubview:_view];
		}
    }
    return self;
}

- (void)dealloc {
    [self setDocument: nil];
//	NSLog(@"DrawerLogView dealloc");
    [super dealloc];
}

-(void)setUp
{
	[document addObserver:self forKeyPath:@"displayedTaskObj.newStdout" options:(NSKeyValueObservingOptionNew) context:nil];
	[document addObserver:self forKeyPath:@"displayedTaskObj.newStderr" options:(NSKeyValueObservingOptionNew) context:nil];
}

-(void)unload
{
	[document removeObserver:self forKeyPath:@"displayedTaskObj.newStdout"];
	[document removeObserver:self forKeyPath:@"displayedTaskObj.newStderr"];

	// the owner has to release its top level nib objects 
	[documentProxy release];
	[_view release];
	
	// objects that are bound to the file owner retain it
	// we need to unbind them 
	[documentProxy unbind:@"contentObject"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSDictionary *taskObj = [document valueForKey:@"displayedTaskObj"];

	if ( taskObj != nil )
	{

		if ( taskObj != currentTaskObj )
		{
			[[logTextView textStorage] setAttributedString:[taskObj valueForKey:@"combinedLog"]];
			currentTaskObj = taskObj;
		}

		if ( [keyPath isEqualToString:@"displayedTaskObj.newStdout"] )
		{
			[logTextView appendString:[taskObj objectForKey:@"newStdout"] isErrorStyle:NO];
		
		} else
		{
			[logTextView appendString:[taskObj objectForKey:@"newStderr"] isErrorStyle:YES];
		}
	
	} else [logTextView setString:@""];
	
}


#pragma mark -
#pragma mark stop displayed task

- (IBAction)stopDisplayedTask:(id)sender
{
	id taskObj = [document valueForKey:@"displayedTaskObj"];
	
	if ( taskObj == nil ) return;
	
	if ( [[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask )
	{
		[MySvn killProcess:[taskObj valueForKey:@"pid"]];
	
	} else
	{
		[[taskObj valueForKey:@"task"] terminate];
	}	
}


#pragma mark -
#pragma mark Accessors

// - document : A MyRepository or a MyWorkingCopy instance
- (id)document { return document; }
- (void)setDocument:(id)aDocument {
    id old = [self document];
    document = [aDocument retain];
    [old release];
}


@end
