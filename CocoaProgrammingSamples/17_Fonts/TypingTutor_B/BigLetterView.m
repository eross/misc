#import "BigLetterView.h"

@implementation BigLetterView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        NSLog(@"initializing view");
        [self prepareAttributes];
        [self setBgColor:[NSColor yellowColor]];
        [self setString:@""];
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
    [bgColor set];
    [NSBezierPath fillRect:bounds];
    
    [self drawStringCenteredIn:bounds];
    // Am I the window's first responder
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

- (void)didEnd:(NSSavePanel *)sheet 
	returnCode:(int)code 
   contextInfo:(void *)contextInfo
{
    NSRect r;
    NSData *data;
    
    if (code == NSOKButton) {
        r = [self bounds];
        data = [self dataWithPDFInsideRect:r];
        [data writeToFile:[sheet filename] atomically:YES];
    }
}

- (void)dealloc
{
    [string release];
    [attributes release];
    [bgColor release];
    [super dealloc];
}

@end
