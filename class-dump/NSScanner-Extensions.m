//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import "NSScanner-Extensions.h"

#import <Foundation/Foundation.h>
#import "NSString-Extensions.h"

@implementation NSScanner (CDExtensions)

// other: $_:*
// start: alpha + other
// remainder: alnum + other

+ (NSCharacterSet *)cdOtherCharacterSet;
{
    static NSCharacterSet *otherCharacterSet = nil;

    if (otherCharacterSet == nil)
        otherCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"$_:*"] retain];

    return otherCharacterSet;
}

+ (NSCharacterSet *)cdIdentifierStartCharacterSet;
{
    static NSCharacterSet *identifierStartCharacterSet = nil;

    if (identifierStartCharacterSet == nil) {
        NSMutableCharacterSet *aSet;

        aSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
        [aSet formUnionWithCharacterSet:[NSScanner cdOtherCharacterSet]];
        identifierStartCharacterSet = [aSet copy];

        [aSet release];
    }

    return identifierStartCharacterSet;
}

+ (NSCharacterSet *)cdIdentifierCharacterSet;
{
    static NSCharacterSet *identifierCharacterSet = nil;

    if (identifierCharacterSet == nil) {
        NSMutableCharacterSet *aSet;

        aSet = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
        [aSet formUnionWithCharacterSet:[NSScanner cdOtherCharacterSet]];
        identifierCharacterSet = [aSet copy];

        [aSet release];
    }

    return identifierCharacterSet;
}

- (NSString *)peekCharacter;
{
    //[self skipCharacters];

    if ([self isAtEnd] == YES)
        return nil;

    return [[self string] substringWithRange:NSMakeRange([self scanLocation], 1)];
}

- (unichar)peekChar;
{
    return [[self string] characterAtIndex:[self scanLocation]];
}

- (BOOL)scanCharacter:(unichar *)value;
{
    unichar ch;

    //[self skipCharacters];

    if ([self isAtEnd] == YES)
        return NO;

    ch = [[self string] characterAtIndex:[self scanLocation]];
    if (value != NULL)
        *value = ch;

    [self setScanLocation:[self scanLocation] + 1];

    return YES;
}

- (BOOL)scanCharacterFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
{
    unichar ch;

    //[self skipCharacters];

    if ([self isAtEnd] == YES)
        return NO;

    ch = [[self string] characterAtIndex:[self scanLocation]];
    if ([set characterIsMember:ch] == YES) {
        if (value != NULL) {
            *value = [NSString stringWithUnichar:ch];
        }

        [self setScanLocation:[self scanLocation] + 1];
        return YES;
    }

    return NO;
}

// On 10.3 (7D24) the Foundation scanCharactersFromSet:intoString: inverts the set each call, creating an autoreleased CFCharacterSet.
// This cuts the total CFCharacterSet alloctions (when run on Foundation) from 161682 down to 17.

// This works for my purposes, but I haven't tested it to make sure it's fully compatible with the standard version.

- (BOOL)my_scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
{
    NSRange matchedRange;
    unsigned int currentLocation;

    //[self skipCharacters];

    currentLocation = [self scanLocation];
    matchedRange.location = currentLocation;
    matchedRange.length = 0;

    while ([self isAtEnd] == NO) {
        unichar ch;

        ch = [[self string] characterAtIndex:currentLocation];
        if ([set characterIsMember:ch] == NO)
            break;

        currentLocation++;
        [self setScanLocation:currentLocation];
    }

    matchedRange.length = currentLocation - matchedRange.location;

    if (matchedRange.length == 0)
        return NO;

    if (value != NULL) {
        *value = [[self string] substringWithRange:matchedRange];
    }

    return YES;
}

- (BOOL)scanIdentifierIntoString:(NSString **)stringPointer;
{
    NSString *start, *remainder;

    if ([self scanString:@"?" intoString:stringPointer] == YES) {
        return YES;
    }

    if ([self scanCharacterFromSet:[NSScanner cdIdentifierStartCharacterSet] intoString:&start] == YES) {
        NSString *str;

        if ([self my_scanCharactersFromSet:[NSScanner cdIdentifierCharacterSet] intoString:&remainder] == YES) {
            str = [start stringByAppendingString:remainder];
        } else {
            str = start;
        }

        if (stringPointer != NULL)
            *stringPointer = str;

        return YES;
    }

    return NO;
}

@end
