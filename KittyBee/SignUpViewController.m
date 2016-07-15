//
//  SignUpViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "ServicesManager.h"
#import "UsersDataSource.h"
#import "AppDelegate.h"
#import <Quickblox/QBASession.h>

@interface SignUpViewController ()<NotificationServiceDelegate>{
    BOOL  selectedDOB;
    int ButtonImage;
    NSMutableArray *arryContact;
    IndecatorView *ind;


}
@property (strong, nonatomic) UsersDataSource *dataSource;
@property (nonatomic, assign, getter=isUsersAreDownloading) BOOL usersAreDownloading;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cmdgmailLogin:)
                                                 name:@"gmailLogin"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight<568){
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight+130);
    }else if(screenHeight>568){
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight);
    }else{
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight+30);
    }
    ButtonImage=0;
    self.btnProfilePic.layer.cornerRadius=25;
    self.btnCouplePic.layer.cornerRadius=25;
    self.btnFamilyPic.layer.cornerRadius=25;
    self.btnFamilyPic.clipsToBounds=YES;
    self.btnCouplePic.clipsToBounds=YES;
    self.btnProfilePic.clipsToBounds=YES;
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];

   // [self askPermissionContact];
    [self changePlaceHolder];
}

- (void)cmdgmailLogin:(NSNotification *)notification
{
    NSMutableDictionary *dict = [[notification userInfo] mutableCopy];
    [dict setObject:self.strPhoneNum forKey:@"phone"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *deviseId= [prefs stringForKey:@"deviceTokenStrKey"];
    if(deviseId){
        [dict setObject:deviseId forKey:@"deviceID"];
    }else{
        [dict setObject:@"" forKey:@"deviceID"];
    }
 [dict setObject:@"ios" forKey:@"deviceType"];
    [self.view addSubview:ind];
    
   
    [[ApiClient sharedInstance]getGmailRegister:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *DictResponce= responseObject;
        NSString *userid=[DictResponce objectForKey:@"userID"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userid forKey:@"USERID"];
        [defaults setObject:[DictResponce objectForKey:@"name"] forKey:@"UserName"];
        [defaults setObject:[DictResponce objectForKey:@"profilePic"] forKey:@"profilePic"];
        [defaults setObject:[DictResponce objectForKey:@"phone"] forKey:@"phone"];
        [defaults setObject:[DictResponce objectForKey:@"status"] forKey:@"status"];
        [defaults synchronize];
        [self makeQuickBloxUser];
        //self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];


    
}

- (IBAction)cmdSignUp:(id)sender {
    [self retrunView];
    NSString *StrDOB=self.txtDateOfBirth.text;
    if(!([StrDOB isEqualToString:@""])){
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *date=[dateFormatter dateFromString:StrDOB];
        NSDate *now = [NSDate date];
        if([date compare:now]==NSOrderedDescending){
            [AlertView showAlertWithMessage:@"DOB must less than current date."];
            return;
        }
    }
      NSString *StrDOA=self.txtDateOfAniversary.text;
    if(!([StrDOB isEqualToString:@""])){
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *date=[dateFormatter dateFromString:StrDOA];
        NSDate *now = [NSDate date];
        if([date compare:now]==NSOrderedDescending){
            [AlertView showAlertWithMessage:@"DOA must less than current date."];
            return;
        }
    }
    
    NSMutableDictionary *dict=[self getDict];
    if(dict){
        [self.view addSubview:ind];
        [[ApiClient sharedInstance]getRegister:dict success:^(id responseObject) {
            // Store the data
            NSDictionary *DictResponce= responseObject;
         //   NSString*strMessage=[DictResponce objectForKey:@"message"];
            NSString *userid=[DictResponce objectForKey:@"userID"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userid forKey:@"USERID"];
            [defaults setObject:[DictResponce objectForKey:@"name"] forKey:@"UserName"];
            [defaults setObject:[DictResponce objectForKey:@"profilePic"] forKey:@"profilePic"];
            [defaults setObject:[DictResponce objectForKey:@"phone"] forKey:@"phone"];
            [defaults setObject:[DictResponce objectForKey:@"status"] forKey:@"status"];
            [defaults synchronize];
            [self makeQuickBloxUser];
         //   self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
    }

}

- (IBAction)cmdFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile"]
                        fromViewController:self
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       if (error) {
                                           NSLog(@"Failed to login:%@", error);
                                           return;
                                       }
                                       
                                       [self fetchUserInfo];
                                   }];
    
}

- (IBAction)cmdGooglePlus:(id)sender {
    [[GIDSignIn sharedInstance] signIn];

}

-(void)fetchUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSDictionary *dictResult=result;
                 //  email = "rntyagi4@gmail.com";
                 //id = 1001660849920645;
                // name = "Arun Tyagi";
                 NSMutableDictionary *dict = [NSMutableDictionary new];
                 [dict setObject:[dictResult objectForKey:@"id"] forKey:@"fbID"];
                 [dict setObject:@"" forKey:@"socialType"];
                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                 NSString *deviseId= [prefs stringForKey:@"deviceTokenStrKey"];
                 if(deviseId){
                      [dict setObject:deviseId forKey:@"deviceID"];
                 }else{
                      [dict setObject:@"" forKey:@"deviceID"];
                 }
                
                 [dict setObject:self.strPhoneNum forKey:@"phone"];
                 NSString *strPicLink=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[dictResult objectForKey:@"id"]];
                 [dict setObject:strPicLink forKey:@"profilePic"];
                 
                 [dict setObject:[dictResult objectForKey:@"name"] forKey:@"name"];//email
                 [dict setObject:[dictResult objectForKey:@"email"] forKey:@"email"];
                 [dict setObject:@"ios" forKey:@"deviceType"];
                 [self.view addSubview:ind];
                 
                 [[ApiClient sharedInstance]getFBRegister:dict success:^(id responseObject) {
                     // [ind removeFromSuperview];
                      NSDictionary *DictResponce= responseObject;
                      NSString *userid=[DictResponce objectForKey:@"userID"];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:userid forKey:@"USERID"];
                     [defaults setObject:[DictResponce objectForKey:@"name"] forKey:@"UserName"];
                     [defaults setObject:[DictResponce objectForKey:@"profilePic"] forKey:@"profilePic"];
                     [defaults setObject:[DictResponce objectForKey:@"phone"] forKey:@"phone"];
                     [defaults setObject:[DictResponce objectForKey:@"status"] forKey:@"status"];
                     [defaults synchronize];
                     [self makeQuickBloxUser];
                   //  self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
                 } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                     [ind removeFromSuperview];
                     [AlertView showAlertWithMessage:errorString];
                     
                 }];
                 
                 NSLog(@"Result %@",result);
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}

