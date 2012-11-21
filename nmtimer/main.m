//
//  main.m
//  nmtimer
//
//  Created by Eric on 4/2/05.
//  Copyright Eric Ross 2005 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    //return NSApplicationMain(argc, (const char **) argv);
	[NSApplication sharedApplication];
	[NSBundle loadNibNamed:@"MainMenu.nib"  owner:NSApp];
	[NSApp run];
	return 0;
}
