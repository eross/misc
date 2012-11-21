//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import "CDType.h"

#import <Foundation/Foundation.h>
#import "NSArray-Extensions.h"
#import "NSString-Extensions.h"
#import "CDSymbolReferences.h"
#import "CDTypeName.h"
#import "CDTypeLexer.h" // For T_NAMED_OBJECT
#import "CDTypeFormatter.h"

@implementation CDType

- (id)init;
{
    if ([super init] == nil)
        return nil;

    type = 0; // ??
    subtype = nil;
    typeName = nil;
    members = nil;
    variableName = nil;
    bitfieldSize = nil;
    arraySize = nil;

    return self;
}

- (id)initSimpleType:(int)aTypeCode;
{
    if ([self init] == nil)
        return nil;

    if (aTypeCode == '*') {
        type = '^';
        subtype = [[CDType alloc] initSimpleType:'c'];
    } else {
        type = aTypeCode;
    }

    return self;
}

- (id)initIDType:(CDTypeName *)aName;
{
    if ([self init] == nil)
        return nil;

    if (aName != nil) {
        type = '^';
        subtype = [[CDType alloc] initNamedType:aName];
    } else {
        type = '@';
    }

    return self;
}

- (id)initNamedType:(CDTypeName *)aName;
{
    if ([self init] == nil)
        return nil;

    type = T_NAMED_OBJECT;
    typeName = [aName retain];

    return self;
}

- (id)initStructType:(CDTypeName *)aName members:(NSArray *)someMembers;
{
    if ([self init] == nil)
        return nil;

    type = '{';
    typeName = [aName retain];
    members = [someMembers retain];

    return self;
}

- (id)initUnionType:(CDTypeName *)aName members:(NSArray *)someMembers;
{
    if ([self init] == nil)
        return nil;

    type = '(';
    typeName = [aName retain];
    members = [someMembers retain];

    return self;
}

- (id)initBitfieldType:(NSString *)aBitfieldSize;
{
    if ([self init] == nil)
        return nil;

    type = 'b';
    bitfieldSize = [aBitfieldSize retain];

    return self;
}

- (id)initArrayType:(CDType *)aType count:(NSString *)aCount;
{
    if ([self init] == nil)
        return nil;

    type = '[';
    arraySize = [aCount retain];
    subtype = [aType retain];

    return self;
}

- (id)initPointerType:(CDType *)aType;
{
    if ([self init] == nil)
        return nil;

    type = '^';
    subtype = [aType retain];

    return self;
}

- (id)initModifier:(int)aModifier type:(CDType *)aType;
{
    if ([self init] == nil)
        return nil;

    type = aModifier;
    subtype = [aType retain];

    return self;
}

- (void)dealloc;
{
    [subtype release];
    [typeName release];
    [members release];
    [variableName release];
    [bitfieldSize release];
    [arraySize release];

    [super dealloc];
}

- (NSString *)variableName;
{
    return variableName;
}

- (void)setVariableName:(NSString *)newVariableName;
{
    if (newVariableName == variableName)
        return;

    [variableName release];
    variableName = [newVariableName retain];
}

- (int)type;
{
    return type;
}

- (BOOL)isIDType;
{
    return type == '@' && typeName == nil;
}

- (CDType *)subtype;
{
    return subtype;
}

- (CDTypeName *)typeName;
{
    return typeName;
}

- (NSArray *)members;
{
    return members;
}

- (void)setMembers:(NSArray *)newMembers;
{
    if (newMembers == members)
        return;

    [members release];
    members = [newMembers retain];
}

- (BOOL)isModifierType;
{
    return type == 'r' || type == 'n' || type == 'N' || type == 'o' || type == 'O' || type == 'R' || type == 'V';
}

- (int)typeIgnoringModifiers;
{
    if ([self isModifierType] == YES && subtype != nil)
        return [subtype typeIgnoringModifiers];

    return type;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"[%@] type: %d('%c'), name: %@, subtype: %@, bitfieldSize: %@, arraySize: %@, members: %@, variableName: %@",
                     NSStringFromClass([self class]), type, type, typeName, subtype, bitfieldSize, arraySize, members, variableName];
}

