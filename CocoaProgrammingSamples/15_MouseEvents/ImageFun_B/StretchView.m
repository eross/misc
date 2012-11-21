#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        // Seed the random number generator
        srandom(time(NULL));
        
        // Create a path object
        path = [[NSBezierPath alloc] init];
        [path setLineWidth:2.3];
        NSPoint p = [self randomPoint];
        [path moveToPoint:p];
        int i;
        for (i=0; i < 15; i++) {
            p = [self randomPoint];
            [path lineToPoint:p];
        }
        [path closePath];
    }
    return self;
}

// randomPoint returns a random point inside the view
- (NSPoint)randomPoint
{
    NSPoint result;
    NSRect r;
    int width, height;
    r= [self bounds];
    width = round(r.size.width);
    height = round(r.size.height);
    result.x = (random() % width) + r.origin.x;
    result.y = (random() % height) + r.origin.y;
    return result;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    
    // Fill view with green
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];

    // Draw the path in white
    [[NSColor whiteColor] set];
    [path stroke];
    if (image) {
        NSRect imageRect;
        NSRect drawingRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = [image size];
        drawingRect = imageRect;
        [image drawInRect:drawingRect
                 fromRect:imageRect
                operation:NSCompositeSourceOver
                 fraction:opacity];
    }
}

- (void)mouseDown:(NSEvent *)event
{
    NSLog(@"mouseDown: %d", [event clickCount]);
}

- (void)mouseDragged:(NSEvent *)event
{
    NSLog(@"mouseDragged:");
}

- (void)mouseUp:(NSEvent *)event
{
    NSLog(@"mouseUp:");
}

- (void)setImage:(NSImage *)newImage
{
    [newImage retain];
    [image release];
    image = newImage;
    [self setNeedsDisplay:YES];
}

- (void)setOpacity:(float)x
{
    opacity = x;
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    [image release];
    [path release];
    [super dealloc];
}

@end
