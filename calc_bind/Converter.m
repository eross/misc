#import "Converter.h"

@implementation Converter

- (double)amountInOtherCurrency{
	return (double)(dollarsToConvert * exchangeRate);
}

+ (void)initialize {
	[Converter setKeys:
		[NSArray arrayWithObjects:@"dollarsToConvert", @"exchangeRate", nil]
		triggerChangeNotificationsForDependentKey:@"amountInOtherCurrency"];
}

@end