- (NSString *)formattedString:(NSString *)previousName formatter:(CDTypeFormatter *)typeFormatter level:(int)level symbolReferences:(CDSymbolReferences *)symbolReferences;
{
    NSString *result, *currentName;
    NSString *baseType, *memberString;

    assert(variableName == nil || previousName == nil);
    if (variableName != nil)
        currentName = variableName;
    else
        currentName = previousName;

    switch (type) {
      case T_NAMED_OBJECT:
          assert(typeName != nil);
          [symbolReferences addClassName:[typeName name]];
          if (currentName == nil)
              result = [typeName description];
          else
              result = [NSString stringWithFormat:@"%@ %@", typeName, currentName];
          break;

      case '@':
          if (currentName == nil)
              result = @"id";
          else
              result = [NSString stringWithFormat:@"id %@", currentName];
          break;

      case 'b':
          if (currentName == nil) {
              // This actually compiles!
              result = [NSString stringWithFormat:@"unsigned int :%@", bitfieldSize];
          } else
              result = [NSString stringWithFormat:@"unsigned int %@:%@", currentName, bitfieldSize];
          break;

      case '[':
          if (currentName == nil)
              result = [NSString stringWithFormat:@"[%@]", arraySize];
          else
              result = [NSString stringWithFormat:@"%@[%@]", currentName, arraySize];

          result = [subtype formattedString:result formatter:typeFormatter level:level symbolReferences:symbolReferences];
          break;

      case '(':
          baseType = nil;
          if (typeName == nil || [@"?" isEqual:[typeName description]] == YES) {
              NSString *typedefName;

              typedefName = [typeFormatter typedefNameForStruct:self level:level];
              if (typedefName != nil) {
                  baseType = typedefName;
              }
          }

          if (baseType == nil) {
              if (typeName == nil || [@"?" isEqual:[typeName description]] == YES)
                  baseType = @"union";
              else
                  baseType = [NSString stringWithFormat:@"union %@", typeName];

              if (([typeFormatter shouldAutoExpand] == YES && [@"?" isEqual:[typeName description]] == YES)
                  || (level == 0 && [typeFormatter shouldExpand] == YES && [members count] > 0))
                  memberString = [NSString stringWithFormat:@" {\n%@%@}",
                                           [self formattedStringForMembersAtLevel:level + 1 formatter:typeFormatter symbolReferences:symbolReferences],
                                           [NSString spacesIndentedToLevel:[typeFormatter baseLevel] + level spacesPerLevel:4]];
              else
                  memberString = @"";

              baseType = [baseType stringByAppendingString:memberString];
          }

          if (currentName == nil || [currentName hasPrefix:@"?"] == YES) // Not sure about this
              result = baseType;
          else
              result = [NSString stringWithFormat:@"%@ %@", baseType, currentName];
          break;

      case '{':
          baseType = nil;
          if (typeName == nil || [@"?" isEqual:[typeName description]] == YES) {
              NSString *typedefName;

              typedefName = [typeFormatter typedefNameForStruct:self level:level];
              if (typedefName != nil) {
                  baseType = typedefName;
              }
          }
          if (baseType == nil) {
              if (typeName == nil || [@"?" isEqual:[typeName description]] == YES)
                  baseType = @"struct";
              else
                  baseType = [NSString stringWithFormat:@"struct %@", typeName];

              if (([typeFormatter shouldAutoExpand] == YES && [@"?" isEqual:[typeName description]] == YES)
                  || (level == 0 && [typeFormatter shouldExpand] == YES && [members count] > 0))
                  memberString = [NSString stringWithFormat:@" {\n%@%@}",
                                           [self formattedStringForMembersAtLevel:level + 1 formatter:typeFormatter symbolReferences:symbolReferences],
                                           [NSString spacesIndentedToLevel:[typeFormatter baseLevel] + level spacesPerLevel:4]];
              else
                  memberString = @"";

              baseType = [baseType stringByAppendingString:memberString];
          }

          if (currentName == nil || [currentName hasPrefix:@"?"] == YES) // Not sure about this
              result = baseType;
          else
              result = [NSString stringWithFormat:@"%@ %@", baseType, currentName];
          break;

      case '^':
          if (currentName == nil)
              result = @"*";
          else
              result = [@"*" stringByAppendingString:currentName];

          if (subtype != nil && [subtype type] == '[')
              result = [NSString stringWithFormat:@"(%@)", result];

          result = [subtype formattedString:result formatter:typeFormatter level:level symbolReferences:symbolReferences];
          break;

      case 'r':
      case 'n':
      case 'N':
      case 'o':
      case 'O':
      case 'R':
      case 'V':
          if (subtype == nil) {
              if (currentName == nil)
                  result = [self formattedStringForSimpleType];
              else
                  result = [NSString stringWithFormat:@"%@ %@", [self formattedStringForSimpleType], currentName];
          } else
              result = [NSString stringWithFormat:@"%@ %@",
                                 [self formattedStringForSimpleType], [subtype formattedString:currentName formatter:typeFormatter level:level symbolReferences:symbolReferences]];
          break;

      default:
          if (currentName == nil)
              result = [self formattedStringForSimpleType];
          else
              result = [NSString stringWithFormat:@"%@ %@", [self formattedStringForSimpleType], currentName];
          break;
    }

    return result;
}

