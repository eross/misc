#import "FirstLetter.h"

@implementation NSString (FirstLetter)

- (NSString *)firstLetter
{
    NSRange r;
    if ([self length] < 2) {
        return self;
    }
    r.location = 0;
    r.length = 1;
    return [self substringWithRange:r];
}

@end
