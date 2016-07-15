//
//  MyProfileViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 26/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet AsyncImageView *myProfileImg;
@property (weak, nonatomic) IBOutlet AsyncImageView *husbandImg;
@property (weak, nonatomic) IBOutlet AsyncImageView *familyImg;
@property (weak, nonatomic) IBOutlet UIView *myProfileView;
@property (weak, nonatomic) IBOutlet UIView *husbandView;
@property (weak, nonatomic) IBOutlet UIView *familyView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
@property (strong, nonatomic) NSString *strOtherPersonProfile;
@property (strong, nonatomic) NSString *strOtherPersonName;
- (IBAction)cmdCall:(id)sender;
- (IBAction)cmdText:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)cmdSubmit:(id)sender;

@end
