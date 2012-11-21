#import <Cocoa/Cocoa.h>
@class Person;

@interface MyDocument : NSDocument
{
	IBOutlet NSArrayController *personController;
	NSMutableArray *employees;
}
- (void)insertObject:(Person *)p inEmployeesAtIndex:(int)index;
- (void)removeObjectFromEmployeesAtIndex:(int)index;
- (void)setEmployees:(NSMutableArray *)array;
@end
