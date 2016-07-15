//
//  VenuViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "VenuViewController.h"

@interface VenuViewController (){
    BOOL  selectedTime;
    BOOL dateSelected;
    BOOL pauncunalitytimeBool;
    IndecatorView *ind;
    NSString *venuID;
}

@end

@implementation VenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"SET VENUE";
    
    self.txtVenuIntro.text=[NSString stringWithFormat:@"To host kitty for %@ on %@",self.name,self.kittyDate];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    self.txtViewAdditional.layer.cornerRadius=4;
    self.txtViewAdditional.layer.borderWidth=0.5;
    self.txtViewAdditional.clipsToBounds = YES;
    self.txtViewAdditional.layer.borderColor=[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    
    self.txtViewDressCode.layer.cornerRadius=4;
    self.txtViewDressCode.layer.borderWidth=0.5;
    self.txtViewDressCode.clipsToBounds = YES;
    self.txtViewDressCode.layer.borderColor=[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    
    self.txtViewAddress.layer.cornerRadius=4;
    self.txtViewAddress.layer.borderWidth=0.5;
    self.txtViewAddress.clipsToBounds = YES;
    self.txtViewAddress.layer.borderColor=[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight<568){
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight+130);
    }else if(screenHeight>567 && screenHeight<667 ){
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight+40);
    }else if(screenHeight>666 && screenHeight<670){
        self.scrollView.contentSize = CGSizeMake(screenWidth,
                                                 screenHeight-50);
    }
