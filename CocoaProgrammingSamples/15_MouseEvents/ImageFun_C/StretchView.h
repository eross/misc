/* StretchView */

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView
{
    NSBezierPath *path;
    NSImage *image;
    float opacity;
    NSPoint downPoint;
    NSPoint currentPoint;
}
- (NSPoint)randomPoint;
- (void)setImage:(NSImage *)image;
- (void)setOpacity:(float)x;
- (NSRect)currentRect;
@end
