/* Converter */

#import <Cocoa/Cocoa.h>

@interface Converter : NSObject
{
	double dollarsToConvert;
	double exchangeRate;
}

- (double)amountInOtherCurrency;

@end
