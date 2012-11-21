#import "BigLetterPalette.h"

@implementation BigLetterPalette

- (void)finishInstantiate
{
    [view setString:@"X"];
    [super finishInstantiate];
}

@end

@implementation BigLetterView (BigLetterPaletteInspector)

- (NSString *)inspectorClassName
{
    return @"BigLetterInspector";
}

@end
