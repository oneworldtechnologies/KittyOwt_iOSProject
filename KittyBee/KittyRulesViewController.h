//
//  KittyRulesViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/QBASession.h>
#import "ServicesManager.h"

@interface KittyRulesViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UITextField *txtKittyAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnKittyWeekName;
@property (weak, nonatomic) IBOutlet UIButton *btnKittyWeek;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDate;
- (IBAction)cmdKittyWeekName:(id)sender;
- (IBAction)cmdKittyWeek:(id)sender;
- (IBAction)cmdDate:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCategories;
- (IBAction)cmdCategories:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddKids;
- (IBAction)cmdAddKids:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtTime;

@property (weak, nonatomic) IBOutlet UIButton *btnFine;
- (IBAction)cmdFine:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPunctuality;
- (IBAction)cmdPunctuality:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHost;
- (IBAction)cmdHost:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFineValue;
@property (weak, nonatomic) IBOutlet UITextField *txtPunctualityAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtPuncunalityTime;


@property (weak, nonatomic) IBOutlet UIButton *btnFoodMoneyHost;
- (IBAction)cmdFoodMoneyHost:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFoodMoneyDutch;
- (IBAction)cmdFoodMoneyDutch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFoodMoneyFixed;
- (IBAction)cmdFoodMoneyFixed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFoodMoney;


@property (weak, nonatomic) IBOutlet UIButton *btnDrinkHost;
- (IBAction)cmdDrinkHost:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDrinkDutch;
- (IBAction)cmdDrinkDutch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDrinkFixed;
- (IBAction)cmdDrinkFixed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnGames;
- (IBAction)cmdGames:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectGames;
- (IBAction)cmdSelectGames:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnTambolaMinus;
- (IBAction)cmdTambolaMinus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTambolaValue;
@property (weak, nonatomic) IBOutlet UIButton *btnTambolaPlus;
- (IBAction)cmdTambolaPlus:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtTambolaPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnNormalMinus;
- (IBAction)cmdNormalMinus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNormalValue;
@property (weak, nonatomic) IBOutlet UIButton *btnNormalPlus;
- (IBAction)cmdNormalPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNoramalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateDestination;
- (IBAction)cmdCreateDestination:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtviewCreateDestination;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
- (IBAction)cmdTime:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPunctualityTime;

- (IBAction)cmdPunctualityTime:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnpunctualityTime2;
- (IBAction)cmdPunctualityTime2:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPuncunalityAmount2;
@property (weak, nonatomic) IBOutlet UITextField *txtPuncunalityTime2;

@property (weak, nonatomic) IBOutlet UITextField *txtDrinkMoney;

//createGroup Data

@property (strong,nonatomic) NSArray *arryGroupMember;
@property (strong,nonatomic) UIImage *imgGroup;
@property (strong,nonatomic) NSString *strGroupName;
@property (strong,nonatomic) NSString *strKittyType;
@property (strong,nonatomic) NSString *strInMiddelKitty;
@property (strong,nonatomic) NSString *strNoOfHost;
@property (strong,nonatomic) NSString *strMakingkitty;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong,nonatomic) NSString *strGroupId;

//getrules
@property (strong,nonatomic) NSString *isAdmin;
@property (strong,nonatomic) NSString *groupId;

- (IBAction)cmdSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstkittyDate;
- (IBAction)cmdFirstKittyDate:(id)sender;


@end
