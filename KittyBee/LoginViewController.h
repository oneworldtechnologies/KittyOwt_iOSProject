//
//  LoginViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 31/03/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController :UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtMobleNo;
- (IBAction)cmdSignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@end
