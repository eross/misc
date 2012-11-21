/* Converter */

#import <Cocoa/Cocoa.h>

@interface Converter : NSObject
{
}
- (float)convertCurrency:(float)currency atRate:(float)rate;
@end
