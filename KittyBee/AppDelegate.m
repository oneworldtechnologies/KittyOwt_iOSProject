//
//  AppDelegate.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 31/03/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JASidePanelController.h"
#import "FMenuViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Reachability.h"
#import "ServicesManager.h"

const NSUInteger kApplicationID = 42779;
NSString *const kAuthKey        = @"LLLxgsMYpBgmqwf";
NSString *const kAuthSecret     = @"x7rx-j7ZMSTnBWn";
NSString *const kAccountKey     = @"KmWfth7Wo2EVHqtWiE7P";

@interface AppDelegate (){
     Reachability *internetReachable;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [QBSettings setApplicationID:kApplicationID];
    
    [QBSettings setAuthKey:kAuthKey];
    
    [QBSettings setAuthSecret:kAuthSecret];
    
    [QBSettings setAccountKey:kAccountKey];
    application.applicationIconBadgeNumber = 0;
   
    [QBSettings setChatDNSLookupCacheEnabled:YES];

    // app was launched from push notification, handling it
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        ServicesManager.instance.notificationService.pushDialogID = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey][kPushNotificationDialogIdentifierKey];
    }
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.leftPanel = [[FMenuViewController alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSString *quickId=[prefs objectForKey:@"quickID"];
    if(USERID && quickId){
        QBUUser *user = [QBUUser new];
        USERID =[NSString stringWithFormat:@"0%@",USERID];
        NSString *UserName= [prefs stringForKey:@"UserName"];
        user.login = USERID;
        user.password = @"KittyBeeArun";
        user.fullName=UserName;
        [ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
            
            }];
        
         self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    }else{
         self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
   
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].clientID = @"23596211365-cs87blqoau639el1a3hbf6m3us33dhb6.apps.googleusercontent.com";
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    

    
    return ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                        annotation:annotation]|| [[GIDSignIn sharedInstance] handleURL:url
                                                                                                     sourceApplication:sourceApplication
                                                                                                            annotation:annotation]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification userInfo=%@", userInfo);
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([application applicationState] != UIApplicationStateInactive){
        return;
    }
    
    NSString *dialogID = userInfo[kPushNotificationDialogIdentifierKey];
    if (dialogID == nil) {
        return;
    }
    
    NSString *dialogWithIDWasEntered = [ServicesManager instance].currentDialogID;
    if ([dialogWithIDWasEntered isEqualToString:dialogID]) return;
    
    ServicesManager.instance.notificationService.pushDialogID = dialogID;
    
    // calling dispatch async for push notification handling to have priority in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [ServicesManager.instance.notificationService handlePushNotificationWithDelegate:self];
    });
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    // subscribing for push notifications
    QBMSubscription *subscription = [QBMSubscription subscription];
    subscription.notificationChannel = QBMNotificationChannelAPNS;
    subscription.deviceUDID = deviceIdentifier;
    subscription.deviceToken = deviceToken;
    
    [QBRequest createSubscription:subscription successBlock:nil errorBlock:nil];
    
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr = [deviceTokenStr substringWithRange:NSMakeRange(1, [deviceTokenStr length]-1)];
    deviceTokenStr = [deviceTokenStr substringToIndex:[deviceTokenStr length]-1];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is: %@", deviceTokenStr);
    [[NSUserDefaults standardUserDefaults]setValue:deviceTokenStr forKey:@"deviceTokenStrKey"];
    NSLog(@"My token is: %@", deviceToken);
    
  }

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
   NSLog(@"error!! %@",error);
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if(user.userID){
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
 //   NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
  //  NSString *givenName = user.profile.givenName;
  //  NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
     NSURL *picUrl=[user.profile imageURLWithDimension:500];
    if (user.profile.hasImage) {
        picUrl=[user.profile imageURLWithDimension:500];
    }else{
         picUrl=[NSURL URLWithString:@""];
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:userId forKey:@"gmailID"];
    [dict setObject:@"" forKey:@"deviceID"];
    [dict setObject:fullName forKey:@"name"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:[NSString stringWithFormat:@"%@",picUrl] forKey:@"profilePic"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"gmailLogin"
                                      object:nil
                                    userInfo:dict];
    }else{
        
        [AlertView showAlertWithMessage:@"Please Login to Gmail first."];
    }
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     application.applicationIconBadgeNumber = 0;
    [ServicesManager.instance.chatService disconnectWithCompletionBlock:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [ServicesManager.instance.chatService connectWithCompletionBlock:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            
            
            [self Login];
            NSLog(@"The internet is Connected.");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"OflineMode"
             object:self];
            
            NSLog(@"The internet is Connected.");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"OflineModeHost"
             object:self];
            break;
        }
        case ReachableViaWWAN:
        {
            [self Login];
            NSLog(@"The internet is working via WWAN!");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"OflineMode"
             object:self];
            
            NSLog(@"The internet is Connected.");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"OflineModeHost"
             object:self];
            break;
        }
    }
}
-(void)Login{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSString *quickId=[prefs objectForKey:@"quickID"];
    if(USERID && quickId){
        QBUUser *user = [QBUUser new];
        USERID =[NSString stringWithFormat:@"0%@",USERID];
        NSString *UserName= [prefs stringForKey:@"UserName"];
        user.login = USERID;
        user.password = @"KittyBeeArun";
        user.fullName=UserName;
        [ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
            
        }];
    }

}
#pragma mark - NotificationServiceDelegate protocol

- (void)notificationServiceDidSucceedFetchingDialog:(QBChatDialog *)chatDialog {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
//    ChatViewController *chatController = (ChatViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
//    chatController.dialog = chatDialog;
    
    NSString *dialogWithIDWasEntered = [ServicesManager instance].currentDialogID;
    if (dialogWithIDWasEntered != nil) {
        // some chat already opened, return to dialogs view controller first
        [navigationController popViewControllerAnimated:NO];
    }
   // [navigationController pushViewController:chatController animated:YES];
}
@end
