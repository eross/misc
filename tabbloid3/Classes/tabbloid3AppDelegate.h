//
//  tabbloid3AppDelegate.h
//  tabbloid3
//
//  Created by Eric Ross on 8/24/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

@interface tabbloid3AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

