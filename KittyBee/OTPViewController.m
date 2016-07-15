//
//  OTPViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "OTPViewController.h"
#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "ServicesManager.h"
#import "UsersDataSource.h"
#import "AppDelegate.h"
#import <Quickblox/QBASession.h>
@interface OTPViewController (){
    BOOL doneCancleKeyBoard;
    IndecatorView *ind;

}

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self resignKeyBoard];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtOTP.inputAccessoryView = numberToolbar;
    self.btnLogin.layer.cornerRadius=4;
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.txtOTP resignFirstResponder];
}
- (IBAction)cmdLogin:(id)sender {
    [self resignKeyBoard];
    NSString *strOTP=self.txtOTP.text;
    strOTP=[strOTP stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strOTP.length==4){
    [self resignKeyBoard];
    [self checkOTP];
    }else{
        [AlertView showAlertWithMessage:@"Enter valid OTP"];
    }
    
}

- (IBAction)cmdResendOTP:(id)sender {
    [self resignKeyBoard];
    [self sendMobileNum];
}

- (IBAction)cmdBack:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------- Text Feild delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    doneCancleKeyBoard=YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            [AlertView showAlertWithMessage:@"This field accepts only numeric entries."];
            
            return NO;
        }
    }
   

    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignKeyBoard];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark keyboardWillShow hide

-(void)cancelNumberPad{
    doneCancleKeyBoard=NO;
    self.txtOTP.text=@"";
    [self resignKeyBoard];
}
-(void)doneWithNumberPad{
    doneCancleKeyBoard=NO;
    [self resignKeyBoard];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         if(doneCancleKeyBoard){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-(keyboardSize.height-100), self.view.frame.size.width, self.view.frame.size.height);
                         }else{
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}
-(void)resignKeyBoard{
    doneCancleKeyBoard=NO;
    [self.txtOTP resignFirstResponder];
}
-(void)checkOTP{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
   __block NSString *StrMoble=[self.dictData objectForKey:@"mobile"];
    [dict setObject:StrMoble forKey:@"mobile"];
    [dict setObject:self.txtOTP.text forKey:@"otp"];
    [dict setObject:@"ios" forKey:@"deviceType"];
    [self.view addSubview:ind];
    
    [[ApiClient sharedInstance]checkOTP:dict success:^(id responseObject) {
      
        NSDictionary *DictResponce= responseObject;
        NSString *userid=[DictResponce objectForKey:@"userID"];
        NSString *quickId=[DictResponce objectForKey:@"quickID"];
        if([userid isEqualToString:@""] ){
              [ind removeFromSuperview];
            SignUpViewController* controller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
            controller.strPhoneNum=StrMoble;
            [self.navigationController pushViewController:controller animated:YES];
        }else if([quickId isEqualToString:@""]){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userid forKey:@"USERID"];
            [defaults setObject:[DictResponce objectForKey:@"name"] forKey:@"UserName"];
            [defaults setObject:[DictResponce objectForKey:@"profilePic"] forKey:@"profilePic"];
            [defaults setObject:[DictResponce objectForKey:@"phone"] forKey:@"phone"];
            [defaults setObject:[DictResponce objectForKey:@"status"] forKey:@"status"];
            [defaults synchronize];
            [self makeQuickBloxUser];
        }else{
            // Store the data
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userid forKey:@"USERID"];
            [defaults setObject:[DictResponce objectForKey:@"name"] forKey:@"UserName"];
            [defaults setObject:[DictResponce objectForKey:@"profilePic"] forKey:@"profilePic"];
            [defaults setObject:[DictResponce objectForKey:@"phone"] forKey:@"phone"];
            [defaults setObject:[DictResponce objectForKey:@"status"] forKey:@"status"];
            [defaults setObject:[DictResponce objectForKey:@"quicklogin"] forKey:@"quicklogin"];
            [defaults setObject:[DictResponce objectForKey:@"quickID"] forKey:@"quickID"];
            [defaults setObject:[DictResponce objectForKey:@"quickfull_name"] forKey:@"quickfull_name"];
            
            [defaults synchronize];
            [self quickBloxLogin];
           // self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}


-(void)quickBloxLogin{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    USERID =[NSString stringWithFormat:@"0%@",USERID];
    __block QBUUser *user = [QBUUser new];
    NSString *UserName= [prefs stringForKey:@"UserName"];
    NSString *login = USERID;
    NSString *password = @"KittyBeeArun";
    user.login=login;
    user.password=password;
    user.fullName=UserName;
    
    [QBRequest logInWithUserLogin:login password:password successBlock:^(QBResponse *response, QBUUser *user1) {
        NSLog(@"user:%@",user);
        __block QBUUser *saveUser=user1;
        [ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
            if (success) {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSString *quickID = [prefs stringForKey:@"quickID"];
                if(!(quickID)){
                    
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)saveUser.ID] forKey:@"ID"];
                    [dict setObject:saveUser.login forKey:@"login"];
                    [dict setObject:saveUser.fullName forKey:@"full_name"];
                  //  [dict setObject:[NSString stringWithFormat:@"%@",saveUser.updatedAt] forKey:@"updatedat"];
                   // [dict setObject:[NSString stringWithFormat:@"%@",saveUser.createdAt] forKey:@"created_at"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:saveUser.login forKey:@"quicklogin"];
                    [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)saveUser.ID] forKey:@"quickID"];
                    [defaults setObject:saveUser.fullName forKey:@"quickfull_name"];
                    [defaults synchronize];
                    [[ApiClient sharedInstance]addQBdata:dict success:^(id responseObject) {
                        [ind removeFromSuperview];
                        NSLog(@"responce objkect %@",responseObject);
                        [self registerForRemoteNotifications];
                        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                        [ind removeFromSuperview];
                        [AlertView showAlertWithMessage:errorString];
                    }];
                    
                    
                }else{
                    [ind removeFromSuperview];
                    self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
                }
                

            } else {
                
            }
            
        }];
        
        
    } errorBlock:^(QBResponse *response) {
          [ind removeFromSuperview];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
        [AlertView showAlertWithMessage:[response.error description]];
       
    }];

    
}