- (NSString *)formattedStringForMembersAtLevel:(int)level formatter:(CDTypeFormatter *)typeFormatter symbolReferences:(CDSymbolReferences *)symbolReferences;
{
    NSMutableString *str;
    int count, index;
    CDType *replacementType;
    NSArray *targetMembers;

    assert(type == '{' || type == '(');
    str = [NSMutableString string];

    // The replacement type will have member names, while ours don't.
    replacementType = [typeFormatter replacementForType:self];
    if  (replacementType != nil)
        targetMembers = [replacementType members];
    else
        targetMembers = members;

    count = [targetMembers count];
    for (index = 0; index < count; index++) {

        [str appendString:[NSString spacesIndentedToLevel:[typeFormatter baseLevel] + level spacesPerLevel:4]];
        [str appendString:[[targetMembers objectAtIndex:index] formattedString:nil
                                                               formatter:typeFormatter
                                                               level:level
                                                               symbolReferences:symbolReferences]];
        [str appendString:@";\n"];
    }

    return str;
}

- (NSString *)formattedStringForSimpleType;
{
    // Ugly but simple:
    switch (type) {
      case 'c': return @"char";
      case 'i': return @"int";
      case 's': return @"short";
      case 'l': return @"long";
      case 'q': return @"long long";
      case 'C': return @"unsigned char";
      case 'I': return @"unsigned int";
      case 'S': return @"unsigned short";
      case 'L': return @"unsigned long";
      case 'Q': return @"unsigned long long";
      case 'f': return @"float";
      case 'd': return @"double";
      case 'B': return @"_Bool"; /* C99 _Bool or C++ bool */
      case 'v': return @"void";
      case '*': return @"STR";
      case '#': return @"Class";
      case ':': return @"SEL";
      case '%': return @"NXAtom";
      case '?': return @"void";
          //case '?': return @"UNKNOWN"; // For easier regression testing.
      case 'r': return @"const";
      case 'n': return @"in";
      case 'N': return @"inout";
      case 'o': return @"out";
      case 'O': return @"bycopy";
      case 'R': return @"byref";
      case 'V': return @"oneway";
      default:
          break;
    }

    return nil;
}

- (NSString *)typeString;
{
    return [self _typeStringWithVariableNamesToLevel:1e6];
}

- (NSString *)bareTypeString;
{
    return [self _typeStringWithVariableNamesToLevel:0];
}

- (NSString *)keyTypeString;
{
    // use variable names at top level
    return [self _typeStringWithVariableNamesToLevel:1];
}

