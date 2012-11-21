#import <Cocoa/Cocoa.h>

@interface WormController : NSObject {
    NSTextField *actualFrameRateTextField;
    NSTextField *scoreTextField;
    id wormView;
    NSButton *startStopButton;
    NSTimer *updateTimer;
}

- (void)toggleGame:(id)sender;
- (void)resetGame:(id)sender;

- (void)changeWormString:(id)sender;
- (void)changeFrameRate:(id)sender;
- (void)changeViewType:(id)sender;

- (void)scoreChanged:(id)view;
- (void)gameStatusChanged:(id)view;

@end
