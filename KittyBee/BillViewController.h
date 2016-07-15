//
//  BillViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BillViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTotalMember;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalCollection;
@property (weak, nonatomic) IBOutlet UITextField *txtAdvancePaid;
@property (weak, nonatomic) IBOutlet UITextField *txtGames;
@property (weak, nonatomic) IBOutlet UITextField *txtBillAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtPreviousBalance;
@property (weak, nonatomic) IBOutlet UITextField *txtcarryForward;
@property (weak, nonatomic) IBOutlet UITextField *txtBalance;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet AsyncImageView *imgBill;

- (IBAction)cmdUploadBill:(id)sender;
- (IBAction)cmdSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (strong,nonatomic) NSString *group_id;
@property (strong,nonatomic) NSString *kitty_id;
@end
