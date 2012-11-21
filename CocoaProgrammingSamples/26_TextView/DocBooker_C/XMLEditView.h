/* XMLEditView */

#import <Cocoa/Cocoa.h>

@interface XMLEditView : NSTextView
{
	NSMenu *wrappingMenu;
}
- (IBAction)wrap:(id)sender;
@end
