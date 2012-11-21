//
//  tabbloid3AppDelegate.m
//  tabbloid3
//
//  Created by Eric Ross on 8/24/09.
//  Copyright Eric Ross 2009. All rights reserved.
//
#import "RootViewController.h"
#import "tabbloid3AppDelegate.h"



@implementation tabbloid3AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize rootViewController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
	[navigationController pushViewController:rootViewController animated:TRUE];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

