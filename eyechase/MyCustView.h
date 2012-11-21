#import <Cocoa/Cocoa.h>

@interface MyCustView : NSView {
	Boolean mouseClicked;
	NSPoint npoint;
}
- (void)awakeFromNib;
- (void)mouseDown:(NSEvent *)e;
@end
