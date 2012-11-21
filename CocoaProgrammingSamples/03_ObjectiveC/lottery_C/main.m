#import <Foundation/Foundation.h>
#import "LotteryEntry.h"

int main (int argc, const char * argv[]) {
    NSMutableArray *array;
    int i;
    LotteryEntry *newEntry;
    LotteryEntry *entryToPrint;

    NSCalendarDate *now;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    // Create the date object
    now = [[NSCalendarDate alloc] init];
	
    // Initialize the random number generator
    srandom(time(NULL));
    array = [[NSMutableArray alloc] init];
    
    for (i=0; i < 10; i++) {
        // Create a new instance of LotteryEntry
        newEntry = [[LotteryEntry alloc] init];
        [newEntry prepareRandomNumbers];
        
        // Create a date/time object that is i weeks from now
        [newEntry setEntryDate:[now dateByAddingYears:0
                                               months:0
                                                 days:(i * 7)
                                                hours:0
                                              minutes:0
                                              seconds:0]];
        
        // Add the LotteryEntry object to the array
        [array addObject:newEntry];

        // Decrement the retain count of the LotteryEntry object
        [newEntry release];
    }
    
    for (i=0; i < 10; i++) {
        // Ger an instance of LotteryEntry
        entryToPrint = [array objectAtIndex:i];
        NSLog(@"entry %d is %@", i, entryToPrint);
    }
    
    [array release];
	
    // Release the current time
    [now release];
    [pool release];
    return 0;
}
