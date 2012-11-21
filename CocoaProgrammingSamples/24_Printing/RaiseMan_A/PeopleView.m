#import "PeopleView.h"
#import "Person.h"
#define VSPACE 30.0

@implementation PeopleView

- (id)initWithPeople:(NSArray *)array printInfo:(NSPrintInfo *)pi
{
	NSRange pageRange;
	NSRect frame;
	
	// Get the useful data out of the print info
	paperSize = [pi paperSize];
	leftMargin = [pi leftMargin];
	topMargin = [pi topMargin];
	
	people = [array retain];
	
	// Get the number of pages
	[self knowsPageRange:&pageRange];
	
	// The view must be big enough to hold the first and last pages
	frame = NSUnionRect([self rectForPage:pageRange.location],
						[self rectForPage:NSMaxRange(pageRange)-1]);
	
	// Call the superclass's designated initializer
	[super initWithFrame:frame];
	
	// The attributes of the text to be printed
	attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject:[NSFont fontWithName:@"Helvetica" size:15.0]
				   forKey:NSFontAttributeName];
	return self;
}

// The origin of the view is at the upper-left corner
- (BOOL)isFlipped
{
	return YES;
}

- (NSRect)rectForPage:(int)page
{
	NSRect result;
	result.size = paperSize;
	
	// Page numbers start at 1
	result.origin.y = (page - 1) * paperSize.height;
	result.origin.x = 0.0;
	return result;
}

- (int)peoplePerPage
{
	float ppp = (paperSize.height - (2.0 * topMargin)) / VSPACE;
	return (int)ppp;
}

- (BOOL)knowsPageRange:(NSRange *)r
{
	int peoplePerPage = [self peoplePerPage];
	
	// Page counts start at 1
	r->location = 1;
	r->length = ([people count] / peoplePerPage);
	if ([people count] % peoplePerPage > 0) {
		r->length = r->length + 1;
	}
	return YES;
}

- (NSRect)rectForPerson:(int)i
{
	NSRect result;
	int peoplePerPage = [self peoplePerPage];
	result.size.height = VSPACE;
	result.size.width = paperSize.width - (2 * leftMargin);
	result.origin.x = leftMargin;
	int page = i / peoplePerPage;
	int indexOnPage = i % peoplePerPage;
	result.origin.y = (page * paperSize.height) + topMargin +
		(indexOnPage * VSPACE);
	return result;
}

- (void)drawRect:(NSRect)r
{
	int count, i;
	count  = [people count];
	for (i = 0; i < count; i++) {
		NSRect personRect = [self rectForPerson:i];
		if (NSIntersectsRect(r, personRect)) {
			Person *p = [people objectAtIndex:i];
			NSString *dataString;
			dataString = [NSString stringWithFormat:@"%d.\t%@\t%f", i, [p personName], [p expectedRaise]];
			[dataString drawInRect:personRect
					withAttributes:attributes];
		}
	}
}

- (void)dealloc
{
	[attributes release];
	[people release];
	[super dealloc];
}

@end
