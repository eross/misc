//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import <Foundation/NSArray.h>

@interface NSArray (CDExtensions)

- (NSArray *)reversedArray;
- (NSArray *)arrayByMappingSelector:(SEL)aSelector;

@end

@interface NSArray (CDTopoSort)

- (NSArray *)topologicallySortedArray;

@end

@interface NSMutableArray (CDTopoSort)

- (void)sortTopologically;

@end
