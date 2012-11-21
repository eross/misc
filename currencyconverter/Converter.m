#import "Converter.h"

@implementation Converter
- (float)convertCurrency:(float)currency atRate:(float)rate {
	return currency * rate;
}
@end
