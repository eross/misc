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

- (NSRect)currentRect
{
    float minX = MIN(downPoint.x, currentPoint.x);
    float maxX = MAX(downPoint.x, currentPoint.x);
    float minY = MIN(downPoint.y, currentPoint.y);
    float maxY = MAX(downPoint.y, currentPoint.y);
    
    return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
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
        drawingRect = [self currentRect];
        [image drawInRect:drawingRect
                 fromRect:imageRect
                operation:NSCompositeSourceOver
                 fraction:opacity];
    }
}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint p = [event locationInWindow];
    downPoint = [self convertPoint:p fromView:nil];
    currentPoint = downPoint;
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint p = [event locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event
{
    NSPoint p = [event locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)newImage
{
    [newImage retain];
    [image release];
    image = newImage;
    NSSize imageSize = [image size];
    downPoint = NSZeroPoint;
    currentPoint.x = downPoint.x + imageSize.width;
    currentPoint.y = downPoint.y + imageSize.height;
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
