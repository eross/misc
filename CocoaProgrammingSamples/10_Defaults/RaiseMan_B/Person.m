#import "Person.h"

@implementation Person

- (id)init
{
	[super init];
	[self setExpectedRaise:5.0];
	[self setPersonName:@"New Person"];
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	[super init];
	[self setPersonName:[coder decodeObjectForKey:@"personName"]];
	[self setExpectedRaise:[coder decodeFloatForKey:@"expectedRaise"]];
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

- (void)setNilValueForKey: (NSString *)key
{
	if ([key isEqual:@"expectedRaise"]) {
		[self setExpectedRaise:0.0];
	} else {
		[super setNilValueForKey:key];
	}
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:personName forKey:@"personName"];
	[coder encodeFloat:expectedRaise forKey:@"expectedRaise"];
}

- (void)dealloc
{
	[personName release];
	[super dealloc];
}

@end
