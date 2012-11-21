//
//  ColorFormatter.m
//  TypingTutor
//
//  Created by student on Wed Sep 17 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ColorFormatter.h"


@implementation ColorFormatter

- (id)init
{
    if (self = [super init]) {
        colorList = [[NSColorList colorListNamed:@"Apple"] retain];
    }
    return self;
}

// A private method
- (NSString *)firstColorKeyForPartialString:(NSString *)string
{
    NSArray *keys = [colorList allKeys];
    NSString *key;
    NSRange whereFound;
    int i, keyCount;
    keyCount = [keys count];
    
    // Loop through the color list
    for (i=0; i < keyCount; i++) {
        key = [keys objectAtIndex:i];
        whereFound = [key rangeOfString:string options:NSCaseInsensitiveSearch];
        // Does the string match the beginning of the color name?
        if ((whereFound.location == 0) && (whereFound.length > 0)) {
            return key;
        }
    }
    // If no match, return nil
    return nil;
}

- (NSString *)stringForObjectValue:(id)obj
{
    // Find a string for the color obj
    float red, green, blue, alpha;
    float red2, green2, blue2, alpha2;
    NSColor *color2;
    NSString *key, *closestKey;
    float howClose, distance;
    int i, keyCount;
    NSArray *keys;
    closestKey = nil;
    // Is this a color object?
    if ([obj isKindOfClass:[NSColor class]]) {
        // Get the color components
        [obj getRed:&red green:&green blue:&blue alpha:&alpha];
        keys = [colorList allKeys];
        keyCount = [keys count];
        howClose = 3;
        
        // Loop through all of the colors
        for (i=0; i < keyCount; i++) {
            key = [keys objectAtIndex:i];
            color2 = [colorList colorWithKey:key];
            
            // Find the color components of the current color
            [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
            
            // How far is it from obj?
            distance = fabs(red2 - red) + fabs(green2 - green) + fabs(blue2 - blue);
            
            // Is this the closest yet?
            if (distance < howClose) {
                howClose = distance;
                closestKey = key;
            }
        } // for
        
        // Return the name of the closest color
        return closestKey;
    } else {
        // If not a color, return nil
        return nil;
    }
}

- (BOOL)getObjectValue:(id *)obj
             forString:(NSString *)string
      errorDescription:(NSString **)errorString
{
    // Look up the color for string
    NSString *matchingKey = [self firstColorKeyForPartialString:string];
    if (matchingKey) {
        *obj = [colorList colorWithKey:matchingKey];
        return YES;
    } else {
        // Occasionally, errorString is NULL
        if (errorString != NULL) {
            *errorString = @"No such color";
        }
        return NO;
    }
}

- (BOOL)isPartialStringValid:(NSString *)partial
            newEditingString:(NSString **)newString
            errorDescription:(NSString **)error
{
    NSString *match;
    if ([partial length] == 0) {
        return YES;
    }
    match = [self firstColorKeyForPartialString:partial];
    if (match) {
        return YES;
    } else {
        *error = @"No such color";
        return NO;
    }
}

- (BOOL)isPartialStringValid:(NSString **)partialPtr 
       proposedSelectedRange:(NSRangePointer)proposedSelPtr 
              originalString:(NSString *)orig 
       originalSelectedRange:(NSRange)origSel 
            errorDescription:(NSString **)error
{
    NSString *match;
    // Zero-length strings are fine
    if ([*partialPtr length] == 0) {
        return YES;
    }
    match = [self firstColorKeyForPartialString:*partialPtr];
    // No color match?
    if (!match) {
        return NO;
    }
    
    // If this would not move the cursor forward, it is a delete
    if (origSel.location == proposedSelPtr->location) {
        return YES;
    }
    
    // If the partial string is shorter than the match, provide the match and set the selection
    if ([match length] != [*partialPtr length]) {
        proposedSelPtr->location = [*partialPtr length];
        proposedSelPtr->length = [match length] - [*partialPtr length];
        *partialPtr = match;
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject
                                 withDefaultAttributes:(NSDictionary *)attributes
{
    NSColor *fgColor;
    NSAttributedString *atString;
    NSMutableDictionary *md = [attributes mutableCopy];
    NSString *match = [self stringForObjectValue:anObject];
    if (match) {
        fgColor = [colorList colorWithKey:match];
        [md setObject:fgColor forKey:NSForegroundColorAttributeName];
    }
    atString = [[NSAttributedString alloc] initWithString:match attributes:md];
    [md release];
    [atString autorelease];
    return atString;
}

- (void)dealloc
{
    [colorList release];
    [super dealloc];
}

@end
