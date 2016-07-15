//
//  PersonalNotesViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "PersonalNotesViewController.h"
@interface PersonalNotesViewController (){
    IndecatorView *ind;
    NSArray *arryNotes;
}

@end

@implementation PersonalNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HideProfile:)
                                                 name:@"ReturnViewToBottomPersonalNotes"
                                               object:nil];

    
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}
- (void)HideProfile:(NSNotification *) notification {
    [self retrunView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=self.strPersonalNoteORKittyNotes;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    [self.btnAdd.layer setBorderWidth:0];
    [self.btnAdd.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.btnAdd.layer setShadowOpacity:0.8];
    [self.btnAdd.layer setShadowRadius:3.0];
    [self.btnAdd.layer setShadowOffset:CGSizeMake(1, 1)];
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    self.btnCancel.layer.cornerRadius=4;
    self.btnCancel.clipsToBounds=YES;
   // self.lblBack.layer.borderColor=[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    self.lblBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
    self.txtViewPopUpContent.layer.borderWidth=1;
    self.txtViewPopUpContent.layer.cornerRadius=4;
    self.txtViewPopUpContent.layer.borderColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0].CGColor;
    self.txtViewPopUpContent.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    self.txtViewPopUpContent.text = @"Add note...";
    
    if([self.strFromMenu isEqualToString:@"FromMenu"]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
        NSArray *dict= [defaults objectForKey:strgroupIDKittyNo];
        if(dict){
            [self showAllNotes];
        }else{
            [self getAllNotes];
        }
        
    }else{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
    NSArray *dict= [defaults objectForKey:strgroupIDKittyNo];
    if(dict){
        [self showNotes];
    }else{
        [self getNotes];
    }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dict=[arryNotes objectAtIndex:indexPath.row];
    
    CGSize maximumLabelSize = CGSizeMake( self.view.frame.size.width-40, FLT_MAX);
    UILabel *yourLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 0)];
    yourLabel.backgroundColor=[UIColor clearColor];
    yourLabel.numberOfLines=10;
    yourLabel.lineBreakMode=NSLineBreakByWordWrapping;
    yourLabel.font = [UIFont fontWithName:@"GothamBook" size:11];
    yourLabel.textColor= [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    yourLabel.text=[dict objectForKey:@"description"];
    yourLabel.textAlignment = NSTextAlignmentLeft;
    
    
    
    CGSize expectedLabelSize = [[dict objectForKey:@"description"] sizeWithFont:yourLabel.font constrainedToSize:maximumLabelSize lineBreakMode:yourLabel.lineBreakMode];

    if(expectedLabelSize.height<60){
        return 120;
    }
    return  expectedLabelSize.height+70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arryNotes.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = nil;
    UITableViewCell * cell  = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:
            cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *dict=[arryNotes objectAtIndex:indexPath.row];
    float cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UIView *boxView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, cellHeight-5)];
    if(indexPath.row%2==0){
        boxView.backgroundColor=[UIColor whiteColor];
    }else{
         boxView.backgroundColor=[UIColor colorWithRed:251/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    }
    boxView.layer.cornerRadius=4;
    boxView.layer.borderColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0].CGColor;
    boxView.layer.borderWidth=1;
    
    
    
     UILabel *headding=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, boxView.frame.size.width-30, 25)];
     headding.backgroundColor=[UIColor clearColor];
     headding.numberOfLines=2;
     headding.lineBreakMode=NSLineBreakByWordWrapping;
     headding.font = [UIFont fontWithName:@"GothamMedium" size:13];
     headding.textColor= [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0];
     headding.text=[dict objectForKey:@"title"];
     headding.textAlignment = NSTextAlignmentLeft;
     [boxView addSubview:headding];

     UILabel *lblContent=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, boxView.frame.size.width-30, cellHeight-60)];
     lblContent.backgroundColor=[UIColor clearColor];
     lblContent.numberOfLines=100;
     lblContent.lineBreakMode=NSLineBreakByWordWrapping;
     lblContent.font = [UIFont fontWithName:@"GothamBook" size:11];
     lblContent.textColor= [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
     lblContent.text=[dict objectForKey:@"description"];
     lblContent.textAlignment = NSTextAlignmentLeft;
     [boxView addSubview:lblContent];
    [cell.contentView addSubview:boxView];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSDictionary *dict=[arryNotes objectAtIndex:indexPath.row];
        [self deteleNote:dict];
    }
}


- (IBAction)cmdAdd:(id)sender {
    [self addPopUp];
}

