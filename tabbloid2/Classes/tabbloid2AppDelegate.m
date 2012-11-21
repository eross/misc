//
//  tabbloid2AppDelegate.m
//  tabbloid2
//
//  Created by Eric Ross on 8/20/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

#import "tabbloid2AppDelegate.h"

@implementation tabbloid2AppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	//NSString *url = @"http://www.google.com";
	//NSString *url = @"http://www.tabbloid.com/me";
	//NSString *content = @"api_key=a5f43e02c9c24a0f34259dd1d4cbbf25f2d3b006ad0b6e029de9b9cdc0e00b48&method=list_feeds";
	NSString *content = @"api_key=a5f43e02c9c24a0f34259dd1d4cbbf25f2d3b006ad0b6e029de9b9cdc0e00b48&method=make_pdf";
	NSString *url = @"http://tabbloid.com/api";
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
    // Override point for customization after application launch
	wv.scalesPageToFit = YES;
	[wv loadRequest:urlRequest];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
