//  BlogDemoAppDelegate.h
//  BlogDemo
//
//  Created by Scott Stevenson on 4/11/05.
//  Copyright __MyCompanyName__ 2005 . All rights reserved.

#import <Cocoa/Cocoa.h>

@interface BlogDemoAppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end
