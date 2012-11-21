#import "Controller.h"
#import "Pressdb.h"

@implementation Controller


- (IBAction)clear:(id)sender
{
	X = 0.0;
	[self displayX];
}

- (IBAction)clearAll:(id)sender
{
	X = 0.0;
	Y = 0.0;
	yFlag = NO;
	enterFlag = NO;
	[self displayX];
}

- (IBAction)enterDigit:(id)sender
{
	if (enterFlag) {
		Y = X;
		X = 0.0;
		enterFlag = NO;
		}
	X = (X*10.0) + [ [sender selectedCell] tag ];
	[self displayX];
}

- (IBAction)fileNew:(id)sender
{
	[self displayX];
}

- (IBAction)enterOp:(id)sender
{
	if (yFlag) {
		switch (operation) {
			case PLUS:
				X = Y + X;
				break;
			case SUBTRACT:
				X = Y - X;
				break;
			case MULTIPLY:
				X = Y * X;
				break;
			case DIVIDE:
				X = Y / X;
				break;
			}
		}
		
		Y = X;
		yFlag = YES;
		
		operation = [ [sender selectedCell] tag];
		enterFlag = YES;
		
		[self displayX];
}

- (void) displayX
{
	id s = [NSString stringWithFormat:@"%15.10g", X ];
	[readout setStringValue: s];
}
@end
