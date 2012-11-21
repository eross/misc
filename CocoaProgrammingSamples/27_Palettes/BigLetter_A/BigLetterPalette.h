#import <InterfaceBuilder/InterfaceBuilder.h>
#import "BigLetterView.h"

@interface BigLetterPalette : IBPalette
{
}
@end

@interface BigLetterView (BigLetterPaletteInspector)
- (NSString *)inspectorClassName;
@end
