//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import <Foundation/NSObject.h>

@class NSMutableDictionary, NSMutableString;
@class CDClassDump, CDOCSymtab;

@interface CDOCModule : NSObject
{
    unsigned long version;
    NSString *name;
    CDOCSymtab *symtab;
}

- (id)init;
- (void)dealloc;

- (unsigned long)version;
- (void)setVersion:(unsigned long)aVersion;

- (NSString *)name;
- (void)setName:(NSString *)newName;

- (CDOCSymtab *)symtab;
- (void)setSymtab:(CDOCSymtab *)newSymtab;

- (NSString *)description;
- (NSString *)formattedString;

- (void)appendToString:(NSMutableString *)resultString classDump:(CDClassDump *)aClassDump;
- (void)registerClassesWithObject:(NSMutableDictionary *)aDictionary frameworkName:(NSString *)aFrameworkName;
- (void)generateSeparateHeadersClassDump:(CDClassDump *)aClassDump;

@end
