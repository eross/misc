#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
    NSString *string;
	IBOutlet NSTextView *textView;
}
@end
