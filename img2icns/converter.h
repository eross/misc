/* converter */

#import <Cocoa/Cocoa.h>

@interface converter : NSObject
{
    IBOutlet id dirButt;
    IBOutlet id icnsButt;
    IBOutlet id prefWin;
}
- (IBAction)setDir:(id)sender;
- (IBAction)setIcns:(id)sender;
@end
