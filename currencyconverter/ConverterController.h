/* ConverterController */

#import <Cocoa/Cocoa.h>

@interface ConverterController : NSObject
{
    IBOutlet NSTextField *amountField;
    IBOutlet id converter;
    IBOutlet NSTextField *dollarField;
    IBOutlet NSTextField *rateField;
	IBOutlet NSTextField *message;
}
- (IBAction)convert:(id)sender;
@end