#pragma mark ---------- Text Feild delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textField==self.txtName){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtCity){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtEmail){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -10, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtAddress){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField==self.txtDateOfBirth){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -90, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField== self.txtDateOfAniversary){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -170, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
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
    if(self.txtCity==textField){
        if([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound){
            const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            
            if (isBackSpace == -8) {
                return YES;
            }
            return NO;
        }else{
            return YES;
        }
        
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self retrunView];
   [textField resignFirstResponder];
    return YES;
}
-(void)retrunView{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
}

-(NSMutableDictionary *)getDict{
    NSString *strName=[self.txtName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(!(strName.length<3)){
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:self.txtName.text forKey:@"name"];
        [dict setObject:self.txtCity.text forKey:@"city"];
        NSString *strEmail=[self.txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(strEmail.length==0){
            [dict setObject:self.txtEmail.text forKey:@"email"];
        }else{
            if([self NSStringIsValidEmail:self.txtEmail.text]){
                [dict setObject:self.txtEmail.text forKey:@"email"];
            }else{
                [AlertView showAlertWithMessage:@"Please enter a valid email."];
                return nil;
            }
        }
        [dict setObject:self.txtAddress.text forKey:@"address"];
        
        [dict setObject:self.txtDateOfBirth.text forKey:@"dob"];
        [dict setObject:self.txtDateOfAniversary.text forKey:@"doa"];
        
        UIImage *imgProfile = [self.btnProfilePic imageForState:UIControlStateNormal];
        UIImage *imgHusaband = [self.btnCouplePic imageForState:UIControlStateNormal];
        UIImage *imgFamily = [self.btnFamilyPic imageForState:UIControlStateNormal];
        
        NSData *dataCheck=UIImageJPEGRepresentation([UIImage imageNamed:@"upload_imgSingUp"], 0.6);
        
        NSData *dataForProfile = UIImageJPEGRepresentation(imgProfile, 0.6f);
        NSData *dataForHusaband = UIImageJPEGRepresentation(imgHusaband, 0.6f);
        NSData *dataForFamily = UIImageJPEGRepresentation(imgFamily, 0.6f);
        NSString *myProfileBase64String;
        if([dataCheck isEqual:dataForProfile]){
            myProfileBase64String = @"";
        }else{
             myProfileBase64String = [dataForProfile base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }
       
        NSString *husbandBase64String;
        if([dataCheck isEqual:dataForHusaband]){
            husbandBase64String = @"";
        }else{
            husbandBase64String = [dataForHusaband base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }

        NSString *familyBase64String;
        if([dataCheck isEqual:dataForFamily]){
            familyBase64String = @"";
        }else{
            familyBase64String = [dataForFamily base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }
        
        [dict setObject:myProfileBase64String forKey:@"profile"];
        [dict setObject:familyBase64String forKey:@"family"];
        [dict setObject:husbandBase64String forKey:@"couple"];
        [dict setObject:self.strPhoneNum forKey:@"phone"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *deviseId= [prefs stringForKey:@"deviceTokenStrKey"];
        if(deviseId){
            [dict setObject:deviseId forKey:@"deviceID"];
        }else{
            [dict setObject:@"" forKey:@"deviceID"];
        }
        [dict setObject:@"ios" forKey:@"deviceType"];
        return dict;
    }else{
        [AlertView showAlertWithMessage:@"Please enter your name with atleast 3 characters."];
        return nil;
    }
}
-(void)changePlaceHolder{
    self.btnSignUp.layer.cornerRadius=4;
    [self placeholderValue:self.txtName textPlaceHold:@"Name*"];
    [self placeholderValue:self.txtCity textPlaceHold:@"City"];
    [self placeholderValue:self.txtEmail textPlaceHold:@"Email"];
    [self placeholderValue:self.txtAddress textPlaceHold:@"Address"];
    [self placeholderValue:self.txtDateOfBirth textPlaceHold:@"Birthday"];
    [self placeholderValue:self.txtDateOfAniversary textPlaceHold:@"Aniversary"];
}

-(void)placeholderValue:(UITextField *)txtFeild textPlaceHold:(NSString *)textPlaceHold{
    UIColor *color=[UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    txtFeild.attributedPlaceholder=[[NSAttributedString alloc] initWithString:textPlaceHold attributes:@{NSForegroundColorAttributeName: color}];

}

- (IBAction)cmdDOB:(id)sender {
    selectedDOB=YES;
    [self addDatePiker];
    
}
- (IBAction)cmdDOA:(id)sender {
    selectedDOB=NO;
    [self addDatePiker];
}

- (void)dismissDatePicker1:(id)sender {
    if(selectedDOB){
        self.txtDateOfBirth.text=@"";
    }else{
        self.txtDateOfAniversary.text=@"";
    }

    [self dismissDatePicker:sender];
}
- (void)dismissDatePicker:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, screenRect.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, screenRect.size.width, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}
- (void)changeDate:(UIDatePicker *)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = sender.date;
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    if(selectedDOB){
        self.txtDateOfBirth.text=[dateFormatter stringFromDate:yourDate];
    }else{
         self.txtDateOfAniversary.text=[dateFormatter stringFromDate:yourDate];
    }
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

-(void)addDatePiker{
    [self retrunView];
    [self.view endEditing:YES];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, screenRect.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, screenRect.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    // darkView.alpha = 1;
    // [darkView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, screenRect.size.width, 216)] ;
    datePicker.tag = 10;
    NSDate *now = [NSDate date];
    int daysToAdd = -1;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
  //  datePicker.maximumDate=newDate1;
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, screenRect.size.width, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;
    UIBarButtonItem *CancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePicker1:)] ;
    [toolBar setItems:[NSArray arrayWithObjects: CancelButton,spacer,doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    [darkView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [UIView commitAnimations];

}

- (IBAction)cmdProfilePic:(id)sender {
    ButtonImage=1;
    [self showActionSheet];
}

- (IBAction)cmdFamilyPic:(id)sender {
    ButtonImage=2;
    [self showActionSheet];

}

- (IBAction)cmdCouplePic:(id)sender {
    ButtonImage=3;
    [self showActionSheet];

}


-(void)showActionSheet{
    [self retrunView];

    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
}

#pragma mark ---------- Action sheet delegate ------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;

    if(buttonIndex==0){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }else if(buttonIndex==1){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }
}

#pragma mark ---------- imagePickerController delegate ------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if(ButtonImage==1){
        [self.btnProfilePic setImage:chosenImage forState:UIControlStateNormal];
    }else if(ButtonImage==2){
        [self.btnFamilyPic setImage:chosenImage forState:UIControlStateNormal];
    }else if(ButtonImage==3){
        [self.btnCouplePic setImage:chosenImage forState:UIControlStateNormal];
    }
     [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark contactFetch

-(void)askPermissionContact{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [Alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getAllContacts];
    }
    else {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable Goto Setting >> KittyBee >> allow access to contact " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [Alert show];
        
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
}
- (void)getAllContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            //contacts.firstNames = [(__bridge NSString*)firstName copy];
            NSString *FirstName=[(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            //contacts.lastNames = [(__bridge NSString*)lastName copy];
            NSString *LastName=[(__bridge NSString*)lastName copy];
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!FirstName) {
                FirstName = @"";
            }
            
            if (!LastName) {
                LastName = @"";
            }
            
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", FirstName, LastName];
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            NSMutableDictionary * details=[[NSMutableDictionary alloc]init];
            [details setObject:strFullName forKey:@"ContactName"];
            [details setObject:phoneNumbers forKey:@"phoneNumbers"];
                       [items addObject:details];
            
#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
            
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
    arryContact=items;
    NSLog(@"%@",items);
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
                    // [dict setObject:[NSString stringWithFormat:@"%@",saveUser.updatedAt] forKey:@"updatedat"];
                    //  [dict setObject:[NSString stringWithFormat:@"%@",saveUser.createdAt] forKey:@"created_at"];
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
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
                        [AlertView showAlertWithMessage:errorString];
                    }];

                    
                    
                    
                } else {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
                    // [AlertView showAlertWithMessage:@"Hellooo"];
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
        
        
        NSString *strCheck=[response.error description];
        if ([strCheck rangeOfString:@"has already been taken"].location == NSNotFound) {
            [ind removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
            [AlertView showAlertWithMessage:[response.error description]];
            
        }else{
            [self quickBloxLogin];
        }
        
//        NSLog(@"Errors=%@", [response.error description]);
//        [ind removeFromSuperview];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
//        [AlertView showAlertWithMessage:[response.error description]];
        
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
