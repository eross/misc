#import <Cocoa/Cocoa.h>
@class Person;

@interface MyDocument : NSDocument
{
	IBOutlet NSArrayController *personController;
	IBOutlet NSTableView *tableView;
	NSMutableArray *employees;
}
- (void)insertObject:(Person *)p inEmployeesAtIndex:(int)index;
- (void)removeObjectFromEmployeesAtIndex:(int)index;
- (void)setEmployees:(NSMutableArray *)array;
@end
