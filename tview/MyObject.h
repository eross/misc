/* MyObject */

#import <Cocoa/Cocoa.h>

@interface MyObject : NSObject
{
	NSString *key;
	NSString *description;
}
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;

@end
