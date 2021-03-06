#import <Foundation/Foundation.h>


@interface LotteryEntry : NSObject {
    NSCalendarDate *entryDate;
    int firstNumber;
    int secondNumber;
}
- (id)initWithEntryDate:(NSCalendarDate *)date;
- (void)setEntryDate:(NSCalendarDate *)date;
- (NSCalendarDate *)entryDate;
- (int)firstNumber;
- (int)secondNumber;
@end
