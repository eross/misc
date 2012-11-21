#import <Foundation/Foundation.h>
@class NSColorList;

@interface ColorFormatter : NSFormatter {
    NSColorList *colorList;
}
- (NSString *)firstColorKeyForPartialString:(NSString *)string;
@end
