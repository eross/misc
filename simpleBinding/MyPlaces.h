/* MyPlaces */

#import <Cocoa/Cocoa.h>

@interface MyPlaces : NSObject
{
	int key;
	NSString *city;
	NSString *state;
}

- (int)key;
- (void)setKey:(int)nkey;
- (NSString *)city;
- (void)setCity:(NSString *)c;
- (NSString *)state;
- (void)setState:(NSString *)st;
@end
