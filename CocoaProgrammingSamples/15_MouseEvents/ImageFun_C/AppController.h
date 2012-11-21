/* AppController */

#import <Cocoa/Cocoa.h>
@class StretchView;

@interface AppController : NSObject
{
    IBOutlet NSSlider *slider;
    IBOutlet StretchView *stretchView;
}
- (IBAction)fade:(id)sender;
- (IBAction)open:(id)sender;
@end
