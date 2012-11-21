#import <Foundation/Foundation.h>


@interface Person : NSObject <NSCoding> {
	NSString *personName;
	float expectedRaise;
}

- (float)expectedRaise;
- (void)setExpectedRaise:(float)x;
- (NSString *)personName;
- (void)setPersonName:(NSString *)aName;

@end