-(void)makeQuickBloxUser{
    
    // create quickBlox api
    __block QBUUser *user = [QBUUser new];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:
                        @"USERID"];
    NSString *UserName= [prefs stringForKey:@"UserName"];
    USERID =[NSString stringWithFormat:@"0%@",USERID];
    user.login = USERID;
    user.password = @"KittyBeeArun";
    user.fullName=UserName;
    NSString* password = user.password;
    
    //__weak typeof(self)weakSelf = self;
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user1) {
        [QBRequest logInWithUserLogin:user.login password:password successBlock:^(QBResponse *response, QBUUser *user1) {
            __block QBUUser *saveUser=user1;
            [ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
                if (success) {
                   
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)saveUser.ID] forKey:@"ID"];
                    [dict setObject:saveUser.login forKey:@"login"];
                    [dict setObject:saveUser.fullName forKey:@"full_name"];
                 //   [dict setObject:[NSString stringWithFormat:@"%@",saveUser.updatedAt] forKey:@"updatedat"];
                //    [dict setObject:[NSString stringWithFormat:@"%@",saveUser.createdAt] forKey:@"created_at"];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:saveUser.login forKey:@"quicklogin"];
                    [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)saveUser.ID] forKey:@"quickID"];
                    [defaults setObject:saveUser.fullName forKey:@"quickfull_name"];
                    [defaults synchronize];
                    [[ApiClient sharedInstance]addQBdata:dict success:^(id responseObject) {
                        [ind removeFromSuperview];
                        NSLog(@"responce objkect %@",responseObject);
                        [self registerForRemoteNotifications];
                        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                        [ind removeFromSuperview];
                        [AlertView showAlertWithMessage:errorString];
                    }];
                    
                } else {
                    [AlertView showAlertWithMessage:@"Hellooo"];
                }
                
            }];
            
            //            self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
        } errorBlock:^(QBResponse *response) {
            [ind removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
            [AlertView showAlertWithMessage:[response.error description]];
        }];
        
    } errorBlock:^(QBResponse *response) {
        
        NSLog(@"Errors=%@", [response.error description]);
        
        NSString *strCheck=[response.error description];
        if ([strCheck rangeOfString:@"has already been taken"].location == NSNotFound) {
            [ind removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
            [AlertView showAlertWithMessage:[response.error description]];

        }else{
            [self quickBloxLogin];
        }
        
    }];
    
    
}



-(void)sendMobileNum{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *StrMoble=[self.dictData objectForKey:@"mobile"];
    [dict setObject:StrMoble forKey:@"mobile"];
    [self.view addSubview:ind];
    [[ApiClient sharedInstance] sendMobleNum:dict success:^(id responseObject) {
        [ind removeFromSuperview];
       [AlertView showAlertWithMessage:@"OTP sent successfully."];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}




#pragma mark - Push Notifications

- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}

#pragma mark - NotificationServiceDelegate protocol

- (void)notificationServiceDidStartLoadingDialogFromServer {
    //[SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_DIALOG", nil) maskType:SVProgressHUDMaskTypeClear];
}

- (void)notificationServiceDidFinishLoadingDialogFromServer {
    //  [SVProgressHUD dismiss];
}

- (void)notificationServiceDidSucceedFetchingDialog:(QBChatDialog *)chatDialog {
    //    DialogsViewController *dialogsController = (DialogsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DialogsViewController"];
    //    ChatViewController *chatController = (ChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    //    chatController.dialog = chatDialog;
    //
    //    self.navigationController.viewControllers = @[dialogsController, chatController];
}

- (void)notificationServiceDidFailFetchingDialog {
    // TODO: maybe segue class should be ReplaceSegue?
    //  [self performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];
}

@end
