//
//  FirstLetter.m
//  TypingTutor
//
//  Created by Eric Ross on 1/15/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "FirstLetter.h"


@implementation NSString (FirstLetter)

- (NSString *)firstLetter
{
	NSRange r;
	if ([self length] < 2)
	{
		return self;
	}
	r.location = 0;
	r.length = 1;
	return [self substringWithRange:r];
}

@end