self.viewBack.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    self.txtViewAddress.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    self.txtViewAddress.text = @"Venue Address";
    self.txtViewDressCode.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    self.txtViewDressCode.text = @"Enter details for dress code...";
    if([self.punctuality isEqualToString:@"1"]){
        self.btnPuncunalityTime.userInteractionEnabled=YES;
        self.btnPuncunalityTime2.userInteractionEnabled=NO;
        self.txtPuncunalityTime2.userInteractionEnabled=NO;
        self.txtPuncunalityTime2.userInteractionEnabled=YES;
        self.txtPuncunalityTime2.userInteractionEnabled=NO;
        self.txtPuncunalityTime2.text=@"";
        self.txtPunctualityTime.text=self.punctualityTime;
    }else if([self.punctuality isEqualToString:@"2"]){
        self.btnPuncunalityTime.userInteractionEnabled=YES;
        self.btnPuncunalityTime2.userInteractionEnabled=YES;
        self.txtPuncunalityTime2.text=self.punctualityTime2;
        self.txtPunctualityTime.text=self.punctualityTime;
        self.txtPuncunalityTime2.userInteractionEnabled=YES;
        self.txtPunctualityTime.userInteractionEnabled=YES;
        
    }else if([self.punctuality isEqualToString:@"0"]){
        self.btnPuncunalityTime.userInteractionEnabled=NO;
        self.btnPuncunalityTime2.userInteractionEnabled=NO;
        self.txtPuncunalityTime2.text=@"";
        self.txtPunctualityTime.text=@"";
        self.txtPuncunalityTime2.userInteractionEnabled=NO;
        self.txtPunctualityTime.userInteractionEnabled=NO;
        
    }
    self.txtDate.text=self.kittyDate;
    self.txtTime.text=self.kittytime;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *StrSaveName=[NSString stringWithFormat:@"%@%@",self.groupId,self.kittyId];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:StrSaveName];
    NSDictionary *dict= [defaults objectForKey:StrSaveName];
    if(dict){
            [self displayData];
            [self getVanue];
            [self.btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
    }else{
        if([self.venuSet isEqualToString:@"1"]){
            [self displayData];
            [self getVanue];
            [self.btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
        }
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView== self.txtViewAddress){
        
        if([self.txtViewAddress.text isEqualToString:@"Venue Address"]){
            self.txtViewAddress.text = @"";
            self.txtViewAddress.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }else{
             self.txtViewAddress.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }
       
    }
    
    if(textView== self.txtViewDressCode){
        
        if([self.txtViewDressCode.text isEqualToString:@"Enter details for dress code..."]){
            self.txtViewDressCode.text = @"";
           self.txtViewDressCode.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }else{
             self.txtViewDressCode.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }
       
    }

    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textView==self.txtViewAdditional){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
                         }else if(textView==self.txtViewDressCode){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView== self.txtViewAddress){
      if(self.txtViewAddress.text.length == 0){
        self.txtViewAddress.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
        self.txtViewAddress.text = @"Venue Address";
        [self.txtViewAddress resignFirstResponder];
      }
    }
    if(textView== self.txtViewDressCode){
        if(self.txtViewDressCode.text.length == 0){
            self.txtViewDressCode.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
            self.txtViewDressCode.text = @"Enter details for dress code...";
            [self.txtViewDressCode resignFirstResponder];
        }
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        if(textView== self.txtViewAddress){
            if(self.txtViewAddress.text.length == 0){
                self.txtViewAddress.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
                self.txtViewAddress.text = @"Venue Address";
                [self.txtViewAddress resignFirstResponder];
            }
        }
        if(textView== self.txtViewDressCode){
            if(self.txtViewDressCode.text.length == 0){
                self.txtViewDressCode.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
                self.txtViewDressCode.text = @"Enter details for dress code...";
                [self.txtViewDressCode resignFirstResponder];
            }
        }

        
        [self setView];
        [textView resignFirstResponder];
        return NO;
    }
    
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


- (IBAction)cmdTime:(id)sender {
    selectedTime=YES;
     dateSelected=NO;
    [self addDatePiker:UIDatePickerModeTime];

}

- (IBAction)cmdPunctualityTime:(id)sender {
    selectedTime=NO;
    dateSelected=NO;
    pauncunalitytimeBool=YES;

    [self addDatePiker:UIDatePickerModeTime];

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
    
   
    if(dateSelected){
        self.txtDate.text=[dateFormatter stringFromDate:yourDate];
         self.txtVenuIntro.text=[NSString stringWithFormat:@"To host kitty for %@ on %@",self.name,[dateFormatter stringFromDate:yourDate]];
        self.txtTime.text=@"";
        self.txtPunctualityTime.text=@"";
        self.txtPuncunalityTime2.text=@"";
    }else{
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"hh:mm a";
        NSString *dateString = [timeFormatter stringFromDate: sender.date];
        if(selectedTime){
            self.txtTime.text=dateString;
        }else{
            
            NSDate *dateTime=[timeFormatter dateFromString:self.txtTime.text];
            NSDate *CurrentdateTime=[timeFormatter dateFromString:dateString];
            if(pauncunalitytimeBool){
                self.txtPunctualityTime.text=dateString;
            }else{
                self.txtPuncunalityTime2.text=dateString;
            }

            if([dateTime compare:CurrentdateTime]== NSOrderedAscending){//checking kitty time is less than puncunality time and also for punculatiy 2
                NSDate *pun2=[timeFormatter dateFromString:self.txtPunctualityTime.text];
                if([pun2 compare:CurrentdateTime]== NSOrderedAscending){
                    self.txtPuncunalityTime2.text=dateString;
                }else{
                    self.txtPuncunalityTime2.text=@"";
                    [AlertView showAlertWithMessage:@"Punctuality2 time must be grater than Punctuality1 Time."];
                }
            }else{
                self.txtPunctualityTime.text=@"";
                [AlertView showAlertWithMessage:@"Punctuality time must be grater than Kitty Time."];
                
            }
        }
    }
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

-(void)addDatePiker:(UIDatePickerMode)mode{
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
    if(mode==UIDatePickerModeDate){
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSLog(@"%@",[dateFormatter dateFromString:self.txtDate.text]);
        
    NSDate *date = [NSDate date];
    datePicker.minimumDate=date;
    }
    datePicker.datePickerMode=mode;
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

-(void)retrunView{
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

- (IBAction)cmdDate:(id)sender {
    dateSelected=YES;
    [self addDatePiker:UIDatePickerModeDate];
}

- (IBAction)cmdPuncunalityTime2:(id)sender {
     dateSelected=NO;
    pauncunalitytimeBool=NO;
    [self addDatePiker:UIDatePickerModeTime];
}


#pragma mark APi

-(void)getVanue{
    [[ApiClient sharedInstance] getVenue:self.kittyId success:^(id responseObject) {
        NSDictionary *respoDict=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *StrSaveName=[NSString stringWithFormat:@"%@%@",self.groupId,self.kittyId];
        [defaults setObject:respoDict forKey:StrSaveName];
        [defaults synchronize];
        [self displayData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [self displayData];
    }];
}

-(void)setVenue{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.groupId forKey:@"groupID"];
    [dict setObject:self.kittyId forKey:@"kitty_id"];
    [dict setObject:USERID forKey:@"user_id"];
    NSString *strVenu=[self.txtVenue.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strVenu.length==0){
        [AlertView showAlertWithMessage:@"Please enter venu for Kitty Party."];
        return;
    }else{
        [dict setObject:self.txtVenue.text forKey:@"vanue"];
    }
    NSString *strVenuAddress=[self.txtViewAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if((strVenuAddress.length==0) || [self.txtViewAddress.text isEqualToString:@"Venue Address"]){
        [AlertView showAlertWithMessage:@"Please enter venu address for Kitty Party."];
        return;
    }else{
        [dict setObject:self.txtViewAddress.text forKey:@"address"];
    }
    
    [dict setObject:self.txtDate.text forKey:@"kitty_date"];
    [dict setObject:self.txtTime.text forKey:@"kitty_time"];
    [dict setObject:self.txtPunctualityTime.text forKey:@"punctuality"];
    [dict setObject:self.txtPuncunalityTime2.text forKey:@"punctuality2"];
    [dict setObject:self.txtViewDressCode.text forKey:@"dressCode"];
    [dict setObject:self.txtViewAdditional.text forKey:@"note"];
    [self.view addSubview:ind];
    
    [[ApiClient sharedInstance]setVeneu:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *respoDict=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *StrSaveName=[NSString stringWithFormat:@"%@%@",self.groupId,self.kittyId];
        [defaults setObject:respoDict forKey:StrSaveName];
        [defaults synchronize];
        NSArray *arryData=[respoDict objectForKey:@"data"];
        NSDictionary *dictData=[arryData objectAtIndex:0];
        venuID=[dictData objectForKey:@"id"];
        [self.btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RefreshGroup"
         object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}

-(void)updateVenue{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.groupId forKey:@"groupID"];
    [dict setObject:self.kittyId forKey:@"kitty_id"];
    NSString *strVenu=[self.txtVenue.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strVenu.length==0){
        [AlertView showAlertWithMessage:@"Please enter venu for Kitty Party."];
        return;
    }else{
        [dict setObject:self.txtVenue.text forKey:@"vanue"];
    }
    NSString *strVenuAddress=[self.txtViewAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if((strVenuAddress.length==0) || [self.txtViewAddress.text isEqualToString:@"Venue Address"]){
        [AlertView showAlertWithMessage:@"Please enter venu address for Kitty Party."];
        return;
    }else{
        [dict setObject:self.txtViewAddress.text forKey:@"address"];
    }
    [dict setObject:venuID forKey:@"id"];
    [dict setObject:USERID forKey:@"user_id"];

    [dict setObject:self.txtDate.text forKey:@"kitty_date"];
    [dict setObject:self.txtTime.text forKey:@"kitty_time"];
    [dict setObject:self.txtPunctualityTime.text forKey:@"punctuality"];
    [dict setObject:self.txtPuncunalityTime2.text forKey:@"punctuality2"];
    [dict setObject:self.txtViewDressCode.text forKey:@"dressCode"];
    [dict setObject:self.txtViewAdditional.text forKey:@"note"];
    [self.view addSubview:ind];

   [ [ApiClient sharedInstance]updateVenue:dict success:^(id responseObject) {
       [ind removeFromSuperview];
       NSDictionary *respoDict=responseObject;
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       NSString *StrSaveName=[NSString stringWithFormat:@"%@%@",self.groupId,self.kittyId];
       [defaults setObject:respoDict forKey:StrSaveName];
       [defaults synchronize];
       [AlertView showAlertWithMessage:@"Venue Updated successfully."];
       [[NSNotificationCenter defaultCenter]
        postNotificationName:@"RefreshGroup"
        object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}

- (IBAction)cmdSubmit:(id)sender {
    [self.view endEditing:YES];
    [self setView];
    NSString *submmit=self.btnSubmit.titleLabel.text;
    if([submmit isEqualToString:@"Update"]){
        [self updateVenue];
    }else{
       [self setVenue];
    }
}

-(void)displayData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *StrSaveName=[NSString stringWithFormat:@"%@%@",self.groupId,self.kittyId];
    NSDictionary *dict= [defaults objectForKey:StrSaveName];
    NSArray *data=[dict objectForKey:@"data"];
    NSDictionary *dataDict=[data objectAtIndex:0];
    self.txtViewAddress.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    self.txtViewDressCode.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    self.txtVenuIntro.text=[NSString stringWithFormat:@"To host kitty for %@ on %@",self.name,[dataDict objectForKey:@"kitty_date"]];
    self.txtVenue.text=[dataDict objectForKey:@"vanue"];
    self.txtViewAddress.text=[dataDict objectForKey:@"address"];
    self.txtDate.text=[dataDict objectForKey:@"kitty_date"];
    self.txtTime.text=[dataDict objectForKey:@"venueTime"];
    self.txtPunctualityTime.text=[dataDict objectForKey:@"punctuality"];
    self.txtPuncunalityTime2.text=[dataDict objectForKey:@"punctuality2"];
    self.txtViewDressCode.text=[dataDict objectForKey:@"dressCode"];
    self.txtViewAdditional.text=[dataDict objectForKey:@"note"];
    venuID=[dataDict objectForKey:@"id"];
}
@end
