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
