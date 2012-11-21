#import "MyPlaces.h"
#import "KeyGenerator.h"

@implementation MyPlaces
- (void)dealloc
{
	NSLog(@"Dealloc MyPlaces\n");
	[super dealloc];
}

- (id)init
{
	NSLog(@"Init MyPlaces\n");
	KeyGenerator *kg = [KeyGenerator getKeyGenerator];
	key = [kg nextKey];
	return [super init];
}
- (void)setState:(NSString *)st
{
	st = [st copy];
	[state release];
	state = st;
}

- (NSString *)state
{
	return state;
}

- (void)setCity:(NSString *)c
{
	NSLog(@"-->city: %s\n",[c cString]);
	[city release];
	city = [c copy];
}

- (NSString *)city
{
	NSLog(@"city <--: %s\n", [city cString]);
	return city;
}

- (void)setKey:(int)k
{
	key = k;
}

- (int)key
{
	return key;
}

@end
