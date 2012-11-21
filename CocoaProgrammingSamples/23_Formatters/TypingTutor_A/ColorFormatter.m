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
    // Find a string for the color "obj"
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
        [obj getRed:&red 
			  green:&green 
			   blue:&blue 
			  alpha:&alpha];
        keys = [colorList allKeys];
        keyCount = [keys count];
		
		// Initialize howClose to something large
        howClose = 3;
        
        // Loop through all of the colors looking for closest
        for (i=0; i < keyCount; i++) {
            key = [keys objectAtIndex:i];
            color2 = [colorList colorWithKey:key];
            
            // Find the color components of the current color
            [color2 getRed:&red2 
					 green:&green2 
					  blue:&blue2 
					 alpha:&alpha2];
            
            // How far is it from obj?
            distance = fabs(red2 - red) + 
				       fabs(green2 - green) + 
				       fabs(blue2 - blue);
            
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
        // Occasionally, 'errorString' is NULL
        if (errorString != NULL) {
            *errorString = @"No such color";
        }
        return NO;
    }
}

- (void)dealloc
{
    [colorList release];
    [super dealloc];
}

@end
