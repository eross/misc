#import "BigLetterInspector.h"
#import "BigLetterView.h"

@implementation BigLetterInspector

- (id)init
{
    self = [super init];
    [NSBundle loadNibNamed:@"BigLetterInspector" owner:self];
    return self;
}

- (void)ok:(id)sender
{
    BigLetterView *selectedView = [self object];
    [selectedView setBgColor:[colorWell color]];
    [selectedView setCopyable:[copyableCheckbox state]];
    [super ok:sender];
}

- (void)revert:(id)sender
{
    NSColor *color;
    BigLetterView *selectedView = [self object];
    [copyableCheckbox setState:[selectedView copyable]];
    color = [selectedView bgColor];
    [colorWell setColor:color];
    [super revert:sender];
}

@end
