#import "BigLetterView.h"
#import "FirstLetter.h"

@implementation BigLetterView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        NSLog(@"initializing view");
        [self prepareAttributes];
        [self setBgColor:[NSColor yellowColor]];
        [self setString:@" "];
		[self setCopyable:YES];
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
        [self prepareAttributes];
		
		if ([coder allowsKeyedCoding]) {
			[self setBgColor:[coder decodeObjectForKey:@"bgColor"]];
			[self setString:[coder decodeObjectForKey:@"string"]];
			[self setCopyable:[coder decodeBoolForKey:@"copyable"]];
		} else {
			[self setBgColor:[coder decodeObject]];
			[self setString:[coder decodeObject]];
			[self setCopyable:[coder decodeValueOfObjCType:@encode(BOOL) 
														at:&copyable]];
		}
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	// Call NSView's encodeWithCoder: method
    [super encodeWithCoder:coder];
	if ([coder allowsKeyedCoding]) {
		[coder encodeObject:bgColor forKey:@"bgColor"];
		[coder encodeObject:string forKey:@"string"];
		[coder encodeBool:copyable forKey:@"copyable"];
	} else {
		[coder encodeObject:bgColor];
		[coder encodeObject:string];
		[coder encodeValueOfObjCType:@encode(BOOL) at:&copyable];
	}
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

- (void)setString:(NSString *)s
{
    [s retain];
    [string release];
    string = s;
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
    
    // Draw white background if highlighted
    if (highlighted) {
        [[NSColor whiteColor] set];
    } else {
        [bgColor set];
    }
    [NSBezierPath fillRect:bounds];
    
    [self drawStringCenteredIn:bounds];
	// Am I the window's first responder?
    if ([[self window] firstResponder] == self) {
		[[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath setDefaultLineWidth:4.0];
        [NSBezierPath strokeRect:bounds];
    }
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
    // Set string to be what the user typed
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

- (void)prepareAttributes
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
                   didEndSelector:@selector(didEnd:returnCode:contextInfo:)
                      contextInfo:NULL];
}

- (void)didEnd:(NSSavePanel *)sheet returnCode:(int)code contextInfo:(void *)contextInfo
{
    NSRect r;
    NSData *data;
    
    if (code == NSOKButton) {
        r = [self bounds];
        data = [self dataWithPDFInsideRect:r];
        [data writeToFile:[sheet filename] atomically:YES];
    }
}

- (void)writeStringToPasteboard:(NSPasteboard *)pb
{
    // Declare types
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    // Copy data to the pasteboard
    [pb setString:string forType:NSStringPboardType];
}

- (BOOL)readStringFromPasteboard:(NSPasteboard *)pb
{
    NSString *value;
    NSString *type;
    
    // Is there a string on the pasteboard?
    type = [pb availableTypeFromArray:[NSArray arrayWithObject:NSStringPboardType]];
    if (type) {
        // Read the string from the pasteboard
        value = [pb stringForType:NSStringPboardType];
        [self setString:[value firstLetter]];
        return YES;
    }
    return NO;
}

- (IBAction)cut:(id)sender
{
    [self copy:sender];
    [self setString:@""];
}

- (IBAction)copy:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self writeStringToPasteboard:pb];
}

- (IBAction)paste:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    if (![self readStringFromPasteboard:pb]) {
        NSBeep();
    }
}

- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)mouseDragged:(NSEvent *)event
{
    NSRect imageBounds;
    NSPasteboard *pb;
    NSImage *anImage;
    NSSize s;
    NSPoint p;
	
	if (!copyable) {
		NSLog(@"Drag not permitted");
		return;
	}
    
    // Create the image that will be dragged
    anImage = [[NSImage alloc] init];
    
    // Get the size of the string
    s = [string sizeWithAttributes:attributes];
    
    // Create a rect in which you will draw the letter in he image
    imageBounds.origin = NSMakePoint(0,0);
    imageBounds.size = s;
    [anImage setSize:s];
    
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
             offset:NSMakeSize(0,0) 
              event:event 
         pasteboard:pb 
             source:self 
          slideBack:YES];
    [anImage release];
}

- (void)draggedImage:(NSImage *)image
             endedAt:(NSPoint)screenPoint
           operation:(NSDragOperation)operation
{
    if (operation == NSDragOperationDelete) {
        [self setString:@""];
    }
}

- (unsigned int)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] != self) {
        NSPasteboard *pb = [sender draggingPasteboard];
        NSString *type = [pb availableTypeFromArray:[NSArray arrayWithObject:NSStringPboardType]];
        if (type != nil) {
            highlighted = YES;
            [self setNeedsDisplay:YES];
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingExited:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    if (![self readStringFromPasteboard:pb]) {
        NSLog(@"Error: Could not read from dragging pasteboard");
        return NO;
    }
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    NSLog(@"concludeDragOperation:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (void)setCopyable:(BOOL)yn
{
	copyable = yn;
}

- (BOOL)copyable
{
	return copyable;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	NSString *selectorString;
	selectorString = NSStringFromSelector([menuItem action]);
	NSLog(@"validateCalled for %@", selectorString);
	
	// By using the action instead of the title, we do not
	// have to worry about whether the menu item is localized
	if (([menuItem action] == @selector(copy:)) ||
		([menuItem action] == @selector(cut:))) {
		return copyable;
	} else {
		return YES;
	}
}

- (void)setBudda:(id)x
{
	NSLog(@"setBudda:%@", x);
	[self setString:[x firstLetter]];
}

+ (void)initialize
{
	[self exposeBinding:@"budda"];
}

- (id)budda
{
	return string;
}

- (void)dealloc
{
    [string release];
    [attributes release];
    [bgColor release];
    [super dealloc];
}

@end
