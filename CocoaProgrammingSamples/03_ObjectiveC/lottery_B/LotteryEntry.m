#import "LotteryEntry.h"


@implementation LotteryEntry

- (void)prepareRandomNumbers
{
    firstNumber = random() % 100 + 1;
    secondNumber = random() % 100 + 1;
}

- (void)setEntryDate:(NSCalendarDate *)date
{
    [date retain];
    [entryDate release];
    [date setCalendarFormat:@"%b %d, %Y"];
    entryDate = date;
}

- (NSCalendarDate *)entryDate
{
    return entryDate;    
}

- (int)firstNumber
{
    return firstNumber;
}

- (int)secondNumber
{
    return secondNumber;
}

- (void)dealloc
{
    NSLog(@"Destroying %@", self);
    [entryDate release];
    [super dealloc];
}

@end
