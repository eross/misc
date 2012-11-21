#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frameRect·
{
    if ((self = [super initWithFrame:frameRect]) != nil) {
        // Add initialization code here
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
}

@end
