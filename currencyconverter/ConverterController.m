#import "ConverterController.h"
#import "Converter.h"

@implementation ConverterController

- (IBAction)convert:(id)sender
{
	float rate, currency, amount;
	currency = [dollarField floatValue];
	rate =	   [rateField floatValue];
	
	amount =   [converter convertCurrency:currency atRate:rate];
	[amountField setFloatValue:amount];
	[rateField selectText:self];
}

- (IBAction)sendmail:(id)sender
{

	[message setStringValue:@"hello"];
	
}


@end
