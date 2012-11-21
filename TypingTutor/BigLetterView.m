#import "BigLetterView.h"
#import "FirstLetter.h"

@implementation BigLetterView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		NSLog(@"initializing view");
		[self prepareAttributes];
		[self setBgColor:[NSColor yellowColor]];
		[self setString:@" "];
		// Add initialization code here
	}
	return self;
}


- (void)setBgColor:(NSColor *)c
{
	[c retain];
	[bgColor release];
	bgColor = c;
	[self setNeedsDisplay:YES];
}

- (NSColor *)bgColor
{
	return bgColor;
}

- (void)setString:(NSString *)c
{
	c = [c copy];
	[string release];
	string = c;
	NSLog(@"The string is now %@", string);
	[self setNeedsDisplay:YES];
}

- (NSString *)string
{
	return string;
}

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	[bgColor set];
	[NSBezierPath fillRect:bounds];
	
	[self drawStringCenteredIn:bounds];
	// first responder?
	if ([[self window] firstResponder] == self) {
		[[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath setDefaultLineWidth:4.0];
		[NSBezierPath strokeRect:bounds];
	}
}	
- (BOOL)isOpaque
{
	return YES;
}
	
- (BOOL)acceptsFirstResponder
{
	NSLog(@"Accepting");
	return YES;
}
	
- (BOOL)resignFirstResponder
{
	NSLog(@"Resigning");
	[self setNeedsDisplay:YES];
	return YES;
}

- (BOOL)becomeFirstResponder
{
	NSLog(@"Becoming");
	[self setNeedsDisplay:YES];
	return YES;
}

- (void)keyDown:(NSEvent *)event
{
	[self interpretKeyEvents:[NSArray arrayWithObject:event]];
}

- (void)insertText:(NSString *)input
{
	NSLog(@"insertText");
	[self setString:input];
}

- (void)insertTab:(id)sender
{
	[[self window] selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender
{
	[[self window] selectKeyViewPrecedingView:self];
}

- (void) prepareAttributes
{
	attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject:[NSFont fontWithName:@"Helvetica" size:75]
				   forKey:NSFontAttributeName];
	
	[attributes setObject:[NSColor redColor]
				   forKey:NSForegroundColorAttributeName];
}

- (void)drawStringCenteredIn:(NSRect)r
{
	NSPoint stringOrigin;
	NSSize stringSize;
	
	stringSize = [string sizeWithAttributes:attributes];
	stringOrigin.x = r.origin.x + (r.size.width - stringSize.width)/2;
	stringOrigin.y = r.origin.y + (r.size.height - stringSize.height)/2;
	[string drawAtPoint:stringOrigin withAttributes:attributes];
}

- (IBAction)savePDF:(id)sender
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setRequiredFileType:@"pdf"];
	[panel beginSheetForDirectory:nil
						file:nil
						modalForWindow:[self window]
						modalDelegate:self
						didEndSelector:
						@selector(didEnd:returnCode:contextInfo:)
						contextInfo:NULL];
}

- (void)didEnd:(NSSavePanel *)sheet
	returnCode:(int)code
	contextInfo:(void *)contextInfo
{
	NSRect r;
	NSData *data;
	
	if(code == NSOKButton) {
	r = [self bounds];
	data = [self dataWithPDFInsideRect:r];
	[data writeToFile:[sheet filename] atomically:YES];
	}
}

- (void)writeStringToPasteboard:(NSPasteboard *)pb
{
	// Declare types
	[pb declareTypes:
		[NSArray arrayWithObject:NSStringPboardType]
			   owner:self];
	// Copy data to the pasteboard
	[pb setString:string forType:NSStringPboardType];
}
- (BOOL)readStringFromPasteBoard:(NSPasteboard *)pb
{
	NSString *value;
	NSString *type = [pb availableTypeFromArray:
		[NSArray arrayWithObject:NSStringPboardType]];
	
	if (type)
	{
		value = [pb stringForType:NSStringPboardType];
		[self setString:[value firstLetter]];
		return YES;
	}
	return NO;
}

- (IBAction)cut:(id)sender
{
	[self copy:sender];
	[self setString:@" "];
}

- (IBAction)copy:(id)sender
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[self writeStringToPasteboard:pb];
}

- (IBAction)paste:(id)sender
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	if(![self readStringFromPasteBoard:pb])
	{
		NSBeep();
	}
}

- (void)dealloc
{
	[string release];
	[attributes release];
	[bgColor release];
	[super dealloc];
}

- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
    return NSDragOperationCopy;
}

- (void)mouseDragged:(NSEvent*)event
{
    NSRect imageBounds;
    NSPasteboard *pb;
    NSImage *anImage;
    NSSize s;
    NSPoint p;
    
    // Get the size of the string
    s = [string sizeWithAttributes:attributes];
    anImage = [[NSImage alloc] initWithSize:s];
    
    // create a rect in which you will draw the letter
    // in the image
    imageBounds.origin = NSMakePoint(0,0);
    imageBounds.size = s;
    
    // Draw the letter on the image
    [anImage lockFocus];
    [self drawStringCenteredIn:imageBounds];
    [anImage unlockFocus];
    
    // Get the location of the drag event
    p = [self convertPoint:[event locationInWindow] fromView:nil];
    
    // Drag from the center of the image
    p.x = p.x - s.width/2;
    p.y = p.y - s.height/2;
    
    // Get the pasteboard
    pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    
    // Put the string on the pasteboard
    [self writeStringToPasteboard:pb];
    
    // Start the drag
    
    [self dragImage:anImage
                 at:p
             offset:NSMakeSize(0, 0)
              event:event
         pasteboard:pb
             source:self
          slideBack:YES];
    [anImage release];
}

@end
