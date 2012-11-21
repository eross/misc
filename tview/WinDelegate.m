#import "WinDelegate.h"

@implementation WinDelegate

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSString *methodName = NSStringFromSelector(aSelector);
	NSLog(@"respondsToSelecto:%@", methodName);
	return [super respondsToSelector:aSelector];
}

@end
