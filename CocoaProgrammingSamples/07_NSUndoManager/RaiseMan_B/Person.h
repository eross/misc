#import <Foundation/Foundation.h>


@interface Person : NSObject {
	NSString *personName;
	float expectedRaise;
}

- (float)expectedRaise;
- (void)setExpectedRaise:(float)x;
- (NSString *)personName;
- (void)setPersonName:(NSString *)aName;

@end
