//
//  tabbloid1AppDelegate.m
//  tabbloid1
//
//  Created by Eric Ross on 8/20/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

#import "tabbloid1AppDelegate.h"
#import "tabbloid1ViewController.h"

@implementation tabbloid1AppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
