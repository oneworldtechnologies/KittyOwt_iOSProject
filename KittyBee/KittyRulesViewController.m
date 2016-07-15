//
//  KittyRulesViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "KittyRulesViewController.h"
#import "kidsViewController.h"
#import "SelectCoupleViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "HomeViewController.h"
@interface KittyRulesViewController (){
    int timeSetForText;
    NSString *strFoodMoney;
    NSString *strDrinksMoney;
    IndecatorView *ind;
    NSMutableArray *arryNoOfChild;
    NSMutableArray *arrTotalCouple;
    NSMutableArray *arrselectedCouple;
    NSMutableArray *arryNotSelectedMember;
}

@end

@implementation KittyRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtviewCreateDestination.text = @"Add additional note here...";
    self.txtviewCreateDestination.textColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addKids:)
                                                 name:@"AddkidsToKittyRulesPage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCouple:)
                                                 name:@"AddCouplesToKittyRulesPage"
                                               object:nil];
    
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)addCouple:(NSNotification *) notification {// used to get data from couple page
    NSDictionary *dict=[notification userInfo];
    arrTotalCouple=[dict objectForKey:@"Couple"];// couple that are paired with each other
    arryNotSelectedMember=[dict objectForKey:@"notSelectedCouple"];// in couple kitty  that are single
    arrselectedCouple=[dict objectForKey:@"Couple"];// couple that are paired with each other same as above one
    NSLog(@"dict %@",arrTotalCouple);
    NSLog(@"dict %@",arrselectedCouple);
}

- (void)addKids:(NSNotification *) notification {// adding kids number for members form add kids page
    NSDictionary *dict=[notification userInfo];
    arryNoOfChild=[[dict objectForKey:@"KidsValue"] mutableCopy];
    NSMutableArray *arrData=[[NSMutableArray alloc]init];
    for (int i =0; i<self.arryGroupMember.count; i++) {
        NSMutableDictionary *dict=[[self.arryGroupMember objectAtIndex:i] mutableCopy];
        [dict setObject:[arryNoOfChild objectAtIndex:i]forKey:@"kids"];
        [arrData addObject:dict];
    }
    self.arryGroupMember=arrData;
    NSLog(@"dict %@",self.arryGroupMember);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"KITTY RULES";
    strFoodMoney=@"Host";
    strDrinksMoney=@"Host";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    
    if(SCREEN_SIZE.height<568){
        self.ScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+610);
    }else if(SCREEN_SIZE.height>567 && SCREEN_SIZE.height<667 ){
        self.ScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+590);
    }else if(SCREEN_SIZE.height>666 && SCREEN_SIZE.height<670){
        self.ScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+430);
    }else{
        self.ScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+380);
    }
    
    timeSetForText=0;
    [self firstKittyDate:@"0"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self btnAddlayers];
    if([self.isAdmin isEqualToString:@"1"]){//show button for admin else no
        self.btnSubmit.hidden=NO;
        self.btnAddKids.hidden=YES;
        self.btnFirstkittyDate.userInteractionEnabled=NO;
        [self.btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
        [self getRules];
    }else if([self.isAdmin isEqualToString:@"0"]){
        self.btnSubmit.hidden=YES;
        self.btnAddKids.hidden=YES;
        
        self.btnFirstkittyDate.userInteractionEnabled=NO;
        [self getRules];
    }
    if(!(self.isAdmin)){// setting kitty type and current time during making group
        if([self.strKittyType isEqualToString:@"Couple Kitty"]){
            self.btnSubmit.hidden=NO;
            [self setTitle:self.btnCategories title:@"Couple Kitty"];
            [self.btnAddKids setTitle:@"Add Couple" forState:UIControlStateNormal];
        }else if([self.strKittyType isEqualToString:@"Kitty with Kids"]){
            [self setTitle:self.btnCategories title:@"Kitty with Kids"];
            [self.btnAddKids setTitle:@"Add Kids" forState:UIControlStateNormal];
        }else if([self.strKittyType isEqualToString:@"Normal Kitty"]){
            [self setTitle:self.btnCategories title:@"Normal Kitty"];
            self.btnAddKids.hidden=YES;
        }
        NSDate *date = [NSDate date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"hh:mm a";
        NSString *dateString = [timeFormatter stringFromDate:date];
        self.txtTime.text=dateString;
    }
}

#pragma mark All Xib button
- (IBAction)cmdKittyWeekName:(id)sender {
    [self hideKeyBoard];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    [alert show];
}


- (IBAction)cmdKittyWeek:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"1st",@"2nd",@"3rd",@"4th",nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}


- (IBAction)cmdDate:(id)sender {
    timeSetForText=4;
    [self addDatePicker:UIDatePickerModeDate];
    
}