- (NSString *)_typeStringWithVariableNamesToLevel:(int)level;
{
    NSString *result;

    switch (type) {
      case T_NAMED_OBJECT:
          assert(typeName != nil);
          result = [NSString stringWithFormat:@"@\"%@\"", typeName];
          break;

      case '@':
          result = @"@";
          break;

      case 'b':
          result = [NSString stringWithFormat:@"b%@", bitfieldSize];
          break;

      case '[':
          result = [NSString stringWithFormat:@"[%@%@]", arraySize, [subtype _typeStringWithVariableNamesToLevel:level]];
          break;

      case '(':
          if (typeName == nil) {
              return [NSString stringWithFormat:@"(%@)", [self _typeStringForMembersWithVariableNamesToLevel:level]];
          } else if ([members count] == 0) {
              return [NSString stringWithFormat:@"(%@)", typeName];
          } else {
              return [NSString stringWithFormat:@"(%@=%@)", typeName, [self _typeStringForMembersWithVariableNamesToLevel:level]];
          }
          break;

      case '{':
          if (typeName == nil) {
              return [NSString stringWithFormat:@"{%@}", [self _typeStringForMembersWithVariableNamesToLevel:level]];
          } else if ([members count] == 0) {
              return [NSString stringWithFormat:@"{%@}", typeName];
          } else {
              return [NSString stringWithFormat:@"{%@=%@}", typeName, [self _typeStringForMembersWithVariableNamesToLevel:level]];
          }
          break;

      case '^':
          if ([subtype type] == T_NAMED_OBJECT)
              result = [subtype _typeStringWithVariableNamesToLevel:level];
          else
              result = [NSString stringWithFormat:@"^%@", [subtype _typeStringWithVariableNamesToLevel:level]];
          break;

      case 'r':
      case 'n':
      case 'N':
      case 'o':
      case 'O':
      case 'R':
      case 'V':
          result = [NSString stringWithFormat:@"%c%@", type, [subtype _typeStringWithVariableNamesToLevel:level]];
          break;

      default:
          result = [NSString stringWithFormat:@"%c", type];
          break;
    }

    return result;
}

- (NSString *)_typeStringForMembersWithVariableNamesToLevel:(int)level;
{
    NSMutableString *str;
    int count, index;

    assert(type == '{' || type == '(');
    str = [NSMutableString string];

    count = [members count];
    for (index = 0; index < count; index++) {
        CDType *aMember;
        aMember = [members objectAtIndex:index];
        if ([aMember variableName] != nil && level > 0)
            [str appendFormat:@"\"%@\"", [aMember variableName]];
        [str appendString:[aMember _typeStringWithVariableNamesToLevel:level - 1]];
    }

    return str;
}

- (void)phase:(int)phase registerStructuresWithObject:(id <CDStructureRegistration>)anObject usedInMethod:(BOOL)isUsedInMethod;
{
    if (phase == 1)
        [self phase1RegisterStructuresWithObject:anObject];
    else if (phase == 2)
        [self phase2RegisterStructuresWithObject:anObject usedInMethod:isUsedInMethod countReferences:YES];
}

- (void)phase1RegisterStructuresWithObject:(id <CDStructureRegistration>)anObject;
{
    int count, index;

    if (subtype != nil)
        [subtype phase1RegisterStructuresWithObject:anObject];

    count = [members count];
    if ((type == '{' || type == '(') && count > 0) {
        [anObject phase1RegisterStructure:self];
        for (index = 0; index < count; index++) {
            [[members objectAtIndex:index] phase1RegisterStructuresWithObject:anObject];
        }
    }
}

- (void)phase2RegisterStructuresWithObject:(id <CDStructureRegistration>)anObject
                              usedInMethod:(BOOL)isUsedInMethod
                           countReferences:(BOOL)shouldCountReferences;
{
    if (subtype != nil)
        [subtype phase2RegisterStructuresWithObject:anObject usedInMethod:isUsedInMethod countReferences:shouldCountReferences];

    if (type == '{' || type == '(') {
        int count, index;
        BOOL newFlag;

        newFlag = [anObject phase2RegisterStructure:self usedInMethod:isUsedInMethod countReferences:shouldCountReferences];
        if (shouldCountReferences == NO)
            newFlag = NO;

        count = [members count];
        for (index = 0; index < count; index++) {
            [[members objectAtIndex:index] phase2RegisterStructuresWithObject:anObject usedInMethod:NO countReferences:newFlag];
        }
    }
}

