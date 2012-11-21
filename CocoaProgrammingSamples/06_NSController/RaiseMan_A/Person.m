#import "Person.h"

@implementation Person

- (id)init
{
	[super init];
	[self setExpectedRaise:5.0];
	[self setPersonName:@"New Person"];
	return self;
}

- (float)expectedRaise
{
	return expectedRaise;
}

- (void)setExpectedRaise:(float)x
{
	expectedRaise = x;
}

- (NSString *)personName
{
	return personName;
}

- (void)setPersonName:(NSString *)aName
{
	aName = [aName copy];
	[personName release];
	personName = aName;
}

- (void)dealloc
{
	[personName release];
	[super dealloc];
}

@end
