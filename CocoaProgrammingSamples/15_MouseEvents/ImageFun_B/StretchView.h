/* StretchView */

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView
{
    NSBezierPath *path;
    NSImage *image;
    float opacity;
}
- (void)setImage:(NSImage *)image;
- (void)setOpacity:(float)x;
- (NSPoint)randomPoint;

@end
