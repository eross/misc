#import "MyApplication.h"
#import "AppController.h"

@implementation MyApplication

- (void)handleUtterScriptCommand:(NSScriptCommand *)command
{
    NSLog(@"handleUtterScriptCommand:%@", command);
    [[self delegate] sayIt:nil];
}

@end
