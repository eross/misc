//
//  iphone1AppDelegate.m
//  iphone1
//
//  Created by Eric Ross on 7/6/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

#import "iphone1AppDelegate.h"

@implementation iphone1AppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
