//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import "CDLoadCommand.h"

@interface CDDynamicSymbolTable : CDLoadCommand
{
    struct dysymtab_command dysymtab;
}

- (id)initWithPointer:(const void *)ptr machOFile:(CDMachOFile *)aMachOFile;

@end