- (void)dismissDatePicker:(id)sender {// picker of date time is removed here
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
    NSLog(@"New Date: %@", sender.date);
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";
    NSString *dateString = [timeFormatter stringFromDate: sender.date];
    
    if(timeSetForText==1){// for add time for kitty
        self.txtTime.text=dateString;
    }else if(timeSetForText==2){// for puncunality 1 time
        NSDate *dateTime=[timeFormatter dateFromString:self.txtTime.text];
        NSDate *CurrentdateTime=[timeFormatter dateFromString:dateString];
        if([dateTime compare:CurrentdateTime]== NSOrderedAscending){//checking kitty time is less than puncunality time
            self.txtPuncunalityTime.text=dateString;
        }else{
            [AlertView showAlertWithMessage:@"Punctuality time must be grater than Kitty Time."];
        }
    }else if(timeSetForText==3){// for puncunality 2 time
        NSDate *dateTime=[timeFormatter dateFromString:self.txtTime.text];
        NSDate *CurrentdateTime=[timeFormatter dateFromString:dateString];
        if([dateTime compare:CurrentdateTime]== NSOrderedAscending){//checking kitty time is less than puncunality time and also for punculatiy 2
            NSDate *pun2=[timeFormatter dateFromString:self.txtPuncunalityTime.text];
            if([pun2 compare:CurrentdateTime]== NSOrderedAscending){
                self.txtPuncunalityTime2.text=dateString;
            }else{
                [AlertView showAlertWithMessage:@"Punctuality2 time must be grater than Punctuality1 Time."];
            }
        }else{
            [AlertView showAlertWithMessage:@"Punctuality time must be grater than Kitty Time."];
            
        }
    }else if(timeSetForText==4){//add date for kitty
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = sender.date;
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
        NSString *strDate=[NSString stringWithFormat:@"  First kitty : %@",[dateFormatter stringFromDate:yourDate]];
        if(!([self.isAdmin isEqualToString:@"1"])){
            NSString *strFirstDate=[NSString stringWithFormat:@"%@(1st Kitty)",[dateFormatter stringFromDate:yourDate]];
            [self.btnFirstkittyDate setTitle:strFirstDate  forState:UIControlStateNormal];
        }
        
        [self.btnKittyWeek setTitle:strDate forState:UIControlStateNormal];
        self.txtPuncunalityTime.text=@"";
        self.txtPuncunalityTime2.text=@"";
        [self.btnKittyWeekName setTitle:@"Monthly" forState:UIControlStateNormal];
    }else if(timeSetForText==5){
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = sender.date;
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
        if(!([self.isAdmin isEqualToString:@"1"])){
            [self.btnFirstkittyDate setTitle:[NSString stringWithFormat:@"%@(1st Kitty)",[dateFormatter stringFromDate:yourDate]]  forState:UIControlStateNormal];
        }
    }
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (IBAction)cmdCategories:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Couple Kitty",@"Kitty with Kids",@"Normal Kitty",nil];
    actionSheet.tag=6;
    [actionSheet showInView:self.view];
    
}
- (IBAction)cmdAddKids:(id)sender {
    NSString *buttonName = [self.btnCategories titleForState:UIControlStateNormal];
    NSMutableArray *arryKidsValue;
    if(!(arryNoOfChild)){
        arryKidsValue = [NSMutableArray array];
        for (int i=0; i<self.arryGroupMember.count; i++) {
            [arryKidsValue addObject:@"00"];
        }
    }
    if([buttonName isEqualToString:@"  Couple Kitty"]){ // if kitty is of couple type
        SelectCoupleViewController* controller = [[SelectCoupleViewController alloc] initWithNibName:@"SelectCoupleViewController" bundle:nil];
        if(arrselectedCouple){
            controller.totalMember=[self.arryGroupMember mutableCopy];
            controller.arrMember=arryNotSelectedMember;
            controller.arryCoupleSlelected=arrselectedCouple;
        }else{
            controller.arrMember=[self.arryGroupMember mutableCopy];
            controller.totalMember=[self.arryGroupMember mutableCopy];
        }
        
        controller.strMakingkitty=self.strMakingkitty;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if([buttonName isEqualToString:@"  Kitty with Kids"]){// if kitty is of kids type
        kidsViewController* controller = [[kidsViewController alloc] initWithNibName:@"kidsViewController" bundle:nil];
        controller.arrMember=self.arryGroupMember;
        if(!(arryNoOfChild)){
            controller.arryKidsValue=arryKidsValue;
        }else{
            controller.arryKidsValue=arryNoOfChild;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)cmdFine:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Yes",@"No",nil];
    actionSheet.tag=3;
    [actionSheet showInView:self.view];
    
}
- (IBAction)cmdPunctuality:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"00 ",@"01",@"02",nil];
    actionSheet.tag=4;
    [actionSheet showInView:self.view];
}
- (IBAction)cmdHost:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"01 ",@"02",@"03",nil];
    actionSheet.tag=5;
    [actionSheet showInView:self.view];
}
- (IBAction)cmdFoodMoneyHost:(id)sender {
    [self hideKeyBoard];
    strFoodMoney=@"Host";
    [self changeFoodMoney];
    [self.btnFoodMoneyHost setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    
}
- (IBAction)cmdFoodMoneyDutch:(id)sender {
    [self hideKeyBoard];
    [self changeFoodMoney];
    strFoodMoney=@"Dutch";
    [self.btnFoodMoneyDutch setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
}
- (IBAction)cmdFoodMoneyFixed:(id)sender {
    [self hideKeyBoard];
    strFoodMoney=@"Fixed";
    [self changeFoodMoney];
    [self.btnFoodMoneyFixed setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
}


- (IBAction)cmdDrinkHost:(id)sender {
    [self hideKeyBoard];
    strDrinksMoney=@"Host";
    [self changeDrinkMoney];
    [self.btnDrinkHost setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    
}
- (IBAction)cmdDrinkDutch:(id)sender {
    [self hideKeyBoard];
    strDrinksMoney=@"Dutch";
    [self changeDrinkMoney];
    [self.btnDrinkDutch setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    
}
- (IBAction)cmdDrinkFixed:(id)sender {
    [self hideKeyBoard];
    strDrinksMoney=@"Fixed";
    [self changeDrinkMoney];
    [self.btnDrinkFixed setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    
}

-(void)changeDrinkMoney{
    [self hideKeyBoard];
    
    [self.btnDrinkHost setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnDrinkDutch setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnDrinkFixed setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}

-(void)changeFoodMoney{
    [self hideKeyBoard];
    
    [self.btnFoodMoneyHost setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnFoodMoneyDutch setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnFoodMoneyFixed setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
-(void)btnAddlayers{
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPuncunalityAmount2.inputAccessoryView = numberToolbar;
    self.txtPunctualityAmount.inputAccessoryView = numberToolbar;
    self.txtKittyAmount.inputAccessoryView = numberToolbar;
    self.txtFineValue.inputAccessoryView = numberToolbar;
    self.txtFoodMoney.inputAccessoryView = numberToolbar;
    self.txtNoramalPrice.inputAccessoryView = numberToolbar;
    self.txtTambolaPrice.inputAccessoryView = numberToolbar;
    self.txtDrinkMoney.inputAccessoryView = numberToolbar;
    [self btnLayers:self.btnFine];
    [self btnLayers:self.btnHost];
    [self btnLayers:self.btnKittyWeek];
    [self btnLayers:self.btnKittyWeekName];
    [self btnLayers:self.btnCategories];
    [self btnLayers:self.btnGames];
    [self btnLayers:self.btnSelectGames];
    [self btnLayers:self.btnPunctuality];
    [self btnPlusMinus:self.btnTambolaPlus];
    [self btnPlusMinus:self.btnTambolaMinus];
    [self btnLayers: self.btnFirstkittyDate];
    self.txtviewCreateDestination.layer.borderWidth=1;
    self.txtviewCreateDestination.layer.borderColor=[UIColor colorWithRed:228/255.0 green:227/255.0 blue:227/255.0 alpha:1.0].CGColor;
    
    
}
-(void)cancelNumberPad{
    [self setView];
    [self.view endEditing:YES];
}
-(void)doneWithNumberPad{
    [self setView];
    [self.view endEditing:YES];
}

-(void)btnPlusMinus:(UIButton *)btn{
    [self hideKeyBoard];
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor =[UIColor colorWithRed:228/255.0 green:227/255.0 blue:227/255.0 alpha:1.0].CGColor;
}
-(void)btnLayers:(UIButton *)btn{
    
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius =4;
    btn.layer.borderColor =[UIColor colorWithRed:228/255.0 green:227/255.0 blue:227/255.0 alpha:1.0].CGColor;
    
}
- (IBAction)cmdGames:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Yes",@"No",nil];
    actionSheet.tag=7;
    [actionSheet showInView:self.view];
}
- (IBAction)cmdSelectGames:(id)sender {
    [self hideKeyBoard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Tambola",@"Normal",@"Tambola + Normal",nil];
    actionSheet.tag=8;
    [actionSheet showInView:self.view];
}

#pragma mark PlusMinus for game
- (IBAction)cmdTambolaMinus:(id)sender {
    [self.view endEditing:YES];
    [self setView];
    int gameValue=[self.lblTambolaValue.text intValue];
    if(gameValue<=1){
        [AlertView showAlertWithMessage:@"Num of game can't be zero"];
        [self.btnTambolaPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnTambolaMinus setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        [self.btnTambolaMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnTambolaPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        gameValue--;
        self.lblTambolaValue.text=[NSString stringWithFormat:@"%d",gameValue];
    }
    
}
- (IBAction)cmdTambolaPlus:(id)sender {
    [self.view endEditing:YES];
    [self setView];
    int gameValue=[self.lblTambolaValue.text intValue];
    if(gameValue>=10){
        [self.btnTambolaMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnTambolaPlus setBackgroundColor:[UIColor lightGrayColor]];
        
        [AlertView showAlertWithMessage:@"Num of game can't be greater than 10"];
    }else{
        gameValue++;
        [self.btnTambolaMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnTambolaPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        self.lblTambolaValue.text=[NSString stringWithFormat:@"%d",gameValue];
    }
    
}

- (IBAction)cmdNormalMinus:(id)sender {
    [self.view endEditing:YES];
    [self setView];
    int gameValue=[self.lblNormalValue.text intValue];
    if(gameValue<=1){
        [AlertView showAlertWithMessage:@"Num of game can't be zero"];
        [self.btnNormalPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnNormalMinus setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        [self.btnNormalMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnNormalPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        gameValue--;
        self.lblNormalValue.text=[NSString stringWithFormat:@"%d",gameValue];
    }
    
    
}

- (IBAction)cmdNormalPlus:(id)sender {
    [self.view endEditing:YES];
    [self setView];
    int gameValue=[self.lblNormalValue.text intValue];
    if(gameValue>=10){
        [self.btnNormalMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnNormalPlus setBackgroundColor:[UIColor lightGrayColor]];
        
        [AlertView showAlertWithMessage:@"Num of game can't be greater than 10"];
    }else{
        gameValue++;
        [self.btnNormalMinus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        [self.btnNormalPlus setBackgroundColor:[UIColor colorWithRed:0/225.0 green:178/225.0 blue:201/225.0 alpha:1.0]];
        self.lblNormalValue.text=[NSString stringWithFormat:@"%d",gameValue];
    }
}

#pragma mark actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag==2){
        [self addKitteWeek:buttonIndex];
    }else if(actionSheet.tag==3){
        [self addFine:buttonIndex];
    }else if(actionSheet.tag==4){
        [self addKittyPuncunality:buttonIndex];
    }else if(actionSheet.tag==5){
        [self addKittyHost:buttonIndex];
    }else if(actionSheet.tag==6){
        [self addKittyCatagory:buttonIndex];
    }else if(actionSheet.tag==7){
        [self addGames:buttonIndex];
    }else if(actionSheet.tag==8){
        [self addSelectgames:buttonIndex];
    }
    
    
}
#pragma mark Alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [self setTitle:self.btnKittyWeekName title:@"Monday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==2){
        [self setTitle:self.btnKittyWeekName title:@"Tuesday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==3){
        [self setTitle:self.btnKittyWeekName title:@"Wednesday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==4){
        [self setTitle:self.btnKittyWeekName title:@"Thrusday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==5){
        [self setTitle:self.btnKittyWeekName title:@"Friday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==6){
        [self setTitle:self.btnKittyWeekName title:@"Saturday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
        
    }else if(buttonIndex==7){
        [self setTitle:self.btnKittyWeekName title:@"Sunday"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
    }
    
    
    NSString *string = self.btnKittyWeek.titleLabel.text;
    if (!([string rangeOfString:@"First kitty :"].location == NSNotFound)) {
        [self setTitle:self.btnKittyWeek title:@"1st"];
    }
    
    
}

-(void)setTitle:(UIButton *)btn title:(NSString *)title{
    NSString *titleValee=[NSString stringWithFormat:@"  %@",title];
    [btn setTitle:titleValee forState:UIControlStateNormal];
}
-(void)addKitteWeek:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self setTitle:self.btnKittyWeek title:@"1st"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
    }else if(buttonIndex==1){
        [self setTitle:self.btnKittyWeek title:@"2nd"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
    }else if(buttonIndex==2){
        [self setTitle:self.btnKittyWeek title:@"3rd"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
    }else if(buttonIndex==3){
        [self setTitle:self.btnKittyWeek title:@"4th"];
        [self performSelector:@selector(firstKittyDate:) withObject:@"0" afterDelay:0.5];
    }
    if (!([self.btnKittyWeekName.titleLabel.text rangeOfString:@"Monthly"].location == NSNotFound)) {
        [self setTitle:self.btnKittyWeekName title:@"Monday"];
    }
    
}
-(void)addKittyCatagory:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self setTitle:self.btnCategories title:@"Couple Kitty"];
    }else if(buttonIndex==1){
        [self setTitle:self.btnCategories title:@"Kitty with Kids"];
    }else if(buttonIndex==2){
        [self setTitle:self.btnCategories title:@"Normal Kitty"];
    }
}
-(void)addFine:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        self.txtFineValue.enabled=YES;
        [self.btnFine setTitle:@"Yes" forState:UIControlStateNormal];
    }else if(buttonIndex==1){
        self.txtFineValue.enabled=NO;
        [self.btnFine setTitle:@"No" forState:UIControlStateNormal];
    }
}
-(void)addKittyPuncunality:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        self.txtPuncunalityAmount2.enabled=NO;
        self.txtPunctualityAmount.enabled=NO;
        self.txtPuncunalityTime.enabled=NO;
        self.txtPuncunalityTime2.enabled=NO;
        self.btnPunctualityTime.userInteractionEnabled=NO;
        self.btnpunctualityTime2.userInteractionEnabled=NO;
        [self.btnPunctuality setTitle:@"00" forState:UIControlStateNormal];
    }else if(buttonIndex==1){
        self.txtPuncunalityTime.enabled=YES;
        self.txtPuncunalityTime2.enabled=NO;
        self.txtPuncunalityAmount2.enabled=NO;
        self.txtPunctualityAmount.enabled=YES;
        self.btnPunctualityTime.userInteractionEnabled=YES;
        self.btnpunctualityTime2.userInteractionEnabled=NO;
        
        [self.btnPunctuality setTitle:@"01" forState:UIControlStateNormal];
    }else if(buttonIndex==2){
        self.txtPuncunalityTime.enabled=YES;
        self.txtPuncunalityTime2.enabled=YES;
        self.txtPuncunalityAmount2.enabled=YES;
        self.txtPunctualityAmount.enabled=YES;
        self.btnPunctualityTime.userInteractionEnabled=YES;
        self.btnpunctualityTime2.userInteractionEnabled=YES;
        
        [self.btnPunctuality setTitle:@"02" forState:UIControlStateNormal];
    }
}

-(void)addKittyHost:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self.btnHost setTitle:@"01" forState:UIControlStateNormal];
    }else if(buttonIndex==1){
        [self.btnHost setTitle:@"02" forState:UIControlStateNormal];
    }else if(buttonIndex==2){
        [self.btnHost setTitle:@"03" forState:UIControlStateNormal];
    }
}
-(void)addGames:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self enableDesiable:YES];
        [self setTitle:self.btnGames title:@"Yes"];
    }else if(buttonIndex==1){
        [self enableDesiable:NO];
        [self setTitle:self.btnGames title:@"No"];
    }
}
-(void)enableDesiable:(BOOL)yesno{
    self.btnSelectGames.enabled=yesno;
    self.btnNormalPlus.enabled=yesno;
    self.btnTambolaPlus.enabled=yesno;
    self.btnNormalPlus.enabled=yesno;
    self.btnTambolaMinus.enabled=yesno;
    self.txtTambolaPrice.enabled=yesno;
    self.txtNoramalPrice.enabled=yesno;
}
-(void)addSelectgames:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        self.btnNormalPlus.enabled=NO;
        self.btnTambolaPlus.enabled=YES;
        self.btnNormalPlus.enabled=NO;
        self.btnTambolaMinus.enabled=YES;
        self.txtTambolaPrice.enabled=YES;
        self.txtNoramalPrice.enabled=NO;
        [self.btnSelectGames setTitle:@"Tambola" forState:UIControlStateNormal];
    }else if(buttonIndex==1){
        
        self.btnNormalPlus.enabled=YES;
        self.btnTambolaPlus.enabled=NO;
        self.btnNormalPlus.enabled=YES;
        self.btnTambolaMinus.enabled=NO;
        self.txtTambolaPrice.enabled=NO;
        self.txtNoramalPrice.enabled=YES;
        [self.btnSelectGames setTitle:@"Normal" forState:UIControlStateNormal];
    }else if(buttonIndex==2){
        [self enableDesiable:YES];
        [self.btnSelectGames setTitle:@"Tambola + Normal" forState:UIControlStateNormal];
    }
}


- (IBAction)cmdCreateDestination:(id)sender {
    UIButton *btn=(UIButton *)sender;
    btn.selected = ![btn isSelected];
    if(!(btn.isSelected)){
        [self  setView];
        self.txtviewCreateDestination.userInteractionEnabled=NO;
        self.txtviewCreateDestination.text=@"";
        [self.btnCreateDestination setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }else{
        self.txtviewCreateDestination.userInteractionEnabled=YES;
        [self.btnCreateDestination setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
}
#pragma  mark First Kitty date

-(void)firstKittyDate:(NSString *)strCheck{
    NSString *strWeekName=self.btnKittyWeekName.titleLabel.text;
    strWeekName=[strWeekName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strWeekNumber=self.btnKittyWeek.titleLabel.text;
    strWeekNumber=[strWeekNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    //Set Wantedday here with sun=2 ..... sat=1;
    NSInteger wantedWeekDay = 3; //for monday
    if([strWeekName isEqualToString:@"Monday"]){
        wantedWeekDay = 3;
    }else if([strWeekName isEqualToString:@"Tuesday"]){
        wantedWeekDay = 4;
    }else if([strWeekName isEqualToString:@"Wednesday"]){
        wantedWeekDay = 5;
    }else if([strWeekName isEqualToString:@"Thrusday"]){
        wantedWeekDay = 6;
    }else if([strWeekName isEqualToString:@"Friday"]){
        wantedWeekDay = 7;
    }else if([strWeekName isEqualToString:@"Saturday"]){
        wantedWeekDay = 1;
    }else if([strWeekName isEqualToString:@"Sunday"]){
        wantedWeekDay = 2;
    }
    
    int weeekNumber=9;
    if([strWeekNumber isEqualToString:@"1st"]){
        weeekNumber=0;
    }else if([strWeekNumber isEqualToString:@"2nd"]){
        weeekNumber=1;
    }else if([strWeekNumber isEqualToString:@"3rd"]){
        weeekNumber=2;
    }else if([strWeekNumber isEqualToString:@"04th"]){
        weeekNumber=4;
    }
    
    //set current date here
    NSDate *currentDate = [NSDate date];
    if([strCheck isEqualToString:@"1"]){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
        [comp setMonth:comp.month+1];
        currentDate = [gregorian dateFromComponents:comp];
    }
    //get calender
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Start out by getting just the year, month and day components of the current date.
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekday fromDate:currentDate];
    // Change the Day component to 1 (for the first day of the month), and zero out the time components.
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    //get first day of current month
    NSDate *firstDateOfCurMonth = [gregorianCalendar dateFromComponents:components];
    
    
    
    
    //create new component to get weekday of first date
    NSDateComponents *newcomponents = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekday fromDate:firstDateOfCurMonth];
    NSInteger firstDateWeekDay = newcomponents.weekday;
    NSLog(@"weekday : %li",(long)firstDateWeekDay);
    
    //get last month date
    NSInteger curMonth = newcomponents.month;
    [newcomponents setMonth:curMonth+1];
    
    NSDate * templastDateOfCurMonth = [[gregorianCalendar dateFromComponents:newcomponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    
    NSDateComponents *lastcomponents = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekday fromDate:templastDateOfCurMonth];
    
    [lastcomponents setHour:0];
    [lastcomponents setMinute:0];
    [lastcomponents setSecond:0];
    
    NSDate *lastDateOfCurMonth = [gregorianCalendar dateFromComponents:lastcomponents];
    
    NSLog(@"%@",lastDateOfCurMonth);
    
    NSMutableArray *mutArrDates = [NSMutableArray array];
    
    NSDateComponents *dayDifference = [NSDateComponents new];
    [dayDifference setCalendar:gregorianCalendar];
    
    //get wanted weekday date
    NSDate *firstWeekDateOfCurMonth = nil;
    if (wantedWeekDay == firstDateWeekDay) {
        firstWeekDateOfCurMonth = firstDateOfCurMonth;
    }
    else
    {
        NSInteger day = wantedWeekDay - firstDateWeekDay;
        if (day < 0)
            day += 7;
        ++day;
        [components setDay:day];
        
        firstWeekDateOfCurMonth = [gregorianCalendar dateFromComponents:components];
    }
    
    NSLog(@"%@",firstWeekDateOfCurMonth);
    
    NSUInteger weekOffset = 0;
    NSDate *nextDate = firstWeekDateOfCurMonth;
    
    do {
        [mutArrDates addObject:nextDate];
        [dayDifference setWeekOfYear:++weekOffset];
        NSDate *date = [gregorianCalendar dateByAddingComponents:dayDifference toDate:firstWeekDateOfCurMonth options:0];
        nextDate = date;
    } while([nextDate compare:lastDateOfCurMonth] == NSOrderedAscending || [nextDate compare:lastDateOfCurMonth] == NSOrderedSame);
    if(weeekNumber==9)
        return;
    
    NSDate *weekDate;
    if(mutArrDates.count==5){
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        NSString *yourDate = [dateFormatter stringFromDate:[mutArrDates objectAtIndex:weeekNumber]];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:[mutArrDates objectAtIndex:weeekNumber]];
        NSInteger day = [components day]-1;
        if(day>15 || day==0){
            weekDate=[mutArrDates objectAtIndex:weeekNumber+1];
        }else{
            weekDate=[mutArrDates objectAtIndex:weeekNumber];
        }
        
    }else{
        weekDate=[mutArrDates objectAtIndex:weeekNumber];
    }
    
    NSDate *date = [NSDate date];
    if([date compare:weekDate]==NSOrderedDescending){
        [self firstKittyDate:@"1"];
    }else{
        // NSString *str=[mutArrDates objectAtIndex:weeekNumber];
        [self setFirstKittyDate:weekDate];
    }
    NSLog(@"%@",mutArrDates);
}
-(void)setFirstKittyDate:(NSDate *)date{
    NSLog(@"%@",date);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *yourDate = [dateFormatter stringFromDate:date];
    // dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *newString = [yourDate substringToIndex:10];
    NSDate *as=[dateFormatter dateFromString:newString];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:as];
    NSInteger day = [components day]-1; // U can add as per your requirement
    
    
    [components setDay:day];
    NSDate *NextDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSLog(@"%@",[dateFormatter stringFromDate:NextDate]);
    if(!([self.isAdmin isEqualToString:@"1"])){//(1st Kitty)
        NSString *StrFirstDate=[NSString stringWithFormat:@"%@(1st Kitty)",[dateFormatter stringFromDate:NextDate]];
        [self.btnFirstkittyDate setTitle:StrFirstDate  forState:UIControlStateNormal];
    }
}

#pragma mark ---------- Text Feild delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textField==self.txtKittyAmount){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtTime){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtFineValue){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -20, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtPunctualityAmount){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height);
                         }else if (textField==self.txtPuncunalityAmount2){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField==self.txtPuncunalityTime){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -90, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField== self.txtFoodMoney){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField== self.txtDrinkMoney){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField== self.txtTambolaPrice){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textField== self.txtNoramalPrice){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height);
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
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self  setView];
    [textField resignFirstResponder];
    return YES;
}
-(void)setView{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
}
#pragma mark ---------- Text View delegate ------------

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    if([self.txtviewCreateDestination.text isEqualToString:@"Add additional note here..."]){
        self.txtviewCreateDestination.text = @"";
    }
    
    self.txtviewCreateDestination.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textView==self.txtviewCreateDestination){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self setView];
        if(self.txtviewCreateDestination.text.length == 0){
            self.txtviewCreateDestination.textColor = [UIColor lightGrayColor];
            self.txtviewCreateDestination.text = @"Add additional note here...";
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)hideKeyBoard{
    [self.view endEditing:YES];
    [self setView];
}
- (IBAction)cmdTime:(id)sender {
    timeSetForText=1;
    [self addDatePicker:UIDatePickerModeTime];
}

