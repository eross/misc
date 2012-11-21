/* GlissView */

#import <Cocoa/Cocoa.h>
#define LIGHT_X_TAG 0
#define THETA_TAG 1
#define RADIUS_TAG 2

@interface GlissView : NSOpenGLView
{
    IBOutlet NSMatrix *sliderMatrix;
    float lightX, theta, radius;
}
- (void)prepare;
- (IBAction)changeParameter:(id)sender;
@end
