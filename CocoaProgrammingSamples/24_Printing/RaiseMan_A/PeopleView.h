/* PeopleView */

#import <Cocoa/Cocoa.h>

@interface PeopleView : NSView
{
	NSArray *people;
	NSMutableDictionary *attributes;
	NSSize paperSize;
	float leftMargin;
	float topMargin;
}
- (id)initWithPeople:(NSArray *)array printInfo:(NSPrintInfo *)pi;
- (NSRect)rectForPerson:(int)index;
- (int)peoplePerPage;

@end
