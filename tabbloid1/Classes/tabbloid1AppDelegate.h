//
//  tabbloid1AppDelegate.h
//  tabbloid1
//
//  Created by Eric Ross on 8/20/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tabbloid1ViewController;

@interface tabbloid1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    tabbloid1ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet tabbloid1ViewController *viewController;

@end