-(void)addDatePicker:(UIDatePickerMode )pickerMode{
    [self hideKeyBoard];
    
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
    datePicker.datePickerMode=pickerMode;
    if(pickerMode == UIDatePickerModeDate){
        datePicker.minimumDate = [NSDate date];
        [datePicker setMinimumDate: [NSDate date]];
    }
    
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, screenRect.size.width, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;
    UIBarButtonItem *CancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePicker:)] ;
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
- (IBAction)cmdPunctualityTime:(id)sender {
    timeSetForText=2;
    [self addDatePicker:UIDatePickerModeTime];
}
- (IBAction)cmdPunctualityTime2:(id)sender {
    timeSetForText=3;
    [self addDatePicker:UIDatePickerModeTime];
}

#pragma  mark api and create group work

- (IBAction)cmdSubmit:(id)sender {
    NSString *strKittyAmount=self.txtKittyAmount.text;
    NSString *strKittyWeekDay=self.btnKittyWeekName.titleLabel.text;
    NSString *strkittyWeekNumber=self.btnKittyWeek.titleLabel.text;
    strKittyWeekDay=[strKittyWeekDay stringByReplacingOccurrencesOfString:@" " withString:@""];
    strKittyWeekDay=[strKittyWeekDay lowercaseString];
    strkittyWeekNumber=[strkittyWeekNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([strkittyWeekNumber isEqualToString:@"1st"]){
        strkittyWeekNumber=@"first";
    }else if([strkittyWeekNumber isEqualToString:@"2nd"]){
        strkittyWeekNumber=@"second";
    }else if([strkittyWeekNumber isEqualToString:@"3rd"]){
        strkittyWeekNumber=@"third";
    }else if([strkittyWeekNumber isEqualToString:@"4th"]){
        strkittyWeekNumber=@"fourth";
    }
    
    NSString *strCatagories=self.strKittyType;
    NSString *strKittyTime=self.txtTime.text;
    NSString *strFineOptionYesNO=self.btnFine.titleLabel.text;
    NSString *strFineValue=self.txtFineValue.text;
    NSString *strNoOfHost=self.btnHost.titleLabel.text;
    NSString *strNoOfPuncuanility=self.btnPunctuality.titleLabel.text;
    NSString *strPuncunalityAmount1=self.txtPunctualityAmount.text;
    NSString *strPuncunalityAmount2=self.txtPuncunalityAmount2.text;
    NSString *strPuncunalityTime1=self.txtPuncunalityTime.text;
    NSString *strPuncunalityTime2=self.txtPuncunalityTime2.text;
    //strFoodMoney
    //strDrinksMoney declare globaly
    
    NSString *strFoodMoneyValue=self.txtFoodMoney.text;
    NSString *strdrinkMoneyvalue=self.txtDrinkMoney.text;
    NSString *strGameYesNo=self.btnGames.titleLabel.text;
    NSString *strSelectGame=self.btnSelectGames.titleLabel.text;
    NSString *strNoOfGameTambola=self.lblTambolaValue.text;
    NSString *strNoOfGameNormal=self.lblNormalValue.text;
    NSString *strTambolaPrice=self.txtTambolaPrice.text;
    NSString *strNormalPrice=self.txtNoramalPrice.text;
    NSString *strAdditionalNotes=self.txtviewCreateDestination.text;
    NSString *strDestinationYESNO;
    if(self.btnCreateDestination.selected){
        strDestinationYESNO=@"Yes";
    }else{
        strDestinationYESNO=@"No";
    }
    if(strKittyAmount.length==0){
        strKittyAmount=@"1";
    }
    if(!([strKittyAmount intValue]>0)){
        
        [AlertView showAlertWithMessage:@"Please enter a valid amount for kitty."];
    }else if([strKittyTime isEqualToString:@""]){
        [AlertView showAlertWithMessage:@"Please enter time for kitty"];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:strKittyAmount forKey:@"amount"];
        if([self.btnKittyWeekName.titleLabel.text isEqualToString:@"Monthly"]){
            //            [dict setObject:@"" forKey:@"days"];
            //            [dict setObject:@"" forKey:@"week"];
            NSString *strDateValue=self.btnKittyWeek.titleLabel.text;
            strDateValue  = [strDateValue stringByReplacingOccurrencesOfString:@"  First kitty : " withString:@""];
            [dict setObject:strDateValue forKey:@"kittyDate"];
        }else{
            [dict setObject:strKittyWeekDay forKey:@"days"];
            [dict setObject:strkittyWeekNumber forKey:@"week"];
        }
        if(strCatagories){
            [dict setObject:strCatagories forKey:@"category"];
        }else{
            NSString *strCatagory=self.btnCategories.titleLabel.text;
            NSString *newStr = [strCatagory substringFromIndex:2];
            [dict setObject:newStr forKey:@"category"];
        }
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";//HH:mm
        NSDate *date = [dateFormatter dateFromString:strKittyTime];
        
        dateFormatter.dateFormat = @"HH:mm";
        NSString *pmamDateString = [dateFormatter stringFromDate:date];
        NSString *firstDate=[self.btnFirstkittyDate.titleLabel.text stringByReplacingOccurrencesOfString:@"(1st Kitty)" withString:@""];
        [dict setObject:firstDate forKey:@"first_kitty"];
        [dict setObject:pmamDateString forKey:@"kittyTime"];
        [dict setObject:strFineOptionYesNO forKey:@"fine"];
        [dict setObject:strFineValue forKey:@"fineAmount"];
        [dict setObject:strNoOfHost forKey:@"hosts"];
        [dict setObject:strNoOfPuncuanility forKey:@"punctuality"];
        [dict setObject:strPuncunalityTime1 forKey:@"punctualityTime"];
        [dict setObject:strPuncunalityAmount1 forKey:@"punctualityAmount"];
        [dict setObject:strPuncunalityTime2 forKey:@"punctualityTime2"];
        [dict setObject:strPuncunalityAmount2 forKey:@"punctualityAmount2"];
        [dict setObject:strFoodMoney forKey:@"foodBy"];
        [dict setObject:strFoodMoneyValue forKey:@"foodamount"];
        [dict setObject:strDrinksMoney forKey:@"drink"];
        [dict setObject:strdrinkMoneyvalue forKey:@"drinkAmount"];
        [dict setObject:strGameYesNo forKey:@"game"];
        [dict setObject:strSelectGame forKey:@"gameType"];
        [dict setObject:self.lblNormalValue.text forKey:@"normal"];
        [dict setObject:strNormalPrice forKey:@"normalprice"];
        [dict setObject:self.lblTambolaValue.text forKey:@"tambola"];
        [dict setObject:strTambolaPrice forKey:@"tambolaprice"];
        [dict setObject:strDestinationYESNO forKey:@"destination"];
        [dict setObject:strAdditionalNotes forKey:@"note"];
        
        NSString *strSubmit=self.btnSubmit.titleLabel.text;
        if([strSubmit isEqualToString:@"Update"]){
            [self updateGroup:dict];
        }else{
            [self createGroup:dict];
        }
        
    }
}

