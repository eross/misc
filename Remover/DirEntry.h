// DirEntry.h
#import <Cocoa/Cocoa.h>

@interface DirEntry: NSObject {
NSDictionary *attributes;
DirEntry *parent;
NSString *filename;
}
+ (NSMutableArray *)entriesAtPath:(NSString *)path withParent:(DirEntry *)d;
- (id)initWithFilename:(NSString *)fn parent:(DirEntry *)d;
- (NSString *)fullPath;
- (NSString *)filename;
- (NSDictionary *)attributes;
- (unsigned long long)fileSize;
- (BOOL)isDirectory;
- (BOOL)isLeaf;
- (NSArray *)children;
- (NSMutableArray *)components;
- (DirEntry *)parent;
@end
