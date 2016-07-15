//
//  VenuViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenuViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtVenue;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UITextField *txtPunctualityTime;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDressCode;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAdditional;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)cmdTime:(id)sender;
- (IBAction)cmdPunctualityTime:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *txtVenuIntro;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;
- (IBAction)cmdDate:(id)sender;
- (IBAction)cmdPuncunalityTime2:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPuncunalityTime2;
@property (weak, nonatomic) IBOutlet UIButton *btnPuncunalityTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPuncunalityTime2;

- (IBAction)cmdSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

//Data for setting Venu
@property (strong,nonatomic) NSString *kittyDate;
@property (strong,nonatomic) NSString *punctuality;
@property (strong,nonatomic) NSString *punctualityTime;
@property (strong,nonatomic) NSString *punctualityTime2;
@property (strong,nonatomic) NSString *kittyId;
@property (strong,nonatomic) NSString *kittytime;
@property (strong,nonatomic) NSString *venuSet;
@property (strong,nonatomic) NSString *groupId;
@property (strong,nonatomic) NSString *name;
@end
