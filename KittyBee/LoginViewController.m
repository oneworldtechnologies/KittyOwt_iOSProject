//
//  LoginViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 31/03/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "LoginViewController.h"
#import "OTPViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
@interface LoginViewController (){
    BOOL doneCancleKeyBoard;
    IndecatorView *ind;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
//    NSLog(@"Fonts%@",[UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    [self resignKeyBoard];
ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
self.navigationController.navigationBarHidden=YES;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtMobleNo.inputAccessoryView = numberToolbar;
    self.btnSignUp.layer.cornerRadius=4;
    doneCancleKeyBoard=NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.txtMobleNo resignFirstResponder];
}
- (IBAction)cmdSignUp:(id)sender {
    [self resignKeyBoard];
    NSString *strMobNum=[self.txtMobleNo.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strMobNum.length==10){
        [self sendMobileNum];
    }else if(strMobNum.length>10){
         [AlertView showAlertWithMessage:@"Please Enter valid 10-digit Mobile Number."];
    }else{
         [AlertView showAlertWithMessage:@"Please Enter valid 10-digit Mobile Number."];
    }
}
-(BOOL )showBaseMenu{
    return YES;
}
-(void)cancelNumberPad{
    doneCancleKeyBoard=NO;
    self.txtMobleNo.text=@"";
    [self resignKeyBoard];
}
-(void)doneWithNumberPad{
    doneCancleKeyBoard=NO;
    [self resignKeyBoard];
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
    // Prevent invalid character input, if keyboard is numberpad
    if (textField.keyboardType == UIKeyboardTypePhonePad)
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

- (void)keyboardWillShow:(NSNotification*)notification{
   CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         if([notification.name isEqualToString:@"UIKeyboardWillShowNotification"]){
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
    [self.txtMobleNo resignFirstResponder];

}
-(void)sendMobileNum{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.txtMobleNo.text forKey:@"mobile"];
    [self.view addSubview:ind];
    [[ApiClient sharedInstance] sendMobleNum:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        OTPViewController* controller = [[OTPViewController alloc] initWithNibName:@"OTPViewController" bundle:nil];
        controller.dictData=dict;
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
         [AlertView showAlertWithMessage:errorString];
    }];
}

@end
