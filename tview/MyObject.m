#import "MyObject.h"

@implementation MyObject
#define ROWS 32

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	return [NSString stringWithFormat:@"%@, %d\n",[[aTableColumn headerCell] stringValue], rowIndex];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return ROWS;
}

@end
