#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSMutableArray *array;
    int i;
    NSNumber *newNumber;
    NSNumber *numberToPrint;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    array = [[NSMutableArray alloc] init];
    for ( i = 0; i < 10; i++ ) {
        newNumber = [[NSNumber alloc] initWithInt:(i * 3)];
        [array addObject:newNumber];
        // If you already know some Cocoa, you might notice that
        // I have a memory leak here.  We will fix it soon.
    }
    
    for ( i = 0; i < 10; i++) {
        numberToPrint = [array objectAtIndex:i];
        NSLog(@"The number at index %d is %@", i, numberToPrint);
    }
    
    [array release];
    [pool release];
    return 0;
}