- (IBAction)cmdCancel:(id)sender {
    self.txtViewPopUpContent.text=@"";
    self.txtPopupTitle.text=@"";
    [self retrunView];
    [self dismissPopUp:sender];
}
- (IBAction)cmdSave:(id)sender {
    NSString *strtxtdiscription=[self.txtViewPopUpContent.text stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSString *strtxtTitle=[self.txtPopupTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strtxtTitle.length==0){
        [self retrunView];
        [AlertView showAlertWithMessage:@"Please enter Title first."];
        return;
    }
    if([self.txtViewPopUpContent.text isEqualToString:@"Add note..."]){
        [self retrunView];
         [AlertView showAlertWithMessage:@"Please enter note first."];
        return;
    }
    if(strtxtdiscription.length==0){
        [self retrunView];
        [AlertView showAlertWithMessage:@"Please enter note first."];
        return;
    }
    [self retrunView];
     if([self.strFromMenu isEqualToString:@"FromMenu"]){
         [self setAllNotes];
     }else{
         [self setNotes];
     }
    
    [self dismissPopUp:sender];
    
}

-(void)addPopUp{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect PopUpTargetFrame = CGRectMake(0, self.view.bounds.size.height-320, screenRect.size.width, 320);
    CGRect TargetFrame = CGRectMake(0, self.view.bounds.size.height+44, screenRect.size.width, 216);
    self.popUPView.frame=TargetFrame;
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopUp:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    [self.view addSubview:self.popUPView];
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.popUPView.frame = PopUpTargetFrame;
    [darkView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [UIView commitAnimations];
}

- (void)dismissPopUp:(id)sender {
     [self retrunView];
    
    self.txtViewPopUpContent.text=@"";
    self.txtPopupTitle.text=@"";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect PopUpTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, screenRect.size.width, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = PopUpTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}
- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self retrunView];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView== self.txtViewPopUpContent){
        if([self.txtViewPopUpContent.text isEqualToString:@"Add note..."]){
        self.txtViewPopUpContent.text = @"";
        self.txtViewPopUpContent.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }else{
            self.txtViewPopUpContent.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        }
    }
    
    
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textView==self.txtViewPopUpContent){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView== self.txtViewPopUpContent){
        if(self.txtViewPopUpContent.text.length == 0){
            self.txtViewPopUpContent.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
            self.txtViewPopUpContent.text = @"Add note...";
            [self retrunView];
            [self.txtViewPopUpContent resignFirstResponder];
        }
    }
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textField==self.txtPopupTitle){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self retrunView];
    [textField resignFirstResponder];
    return YES;
}

-(void)setNotes{
    [self.view addSubview:ind];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict setObject:USERID forKey:@"userId"];
    [dict setObject:self.groupID forKey:@"groupId"];
    if([self.strPersonalNoteORKittyNotes isEqualToString:@"PERSONAL NOTES"]){
        [dict setObject:@"personal" forKey:@"type"];
    }else{
        [dict setObject:@"kitty" forKey:@"type"];
    }
    [dict setObject:self.kittyNo forKey:@"kitty"];
    [dict setObject:self.txtPopupTitle.text forKey:@"title"];
    [dict setObject:self.txtViewPopUpContent.text forKey:@"description"];
    
    
    [[ApiClient sharedInstance]addNotes:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        self.txtViewPopUpContent.text=@"";
        self.txtPopupTitle.text=@"";
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        [self.tblNotes reloadData];
        [AlertView showAlertWithMessage:[dictResop objectForKey:@"message"]];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}
-(void)getNotes{
    
    [self.view addSubview:ind];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict setObject:USERID forKey:@"userId"];
    [dict setObject:self.groupID forKey:@"groupId"];
    if([self.strPersonalNoteORKittyNotes isEqualToString:@"PERSONAL NOTES"]){
        [dict setObject:@"personal" forKey:@"type"];
    }else{
        [dict setObject:@"kitty" forKey:@"type"];
    }
    [dict setObject:self.kittyNo forKey:@"kitty"];
    
    
    [[ApiClient sharedInstance]getNotes:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        
        [self.tblNotes reloadData];
       
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];

}

-(void)setAllNotes{
    
    [self.view addSubview:ind];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict setObject:self.txtPopupTitle.text forKey:@"title"];
    [dict setObject:self.txtViewPopUpContent.text forKey:@"description"];
    [dict setObject:@"personal" forKey:@"type"];
    
    [dict setObject:USERID forKey:@"userId"];
    [[ApiClient sharedInstance]addNotes:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        [self.tblNotes reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];

}


