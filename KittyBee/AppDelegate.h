//
//  AppDelegate.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 31/03/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

// Stores reference on PubNub client to make sure what it won't be released.
@end

