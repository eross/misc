#import "MyDocument.h"

@implementation MyDocument

- (NSString *)string
{
    return string;
}

- (void)setString:(NSString *)value
{
    [value retain];
    [string release];
    string = value;
}

- (void)updateString
{
    [self setString:[textView string]];
}

- (void)updateView
{
    [textView setString:[self string]];
}

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	if (!string) {
		[self setString:@""];
	}
	[self updateView];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    [self updateString];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    NSString *aString = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    if (aString == nil) {
        return NO;
    }
    [self setString:aString];
    [aString release];
    [self updateView];
    return YES;
}
- (void)dealloc
{
    [string release];
    [super dealloc];
}
@end
