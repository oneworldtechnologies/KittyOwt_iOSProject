//
//  OTPViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtOTP;
- (IBAction)cmdLogin:(id)sender;
- (IBAction)cmdResendOTP:(id)sender;
- (IBAction)cmdBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) NSDictionary *dictData;
@end
