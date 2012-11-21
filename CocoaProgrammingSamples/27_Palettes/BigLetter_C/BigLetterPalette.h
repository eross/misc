#import <InterfaceBuilder/InterfaceBuilder.h>
#import "BigLetterView.h"

@interface BigLetterPalette : IBPalette
{
    IBOutlet BigLetterView *view;
}
@end

@interface BigLetterView (BigLetterPaletteInspector)
- (NSString *)inspectorClassName;
@end
