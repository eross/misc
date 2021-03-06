//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import <Foundation/NSObject.h>
#import "CDTopologicalSortProtocol.h"

@class NSArray, NSDictionary, NSMutableArray, NSMutableSet, NSString;

typedef enum {
    CDWhiteNodeColor = 0,
    CDGrayNodeColor = 1,
    CDBlackNodeColor = 2,
} CDNodeColor;

@interface CDTopoSortNode : NSObject
{
    id <CDTopologicalSort> representedObject;

    NSMutableSet *dependancies;
    CDNodeColor color;
}

- (id)initWithObject:(id <CDTopologicalSort>)anObject;
- (void)dealloc;

- (NSString *)identifier;
- (id <CDTopologicalSort>)representedObject;

- (NSArray *)dependancies;
- (void)addDependancy:(NSString *)anIdentifier;
- (void)removeDependancy:(NSString *)anIdentifier;
- (void)addDependanciesFromArray:(NSArray *)identifiers;

- (CDNodeColor)color;
- (void)setColor:(CDNodeColor)newColor;

- (NSString *)description;

- (NSComparisonResult)ascendingCompareByIdentifier:(id)otherNode;
- (void)topologicallySortNodes:(NSDictionary *)nodesByIdentifier intoArray:(NSMutableArray *)sortedArray;

@end
