#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)rect
{
	int i;
	NSPoint p;
	
    if (self = [super initWithFrame:rect]) {
        // Seed the random number generator
        srandom(time(NULL));
        
        // Create a path object
        path = [[NSBezierPath alloc] init];
        [path setLineWidth:3.0];
        p = [self randomPoint];
        [path moveToPoint:p];
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
}

- (void)dealloc
{
    [path release];
    [super dealloc];
}

@end
