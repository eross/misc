/* Controller */

#import <Cocoa/Cocoa.h>
enum {
	PLUS		= 1001,
	SUBTRACT	= 1002,
	MULTIPLY	= 1003,
	DIVIDE		= 1004,
	EQUALS		= 1005
	};
	
@interface Controller : NSObject
{
    IBOutlet id readout;
	BOOL enterFlag;
	BOOL yFlag;
	int operation;
	double X;
	double Y;
}
- (IBAction)clear:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)enterDigit:(id)sender;
- (IBAction)enterOp:(id)sender;
- (IBAction)fileNew:(id)sender;
- (void)displayX;
@end
