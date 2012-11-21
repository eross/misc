//
//  BigLetterInspector.m
//  BigLetter
//
//  Created by student on Thu Sep 18 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "BigLetterInspector.h"

@implementation BigLetterInspector

- (id)init
{
    self = [super init];
    [NSBundle loadNibNamed:@"BigLetterInspector" owner:self];
    return self;
}

- (void)ok:(id)sender
{
	/* Your code Here */
    [super ok:sender];
}

- (void)revert:(id)sender
{
	/* Your code Here */
    [super revert:sender];
}

@end
