//
//  KeyGenerator.h
//  simpleBinding
//
//  Created by Eric Ross on 5/4/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KeyGenerator : NSObject {
	int currentkey;

}
- (int)nextKey;
+ (KeyGenerator *)getKeyGenerator;

@end