-(void)getRules{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSDictionary *dict= [defaults objectForKey:self.groupId];
    if(dict){
        [self setRuleContent:dict];
    }else{
        [self.view addSubview:ind];
    }
    
    [[ApiClient sharedInstance]getRules:self.groupId success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        [self setRuleContent:dict];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        if(!(dict))
            [AlertView showAlertWithMessage:errorString];
    }];
}
-(void)setRuleContent:(NSDictionary *)dict{
    
    // data
    NSArray *data=[dict objectForKey:@"data"];
    NSDictionary *dataDict=[data objectAtIndex:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:self.groupId];
    [defaults synchronize];
    
    
    self.txtKittyAmount.text=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"amount"]];
    self.txtTime.text=[dataDict objectForKey:@"kittyTime"];
    [self.btnCategories setTitle:[NSString stringWithFormat:@"  %@",[dataDict objectForKey:@"category"]] forState:UIControlStateNormal];//kittyDate have to set is add date is selected
    NSString *strKittyWeek=[dataDict objectForKey:@"days"];
    
    strKittyWeek=[strKittyWeek capitalizedString];
    strKittyWeek=[NSString stringWithFormat:@"  %@",strKittyWeek];
    [self.btnKittyWeekName setTitle:strKittyWeek forState:UIControlStateNormal];
    NSString *destination=[dataDict objectForKey:@"destination"];
    if([destination isEqualToString:@"No"]){
        self.txtviewCreateDestination.userInteractionEnabled=NO;
        self.txtviewCreateDestination.text=@"";
        self.btnCreateDestination.selected=NO;
        self.txtviewCreateDestination.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        [self.btnCreateDestination setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }else{
        self.btnCreateDestination.selected=YES;
        [self.btnCreateDestination setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        self.txtviewCreateDestination.userInteractionEnabled=YES;
        self.txtviewCreateDestination.textColor = [UIColor lightGrayColor];
        self.txtviewCreateDestination.text=@"Add additional note here...";
        self.txtviewCreateDestination.text=[dataDict objectForKey:@"Note"];
    }
    NSString *firstDate=[NSString stringWithFormat:@"%@(1st Kitty)",[dataDict objectForKey:@"firstKitty"]];
    [self.btnFirstkittyDate setTitle:firstDate  forState:UIControlStateNormal];
    self.txtDrinkMoney.text=[dataDict objectForKey:@"drinkAmount"];
    NSString *drinksBy=[dataDict objectForKey:@"drinksBy"];
    [self changeDrinkMoney];
    if([drinksBy isEqualToString:@"Host"]){//host,dutch,fixed
        [self.btnDrinkHost setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else if([drinksBy isEqualToString:@"Dutch"]){
        [self.btnDrinkDutch setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else if([drinksBy isEqualToString:@"Fixed"]){
        [self.btnDrinkFixed setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }
    NSString *fine=[dataDict objectForKey:@"fine"];
    
    if([fine isEqualToString:@"No"]){
        [self.btnFine setTitle:fine forState:UIControlStateNormal];
        self.txtFineValue.text=@"";
        
    }else{
        [self.btnFine setTitle:fine forState:UIControlStateNormal];
        self.txtFineValue.userInteractionEnabled=YES;
        self.txtFineValue.text=[dataDict objectForKey:@"fineAmount"];
    }
    [self changeFoodMoney];
    NSString *foodBy=[dataDict objectForKey:@"foodBy"];
    if([foodBy isEqualToString:@"Host"]){//host,dutch,fixed
        [self.btnFoodMoneyHost setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else if([foodBy isEqualToString:@"Dutch"]){
        [self.btnFoodMoneyDutch setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else if([foodBy isEqualToString:@"Fixed"]){
        [self.btnFoodMoneyFixed setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }
    
    self.txtFoodMoney.text=[dataDict objectForKey:@"foodamount"];
    
    NSString *game=[dataDict objectForKey:@"game"];
    if([game isEqualToString:@"  Yes"]){
        [self.btnGames setTitle:game forState:UIControlStateNormal];
        [self.btnSelectGames setTitle:[dataDict objectForKey:@"gameType"]forState:UIControlStateNormal];
        NSString *gameType=[dataDict objectForKey:@"gameType"];
        if([gameType isEqualToString:@"Tambola + Normal"]){
            [self enableDesiable:YES];
            self.lblNormalValue.text=[dataDict objectForKey:@"normal"];
            self.txtNoramalPrice.text=[dataDict objectForKey:@"normalprice"];
            
            self.lblTambolaValue.text=[dataDict objectForKey:@"tambola"];
            self.txtTambolaPrice.text=[dataDict objectForKey:@"tambolaprice"];
            
        }else if([gameType isEqualToString:@"Normal"]){
            self.btnNormalPlus.enabled=YES;
            self.btnTambolaPlus.enabled=NO;
            self.btnNormalPlus.enabled=YES;
            self.btnTambolaMinus.enabled=NO;
            self.txtTambolaPrice.enabled=NO;
            self.txtNoramalPrice.enabled=YES;
            
            self.lblNormalValue.text=[dataDict objectForKey:@"normal"];
            self.txtNoramalPrice.text=[dataDict objectForKey:@"normalprice"];
            self.lblTambolaValue.text=@"";
            self.txtTambolaPrice.text=@"";
            
            
        }else if([gameType isEqualToString:@"Tambola"]){
            self.btnNormalPlus.enabled=NO;
            self.btnTambolaPlus.enabled=YES;
            self.btnNormalPlus.enabled=NO;
            self.btnTambolaMinus.enabled=YES;
            self.txtTambolaPrice.enabled=YES;
            self.txtNoramalPrice.enabled=NO;
            self.lblNormalValue.text=@"";
            self.txtNoramalPrice.text=@"";
            self.lblTambolaValue.text=[dataDict objectForKey:@"tambola"];
            self.txtTambolaPrice.text=[dataDict objectForKey:@"tambolaprice"];
        }
    }else{
        [self enableDesiable:NO];
        self.lblNormalValue.text=@"1";
        self.txtNoramalPrice.text=@"1";
    }
    NSString *hostValue=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"hosts"]];
    [self.btnHost setTitle:hostValue forState:UIControlStateNormal];
    self.btnHost.userInteractionEnabled=NO;
    NSString *punctuality=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"punctuality"]];
    [self.btnPunctuality setTitle:punctuality forState:UIControlStateNormal];
    if([punctuality isEqualToString:@"0"]){
        self.txtPuncunalityAmount2.enabled=NO;
        self.txtPunctualityAmount.enabled=NO;
        self.txtPuncunalityTime.enabled=NO;
        self.txtPuncunalityTime2.enabled=NO;
        self.btnPunctualityTime.userInteractionEnabled=NO;
        self.btnpunctualityTime2.userInteractionEnabled=NO;
        [self.btnPunctuality setTitle:@"00" forState:UIControlStateNormal];
    }else if([punctuality isEqualToString:@"1"]){
        self.txtPuncunalityTime.enabled=YES;
        self.txtPuncunalityTime2.enabled=NO;
        self.txtPuncunalityAmount2.enabled=NO;
        self.txtPunctualityAmount.enabled=YES;
        self.btnPunctualityTime.userInteractionEnabled=YES;
        self.btnpunctualityTime2.userInteractionEnabled=NO;
        
        [self.btnPunctuality setTitle:@"01" forState:UIControlStateNormal];
    }else if([punctuality isEqualToString:@"2"]){
        self.txtPuncunalityTime.enabled=YES;
        self.txtPuncunalityTime2.enabled=YES;
        self.txtPuncunalityAmount2.enabled=YES;
        self.txtPunctualityAmount.enabled=YES;
        self.btnPunctualityTime.userInteractionEnabled=YES;
        self.btnpunctualityTime2.userInteractionEnabled=YES;
        
        [self.btnPunctuality setTitle:@"02" forState:UIControlStateNormal];
    }
    
    self.txtPunctualityAmount.text=[dataDict objectForKey:@"punctualityAmount"];
    self.txtPuncunalityAmount2.text=[dataDict objectForKey:@"punctualityAmount2"];
    self.txtPuncunalityTime.text=[dataDict objectForKey:@"punctualityTime"];
    self.txtPuncunalityTime2.text=[dataDict objectForKey:@"punctualityTime2"];;
    NSString *strkittyWeekNumber=[dataDict objectForKey:@"week"];
    if([strkittyWeekNumber isEqualToString:@""]){
        
        [self.btnKittyWeekName setTitle:@"Monthly" forState:UIControlStateNormal];
        
        NSString *strDate=[NSString stringWithFormat:@"  First kitty : %@",[dataDict objectForKey:@"kittyDate"]];
        [self.btnKittyWeek setTitle:strDate forState:UIControlStateNormal];
        
    }else{
        if([strkittyWeekNumber isEqualToString:@"first"]){
            strkittyWeekNumber=@"1st";
        }else if([strkittyWeekNumber isEqualToString:@"second"]){
            strkittyWeekNumber=@"2nd";
        }else if([strkittyWeekNumber isEqualToString:@"third"]){
            strkittyWeekNumber=@"3rd";
        }else if([strkittyWeekNumber isEqualToString:@"fourth"]){
            strkittyWeekNumber=@"4th";
        }
        [self.btnKittyWeek setTitle:strkittyWeekNumber forState:UIControlStateNormal];
    }
    
    
}

-(void)createGroup:(NSMutableDictionary *)dict2{
    __block NSMutableDictionary *dict=dict2;
    if([self.strKittyType isEqualToString:@"Couple Kitty"]){
        if(arrTotalCouple.count>0  ){
            
        } else{
            [AlertView showAlertWithMessage:@"Please pair couple first. In order to create couple kitty."];
            return;
        }
    }
    
    // if(!([self.strGroupName isEqualToString:@""])){
    [self.view addSubview:ind];
    
    NSMutableArray *arrgroupMember1=[[NSMutableArray alloc]init];
    for (int i=0; i<self.arryGroupMember.count; i++) {
        NSDictionary *dict1=[self.arryGroupMember objectAtIndex:i];
        NSString *registeration=[dict1 objectForKey:@"registeration"];
        if([registeration isEqualToString:@"1"]){
            QBUUser *user = [QBUUser new];
            user.ID=[[dict1 objectForKey:@"ID"]intValue];
            user.login=[dict1 objectForKey:@"name"];
            user.fullName=[dict1 objectForKey:@"full_name"];
            [arrgroupMember1 addObject:user];
        }
    }
    
    
    NSData *dataForProfile = UIImageJPEGRepresentation(self.imgGroup, 0.6f);
    NSString *myProfileBase64String = [dataForProfile base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if(!(myProfileBase64String)){
        [dict setObject:@"" forKey:@"groupIMG"];
    }else{
        [dict setObject:myProfileBase64String forKey:@"groupIMG"];
    }
    
    if([self.strKittyType isEqualToString:@"Couple Kitty"]){
        int selectedMemberHost=0;
        if(arryNotSelectedMember.count>0){
            for (int i=0; i<arrTotalCouple.count; i++) {
                NSDictionary *dict=[arrTotalCouple objectAtIndex:i];
                if([self.strInMiddelKitty isEqualToString:@"Yes"]){
                    NSString *is_host=[dict objectForKey:@"is_host"];
                    if(!([is_host isEqualToString:@"0-!-0"])){
                        selectedMemberHost++;
                    }
                }
            }
            for ( int i=0; i<arryNotSelectedMember.count; i++) {
                NSDictionary *dict=[arryNotSelectedMember objectAtIndex:i];
                if([self.strInMiddelKitty isEqualToString:@"Yes"]){
                    NSString *is_host=[dict objectForKey:@"is_host"];
                    if(!([is_host isEqualToString:@"0"])){
                        selectedMemberHost++;
                    }
                }
                
                [arrTotalCouple addObject:dict];
            }
        }
        if(arrTotalCouple.count>0){
            if([self.strInMiddelKitty isEqualToString:@"Yes"]){
                NSString *strHostValue=[NSString stringWithFormat:@"%d",selectedMemberHost];
                NSLog(@"Hello %@",strHostValue);
                [dict setObject:strHostValue forKey:@"noOfHost"];
            }
            
            [dict setObject:arrTotalCouple forKey:@"groupMember"];
        }else{
            [AlertView showAlertWithMessage:@"Please pair couple first. In order to create couple kitty."];
        }
    }else if([self.strKittyType isEqualToString:@"Kitty with Kids"]){
        [dict setObject:self.arryGroupMember forKey:@"groupMember"];
    }else if([self.strKittyType isEqualToString:@"Normal Kitty"]){
        [dict setObject:self.arryGroupMember forKey:@"groupMember"];
    }
    if([self.strInMiddelKitty isEqualToString:@"Yes"]){
        if(!([self.strKittyType isEqualToString:@"Couple Kitty"])){
            [dict setObject:self.strNoOfHost forKey:@"noOfHost"];
        }
        
    }
    if([self.strMakingkitty isEqualToString:@"yes"]){
        [dict setObject:self.groupId forKey:@"groupID"];
        [[ApiClient sharedInstance] addGroup:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RefreshGroup"
             object:self];
            [AlertView showAlertWithMessage:@"Group created successfully!!!"];
            
            self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
        
        
    }else{
        [self createChatWithName:self.strGroupName arruser:arrgroupMember1 completion:^(QBChatDialog *dialog) {
            
            [dict setObject:[NSString stringWithFormat:@"%@",dialog.ID] forKey:@"QuickGroupId"];
            [dict setObject:self.strGroupName forKey:@"name"];
            [dict setObject:@"1" forKey:@"setRule"];
            
            [[ApiClient sharedInstance] addGroup:dict success:^(id responseObject) {
                [ind removeFromSuperview];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RefreshGroup"
                 object:self];
                [AlertView showAlertWithMessage:@"Group created successfully!!!"];
                
                self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:errorString];
            }];
        }];
    }
    
    //NSLog(@"arryGroupMember %@",self.arryGroupMember);
    //   }
    
}

-(void)updateGroup:(NSMutableDictionary *)dict{
    
    [self.view addSubview:ind];
    [[ApiClient sharedInstance] updateRules:self.groupId dict:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictResp=responseObject;
        [self setRuleContent:dictResp];
        [AlertView showAlertWithMessage:@"Rules updated successfully."];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}
- (IBAction)cmdFirstKittyDate:(id)sender {
    
    timeSetForText=5;
    [self addDatePicker:UIDatePickerModeDate];
    
}


- (void)createChatWithName:(NSString *)name arruser:(NSArray *)arruser completion:(void(^)(QBChatDialog *dialog))completion {
    
    
    NSArray *selectedUsers = arruser;//[self.dataSource.users objectsAtIndexes:selectedUsersIndexSet];
    
    //    if (selectedUsers.count == 1) {
    //        // Creating private chat dialog.
    //        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:selectedUsers.firstObject completion:^(QBResponse *response, QBChatDialog *createdDialog) {
    //            if (!response.success && createdDialog == nil) {
    //                if (completion) {
    //                    completion(nil);
    //                }
    //            }
    //            else {
    //                if (completion) {
    //                    completion(createdDialog);
    //                }
    //            }
    //        }];
    //    } else if (selectedUsers.count > 1) {
    if (name == nil || [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"%@_", [QBSession currentSession].currentUser.fullName];
        for (QBUUser *user in selectedUsers) {
            name = [NSString stringWithFormat:@"%@%@,", name, user.fullName];
        }
        name = [name substringToIndex:name.length - 1]; // remove last , (comma)
    }
    else {
        name = [name stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    // [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING", nil) maskType:SVProgressHUDMaskTypeClear];
    
    
    // Creating group chat dialog.
    [ServicesManager.instance.chatService createGroupChatDialogWithName:name photo:nil occupants:selectedUsers completion:^(QBResponse *response, QBChatDialog *createdDialog) {
        if (response.success) {
            NSString * notificationText = [self updatedMessageWithUsers:selectedUsers];
            // Notifying users about created dialog.
            [[ServicesManager instance].chatService sendSystemMessageAboutAddingToDialog:createdDialog
                                                                              toUsersIDs:createdDialog.occupantIDs
                                                                                withText:notificationText
                                                                              completion:^(NSError *error) {
                                                                                  
                                                                                  // Notify occupants that dialog was updated.
                                                                                  [[ServicesManager instance].chatService sendNotificationMessageAboutAddingOccupants:createdDialog.occupantIDs
                                                                                                                                                             toDialog:createdDialog
                                                                                                                                                 withNotificationText:notificationText
                                                                                                                                                           completion:nil];
                                                                                  
                                                                                  if (completion) {
                                                                                      completion(createdDialog);
                                                                                  }
                                                                              }];
        } else {
            if (completion) {
                completion(nil);
            }
        }
    }];
    //    } else {
    //        assert("no given users");
    //    }
}

#pragma mark - Helpers
- (NSString *)updatedMessageWithUsers:(NSArray *)users {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@ ", [ServicesManager instance].currentUser.fullName, NSLocalizedString(@"SA_STR_CREATE_NEW", nil)];
    
    for (QBUUser *user in users) {
        message = [NSString stringWithFormat:@"%@%@,", message, user.fullName];
    }
    message = [message substringToIndex:message.length - 1]; // remove last , (comma)
    
    return message;
}




@end