-(void)getAllNotes{
    [self.view addSubview:ind];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict setObject:USERID forKey:@"userId"];
    [[ApiClient sharedInstance]getNotes:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        [self.tblNotes reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];

}
-(void)showAllNotes{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
    NSArray *dict= [defaults objectForKey:strgroupIDKittyNo];
    arryNotes=[dict mutableCopy];
    [self.tblNotes reloadData];
    
    
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict1 setObject:USERID forKey:@"userId"];
    [[ApiClient sharedInstance]getNotes:dict1 success:^(id responseObject) {
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        [self.tblNotes reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        
    }];
    
}
-(void)showNotes{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
    NSArray *dict= [defaults objectForKey:strgroupIDKittyNo];
    arryNotes=[dict mutableCopy];
    [self.tblNotes reloadData];
    
    
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict1 setObject:USERID forKey:@"userId"];
    [dict1 setObject:self.groupID forKey:@"groupId"];
    if([self.strPersonalNoteORKittyNotes isEqualToString:@"PERSONAL NOTES"]){
        [dict1 setObject:@"personal" forKey:@"type"];
    }else{
        [dict1 setObject:@"kitty" forKey:@"type"];
    }
    [dict1 setObject:self.kittyNo forKey:@"kitty"];
    
    
    [[ApiClient sharedInstance]getNotes:dict1 success:^(id responseObject) {
        NSDictionary *dictResop=responseObject;
        arryNotes=[dictResop objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
        [defaults setObject:[dictResop objectForKey:@"data"] forKey:strgroupIDKittyNo];
        [defaults synchronize];
        
        [self.tblNotes reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrBaner= [defaults objectForKey:@"banner"];
    NSString *strUrl;
    for (int i=0; i<arrBaner.count; i++) {
        
        NSDictionary *dict=[arrBaner objectAtIndex:i];
        NSString *title=[dict objectForKey:@"slug"];
        
        if([self.strPersonalNoteORKittyNotes isEqualToString:@"PERSONAL NOTES"]){
            if([title isEqualToString:@"personal"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
        }else{
            if([title isEqualToString:@"kittynote"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
            
        }
    }
    strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    //UIImage *myImage = [UIImage imageNamed:@"banner.png"];
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    imageView.frame = CGRectMake(10,5,self.view.frame.size.width-20,40);
    imageView.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    imageView.showActivityIndicator=YES;
    imageView.clipsToBounds=YES;
    imageView.image=[UIImage imageNamed:@"banner.png"];
    imageView.imageURL=[NSURL URLWithString:strUrl];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [fotterView addSubview:imageView];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(adsClick:)];
    [fotterView addGestureRecognizer:singleFingerTap];
    
    return fotterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (void)adsClick:(UITapGestureRecognizer *)recognizer {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrBaner= [defaults objectForKey:@"banner"];
    NSString *strUrl;

    for (int i=0; i<arrBaner.count; i++) {
        
        NSDictionary *dict=[arrBaner objectAtIndex:i];
        NSString *title=[dict objectForKey:@"slug"];
        
        if([self.strPersonalNoteORKittyNotes isEqualToString:@"PERSONAL NOTES"]){
            if([title isEqualToString:@"personal"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
        }else{
            if([title isEqualToString:@"kittynote"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
            
        }
    }
    strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}

-(void)deteleNote:(NSDictionary *)note{
    [self.view addSubview:ind];
    NSString *strNoteId=[note objectForKey:@"noteID"];
    __block NSDictionary*deleteDict=note;
    [[ApiClient sharedInstance]deleteNotes:strNoteId success:^(id responseObject) {
        [ind removeFromSuperview];
        
        if([self.strFromMenu isEqualToString:@"FromMenu"]){
            NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@",self.groupID,self.strPersonalNoteORKittyNotes];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *dict= [[defaults objectForKey:strgroupIDKittyNo]mutableCopy];
            [dict removeObject:deleteDict];
            
            arryNotes=dict;
            [defaults setObject:dict forKey:strgroupIDKittyNo];
            [defaults synchronize];
            [self.tblNotes reloadData];
            
        }else{
            NSString *strgroupIDKittyNo=[NSString stringWithFormat:@"%@%@%@",self.groupID,self.kittyNo,self.strPersonalNoteORKittyNotes];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *dict= [[defaults objectForKey:strgroupIDKittyNo]mutableCopy];
            [dict removeObject:deleteDict];
            
            
            arryNotes=dict;
            [defaults setObject:dict forKey:strgroupIDKittyNo];
            [defaults synchronize];
            [self.tblNotes reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
         [AlertView showAlertWithMessage:errorString];
    }];
    
}

@end
