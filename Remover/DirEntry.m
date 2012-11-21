// DirEntry.m

#import "DirEntry.h"

@implementation DirEntry

#pragma mark Creation and Destruction

+ (NSMutableArray *)entriesAtPath:(NSString *)path withParent:(DirEntry *)d;
{
	NSMutableArray *result = [NSMutableArray array];
	NSArray *filenames;
	filenames = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	if (filenames == nil) {
		NSRunAlertPanel(@"Read failed",
						@"Unable to read \'%@\'",
						nil, nil, nil,
						path);
		return result;
	}
	int max, k;
	max = [filenames count];
	for (k = 0; k < max; k++)
	{
		DirEntry *newEntry;
		NSString *filename = [filenames objectAtIndex:k];
		newEntry = [[DirEntry alloc] initWithFilename:filename parent:d];
		[result addObject:newEntry];
		[newEntry release];
	}
	return result;
}

- (id)initWithFilename:(NSString *)fn parent:(DirEntry *)d;
{
	[super init];
	parent = [d retain];
	filename = [fn copy];
	return self;
}

- (void)dealloc
{
	[attributes release];
	[filename release];
	[parent release];
	[super dealloc];
}

#pragma mark File info

- (NSMutableArray *)components
{
	NSMutableArray *result;
	if (!parent)
	{
		result = [NSMutableArray arrayWithObject:@"/"];
	}
	else
	{
		result = [parent components];
	}
	[result addObject:[self filename]];
	return result;
}

- (NSString *)fullPath
{
	return [NSString pathWithComponents:[self components]];
}

- (NSString *)filename;
{
	return filename;
}

- (NSDictionary *)attributes
{
	if (!attributes) 
	{
		NSString *path = [self fullPath];
		attributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
		[attributes retain];
	}
	return attributes;
}

- (BOOL)isDirectory
{
	NSString *fileType = [[self attributes] fileType];
	return [fileType isEqual:NSFileTypeDirectory];
}

- (DirEntry *)parent
{
	return parent;
}

#pragma mark For use in bindings

- (BOOL)isLeaf
{
	return ![self isDirectory];
}

- (unsigned long long)fileSize
{
	return [[self attributes] fileSize];
}

- (NSArray *)children
{
	NSString *path = [self fullPath];
	return [DirEntry entriesAtPath:path withParent:self];
}

@end