- (BOOL)isEqual:(CDType *)otherType;
{
    return [[self typeString] isEqual:[otherType typeString]];
}

- (BOOL)isBasicallyEqual:(CDType *)otherType;
{
    return [[self keyTypeString] isEqual:[otherType keyTypeString]];
}

- (BOOL)isStructureEqual:(CDType *)otherType;
{
    return [[self bareTypeString] isEqual:[otherType bareTypeString]];
}

// Merge struct/union member names
- (void)mergeWithType:(CDType *)otherType;
{
    int count, index;
    int otherCount;
    NSArray *otherMembers;

    if ([self type] != [otherType type]) {
        NSLog(@"Warning: Trying to merge different types in %s", _cmd);
        return;
    }

    [subtype mergeWithType:[otherType subtype]];

    otherMembers = [otherType members];
    count = [members count];
    otherCount = [otherMembers count];

    // The counts can be zero when we register structures that just have a name.  That happened while I was working on the
    // structure registration.
    if (otherCount == 0) {
        return;
    } else if (count == 0 && otherCount != 0) {
        [self setMembers:otherMembers];
    } else if (count != otherCount) {
        NSLog(@"Warning: Types have different number of members.  This is bad. (%d vs %d)", count, otherCount);
        NSLog(@"%@ vs %@", [self typeString], [otherType typeString]);
        return;
    }

    for (index = 0; index < count; index++) {
        CDType *thisMember, *otherMember;
        CDTypeName *thisTypeName, *otherTypeName;
        NSString *thisVariableName, *otherVariableName;

        thisMember = [members objectAtIndex:index];
        otherMember = [otherMembers objectAtIndex:index];

        thisTypeName = [thisMember typeName];
        otherTypeName = [otherMember typeName];
        thisVariableName = [thisMember variableName];
        otherVariableName = [otherMember variableName];
        //NSLog(@"%d: type: %@ vs %@", index, thisTypeName, otherTypeName);
        //NSLog(@"%d: vari: %@ vs %@", index, thisVariableName, otherVariableName);

        if ((thisTypeName == nil && otherTypeName != nil) || (thisTypeName != nil && otherTypeName == nil))
            ; // It seems to be okay if one of them didn't have a name
            //NSLog(@"Warning: (1) type names don't match, %@ vs %@", thisTypeName, otherTypeName);
        else if (thisTypeName != nil && [thisTypeName isEqual:otherTypeName] == NO)
            NSLog(@"Warning: (2) type names don't match, %@ vs %@.", thisTypeName, otherTypeName);

        if (otherVariableName != nil) {
            if (thisVariableName == nil)
                [thisMember setVariableName:otherVariableName];
            else if ([thisVariableName isEqual:otherVariableName] == NO)
                NSLog(@"Warning: Different variable names for same member...");
        }
    }
}

- (void)generateMemberNames;
{
    if (type == '{' || type == '(') {
        int count, index;
        NSSet *usedNames;
        int number;
        CDType *aMember;
        NSString *name;

        usedNames = [[NSSet alloc] initWithArray:[members arrayByMappingSelector:@selector(variableName)]];

        count = [members count];
        number = 1;
        for (index = 0; index < count; index++) {
            aMember = [members objectAtIndex:index];
            [aMember generateMemberNames];

            // Bitfields don't need a name.
            if ([aMember variableName] == nil && [aMember type] != 'b') {
                do {
                    name = [NSString stringWithFormat:@"_field%d", number++];
                } while ([usedNames containsObject:name] == YES);
                [aMember setVariableName:name];
            }
        }

        [usedNames release];

    }

    [subtype generateMemberNames];
}

@end
