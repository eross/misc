//
//  FirstLetter.m
//  TypingTutor
//
//  Created by student on Tue Sep 16 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

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
