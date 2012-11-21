//
//  KeyGenerator.m
//  simpleBinding
//
//  Created by Eric Ross on 5/4/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "KeyGenerator.h"


@implementation KeyGenerator

- (id)init
{
	currentkey = 42;
	return self;
}

-(int)nextKey
{
	NSLog(@"nextKey\n");
	currentkey += 1;
	return currentkey;
}

+ (KeyGenerator *)getKeyGenerator
{
	static KeyGenerator *kg = nil;
	if(kg == nil)
	{
		kg = [[KeyGenerator alloc] init];
	}
	return kg;
}
@end
