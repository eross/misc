/* Foo */

#import <Cocoa/Cocoa.h>

@interface Foo : NSObject
{
    IBOutlet NSTextField *textField;
}
- (IBAction)generate:(id)sender;
- (IBAction)seed:(id)sender;
@end
