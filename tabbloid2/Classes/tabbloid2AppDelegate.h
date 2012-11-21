//
//  tabbloid2AppDelegate.h
//  tabbloid2
//
//  Created by Eric Ross on 8/20/09.
//  Copyright Eric Ross 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabbloid2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UIWebView *wv;
	IBOutlet UITextField *tf;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

