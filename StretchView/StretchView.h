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
- (void)setImage:(NSImage *)newImage;
- (void)setOpacity:(float)x;
- (NSPoint)randomPoint;

@end
