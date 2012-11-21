#import "BigLetterPalette.h"

@implementation BigLetterPalette

- (void)finishInstantiate
{
    /* `finishInstantiate' can be used to associate non-view objects with
     * a view in the palette's nib.  For example:
     *   [self associateObject:aNonUIObject ofType:IBObjectPboardType
     *                withView:aView];
     */
}

@end

@implementation BigLetterView (BigLetterPaletteInspector)

- (NSString *)inspectorClassName
{
    return @"BigLetterInspector";
}

@end
