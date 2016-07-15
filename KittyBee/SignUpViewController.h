//
//  SignUpViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfAniversary;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cmdSignUp:(id)sender;
- (IBAction)cmdFacebook:(id)sender;
- (IBAction)cmdGooglePlus:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDOB;
@property (weak, nonatomic) IBOutlet UIButton *btnDOA;
- (IBAction)cmdDOB:(id)sender;
- (IBAction)cmdDOA:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *btnFamilyPic;
@property (weak, nonatomic) IBOutlet UIButton *btnCouplePic;
- (IBAction)cmdProfilePic:(id)sender;
- (IBAction)cmdFamilyPic:(id)sender;
- (IBAction)cmdCouplePic:(id)sender;

@property (strong, nonatomic) NSString *strPhoneNum;
@end
