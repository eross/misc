#import "LotteryEntry.h"


@implementation LotteryEntry

- (id)init
{
    [super init];
    firstNumber = random() % 100 + 1;
    secondNumber = random() % 100 + 1;
    return self;
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ = %d and %d", entryDate, firstNumber, secondNumber];
}

- (void)dealloc
{
    NSLog(@"Destroying %@", self);
    [entryDate release];
    [super dealloc];
}

@end
