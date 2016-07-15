//
//  DiaryViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "DiaryViewController.h"
#import "PersonalNotesViewController.h"
#import "BillViewController.h"
#import "SelectCoupleViewController.h"
#import "kidsViewController.h"
#import "KittyRulesViewController.h"
#import "SelcectHostViewController.h"
#import <Quickblox/QBASession.h>
#import "ServicesManager.h"

@interface DiaryViewController (){
    NSMutableArray *arryPaid;
    NSMutableArray *arrPuncunality;
    NSMutableArray *arrPresent;
    UIView *contentView;
    UPStackMenu *stack;
    UIView *backView;
    IndecatorView *ind;
    NSArray *arryKittys;
    long kittyNumber;
    NSArray *arrMember;
    BOOL editTable;
    BOOL checkBlankId;
    NSString *noOfHost;
    NSString *noOfPuncunality;
    NSInteger noOfTimePuncunalityClicked;
    NSMutableArray *arryPunculanitySelected;
    NSString *leftKitties;
    NSMutableArray *puncunalityArry;
}

@end

@implementation DiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_button"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    contentView.backgroundColor=[UIColor clearColor];
    icon.frame=contentView.bounds;
    // [icon setFrame:CGRectInset(contentView.frame, 10, 10)];
    [contentView addSubview:icon];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    //backView.frame=self.view.bounds;
    UIButton *InviteBtn1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [InviteBtn1 setFrame:CGRectMake(0, 10, 25, 42)];
    [InviteBtn1 setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [InviteBtn1 addTarget:self action:@selector(cmdback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InviteBtnButton1 = [[UIBarButtonItem alloc] initWithCustomView:InviteBtn1];
    self.navigationItem.leftBarButtonItem = InviteBtnButton1;
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    UIButton *btnsumary = [UIButton buttonWithType:UIButtonTypeCustom];
    btnsumary.frame = CGRectMake(0, 0, 32, 32);
    [btnsumary setImage:[UIImage imageNamed:@"summary@1x"] forState:UIControlStateNormal];
    
    [btnsumary addTarget:self action:@selector(cmdSumary:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnsumary];
    [arrRightBarItems addObject:btnGroupBar];
     self.navigationItem.rightBarButtonItems=arrRightBarItems;
    [self setAnimation];
}
-(void)cmdSumary:(id)sender{
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    SelcectHostViewController* controller = [[SelcectHostViewController alloc] initWithNibName:@"SelcectHostViewController" bundle:nil];
    controller.groupId=self.groupID;
    controller.noOfHost=noOfHost;
    controller.summery=@"1";
    controller.strCategory=self.strCategory;
    controller.kitty_date=[dict objectForKey:@"kitty_date"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdback{
    if(!(noOfTimePuncunalityClicked==0)){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Do you want to save this Punctuality ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag=1;
        [alert show];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"DIARY";
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    arryPaid=[[NSMutableArray alloc]init];
    arrPresent=[[NSMutableArray alloc]init];
    arrPuncunality=[[NSMutableArray alloc]init];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    kittyNumber=0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strGuoupName=[NSString stringWithFormat:@"GroupDiaries%@",self.groupID];
    NSDictionary *dict= [defaults objectForKey:strGuoupName];
    noOfTimePuncunalityClicked=0;
    
    if(dict){
        [self showData];
    }else{
        [self getDairies];
    }
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self rightswipe];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self leftswipe];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        return  70;
    }
    return  40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrMember.count;
    
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
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor whiteColor];
    }else{
        cell.backgroundColor=[UIColor colorWithRed:251/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    }
    if((checkBlankId) && ([self.is_admin isEqualToString:@"1"])){
        cell.userInteractionEnabled = YES;
    }else if(editTable){
        cell.userInteractionEnabled = YES;
    }else{
        cell.userInteractionEnabled = NO;
    }
  
    NSDictionary *dictData=[arrMember objectAtIndex:indexPath.row];
    
    //SepratorLine betweenCell
    UIView *sepUpView=[[UIView alloc]initWithFrame:CGRectMake(10, 1,self.view.frame.size.width-20 , 1)];
    sepUpView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    sepUpView.alpha=0.5;
    [cell.contentView addSubview:sepUpView];

    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width/2-20, 30)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamBook" size:12];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    NSString *strName=[dictData  objectForKey:@"name"];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        lblName.numberOfLines=4;
        strName=[strName stringByReplacingOccurrencesOfString:@"-!-" withString:@"\n\n"];
        lblName.frame= CGRectMake(10, 5, self.view.frame.size.width/2-20, 60);
    }
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        //strName=[strName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *items = [[dictData  objectForKey:@"name"] componentsSeparatedByString:@"-!-"];
        NSString *str1=[items objectAtIndex:0];
        NSString *str2=[items objectAtIndex:1];
        if([str1 isEqualToString:@" "] || [str2 isEqualToString:@" "] ){
            
            NSString *phoneNum=[dictData objectForKey:@"number"];
            NSArray *arryVal=[phoneNum componentsSeparatedByString:@"-!-"];
            
            if([str1 isEqualToString:@" "]){
                strName=[NSString stringWithFormat:@"%@%@",[arryVal objectAtIndex:0],strName];
            }
            if([str2 isEqualToString:@" "]){
                
                strName=[NSString stringWithFormat:@"%@%@",strName,[arryVal objectAtIndex:0]];
            }
            lblName.text=strName;
        }else{
            lblName.text=strName;
        }
    }else{
        
       NSString *strName1=[strName stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([strName1 isEqualToString:@""]){
            
            lblName.text=[dictData objectForKey:@"number"];
        }else{
            lblName.text=strName;
        }

    }
    
    lblName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblName];

    float size=self.view.frame.size.width/2;
    //Button for clicking the paid ,presend and puncunality
    UIButton *btnpaid = [[UIButton alloc]initWithFrame:CGRectMake(size+6, 6,32,32)];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        btnpaid.frame=CGRectMake(size+6, 19,32,32);
    }
    
            [btnpaid addTarget:self
                       action:@selector(cmdPaid:)
             forControlEvents:UIControlEventTouchUpInside];
    btnpaid.tag=indexPath.row;
    if([arryPaid containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
        [btnpaid setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];

    }else{
        [btnpaid setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:btnpaid];
    UIButton *btnPunctuality = [[UIButton alloc]initWithFrame:CGRectMake(size+(size/3)+6,6,32,32)];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        btnPunctuality.frame=CGRectMake(size+(size/3)+6,19,32,32);
    }
    
    [btnPunctuality addTarget:self
                action:@selector(cmdPunctuality:)
      forControlEvents:UIControlEventTouchUpInside];
    btnPunctuality.tag=indexPath.row;
   
    if([arrPuncunality containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
        [btnPunctuality setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else{
        [btnPunctuality setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:btnPunctuality];
    
    UIButton *btnPresent = [[UIButton alloc]initWithFrame:CGRectMake(size+(size/3)*2+7,6,32,32)];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        btnPresent.frame=CGRectMake(size+(size/3)*2+7,19,32,32);
    }
    [btnPresent addTarget:self
                       action:@selector(cmdPresent:)
             forControlEvents:UIControlEventTouchUpInside];
    btnPresent.tag=indexPath.row;
    if([arrPresent containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
        [btnPresent setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else{
        [btnPresent setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];

    }
    [cell.contentView addSubview:btnPresent];
    
    //Logic For the Excel Mode line seprator
    int height=40;
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        height=70;
    }
    
     if(SCREEN_SIZE.height<667 ){
        UIView *sepPaidView=[[UIView alloc]initWithFrame:CGRectMake(size-7, 1,1, height)];
        sepPaidView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPaidView.alpha=0.5;
        [cell.contentView addSubview:sepPaidView];
        
        UIView *sepPunctualityView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)-5, 1,1, height)];
         sepPunctualityView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
         sepPunctualityView.alpha=0.5;
        [cell.contentView addSubview:sepPunctualityView];
        
        UIView *sepPresentView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)*2-5, 1,1, height)];
         sepPresentView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
         sepPresentView.alpha=0.5;
        [cell.contentView addSubview:sepPresentView];
        
    }else if(SCREEN_SIZE.height>666 && SCREEN_SIZE.height<670){
        UIView *sepPaidView=[[UIView alloc]initWithFrame:CGRectMake(size-11, 1,1, height)];
        sepPaidView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPaidView.alpha=0.5;
        [cell.contentView addSubview:sepPaidView];
        
        UIView *sepPunctualityView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)-10, 1,1, height)];
        sepPunctualityView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPunctualityView.alpha=0.5;
        [cell.contentView addSubview:sepPunctualityView];
        
        UIView *sepPresentView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)*2-7, 1,1, height)];
        sepPresentView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPresentView.alpha=0.5;
        [cell.contentView addSubview:sepPresentView];
    }else{
        UIView *sepPaidView=[[UIView alloc]initWithFrame:CGRectMake(size-11, 1,1, 60)];
        sepPaidView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPaidView.alpha=0.5;
        [cell.contentView addSubview:sepPaidView];
        
        UIView *sepPunctualityView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)-20, 1,1, height)];
        sepPunctualityView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPunctualityView.alpha=0.5;
        [cell.contentView addSubview:sepPunctualityView];
        
        UIView *sepPresentView=[[UIView alloc]initWithFrame:CGRectMake(size+(size/3)*2-10, 1,1, height)];
        sepPresentView.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
        sepPresentView.alpha=0.5;
        [cell.contentView addSubview:sepPresentView];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 80)];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
   // view.backgroundColor=[UIColor whiteColor];
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    NSArray *host_name=[dict objectForKey:@"host_name"];
    NSString *hostName=@"";
    for (int i=0; i<host_name.count; i++) {
        if(i==0){
            hostName=[NSString stringWithFormat:@"Hosted by : %@",[host_name objectAtIndex:i]];
        }else{
            hostName=[NSString stringWithFormat:@"%@,%@",hostName,[host_name objectAtIndex:i]];
        }
    }
    NSString *kitty_date=[dict objectForKey:@"kitty_date"];
    hostName=[NSString stringWithFormat:@"%@ on %@",hostName,kitty_date];
    UILabel *lblHostedName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
    lblHostedName.numberOfLines=4;
    lblHostedName.lineBreakMode=NSLineBreakByWordWrapping;
    lblHostedName.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblHostedName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblHostedName.text=hostName;
    lblHostedName.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblHostedName];
    
//    UIView *sepUpView=[[UIView alloc]initWithFrame:CGRectMake(10, 52,self.view.frame.size.width-20 , 1)];
//    sepUpView.backgroundColor=[UIColor lightGrayColor];
//    sepUpView.alpha=0.5;
//    [view addSubview:sepUpView];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 54, self.view.frame.size.width/2-20, 30)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=@"Name";
    lblName.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblName];
    
    float size=self.view.frame.size.width/2;
    UILabel *lblPaid = [[UILabel alloc]initWithFrame:CGRectMake(size-10, 54, size/3-7, 30)];
    lblPaid.numberOfLines=2;
    lblPaid.lineBreakMode=NSLineBreakByWordWrapping;
    lblPaid.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblPaid.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblPaid.text=@"Paid";
    lblPaid.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblPaid];
    
    UILabel *lblPunctuality = [[UILabel alloc]initWithFrame:CGRectMake(size+(size/3)-19, 54, size/3+17, 30)];
    lblPunctuality.numberOfLines=2;
    lblPunctuality.lineBreakMode=NSLineBreakByWordWrapping;
    lblPunctuality.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblPunctuality.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblPunctuality.text=@"Punctuality";
    lblPunctuality.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblPunctuality];
    
    UILabel *lblPresent = [[UILabel alloc]initWithFrame:CGRectMake(size+(size/3)*2, 54, size/3, 30)];
    lblPresent.numberOfLines=2;
    lblPresent.lineBreakMode=NSLineBreakByWordWrapping;
    lblPresent.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblPresent.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblPresent.text=@"Present";
    lblPresent.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblPresent];
    
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
//    if([self.is_host isEqualToString:@"0"])
//       return 40;
    return 120;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    fotterView.backgroundColor=[UIColor whiteColor];
    
    UIButton *btnSubmit = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 30)];
    [btnSubmit addTarget:self
                action:@selector(cmdSubmit:)
      forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];
    btnSubmit.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:11];//78,201,75
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0]];
    [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [fotterView addSubview:btnSubmit];
    
    
//    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/2-20, 30)];
//    lblName.numberOfLines=2;
//    lblName.lineBreakMode=NSLineBreakByWordWrapping;
//    lblName.font = [UIFont fontWithName:@"GothamMedium" size:11];
//    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
//    lblName.text=@"Total Collection";
//    lblName.textAlignment = NSTextAlignmentLeft;
//    [fotterView addSubview:lblName];
//    float size=self.view.frame.size.width/2;
//    UILabel *lblPaid = [[UILabel alloc]initWithFrame:CGRectMake(size-10, 0, size/3, 30)];
//    lblPaid.numberOfLines=2;
//    lblPaid.lineBreakMode=NSLineBreakByWordWrapping;
//    lblPaid.font = [UIFont fontWithName:@"GothamMedium" size:11];
//    lblPaid.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
//    lblPaid.text=@"70k";
//    lblPaid.textAlignment = NSTextAlignmentCenter;
//    [fotterView addSubview:lblPaid];
    
     NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
   
   // NSString *strGetPuncunality=[dict objectForKey:@"kitty_done"];
    UIButton *btnSelectPunctuality = [[UIButton alloc]initWithFrame:CGRectMake(10, 75, (self.view.frame.size.width-120)/2, 30)];
    [btnSelectPunctuality addTarget:self
                          action:@selector(cmdSelectRandomly:)
                forControlEvents:UIControlEventTouchUpInside];
    btnSelectPunctuality.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:12];//245,181,71
    [btnSelectPunctuality setBackgroundColor:[UIColor colorWithRed:245/255.0 green:181/255.0 blue:71/255.0 alpha:1.0]];
    btnSelectPunctuality.layer.cornerRadius=2;
    [btnSelectPunctuality setTitle:@"Punctuality" forState:UIControlStateNormal];
    [fotterView addSubview:btnSelectPunctuality];
    
    UIButton *btnSelectHost = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-120)/2+20, 75, (self.view.frame.size.width-80)/2, 30)];
    [btnSelectHost addTarget:self
                          action:@selector(cmdSelectHost:)
                forControlEvents:UIControlEventTouchUpInside];

    btnSelectHost.layer.cornerRadius=2;
    btnSelectHost.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:12];//0,188,212
    [btnSelectHost setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    [btnSelectHost setTitle:@"Select Host" forState:UIControlStateNormal];
    
//    if([kitty_done isEqualToString:@"1"]){
//        btnSubmit
//    }
  
    [fotterView addSubview:btnSelectHost];
    
    btnSelectHost.hidden=YES;
    btnSelectPunctuality.hidden=YES;
    btnSubmit.hidden=YES;
    NSArray *host_id=[dict objectForKey:@"host_id"];
    NSString *checkBlankHostID=@"NoBlankID";
    for (int i=0; i<host_id.count; i++) {
        NSString *idd=[host_id objectAtIndex:i];
        if([idd isEqualToString:@""]){
            checkBlankHostID=idd;
            break;
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    for (int i=0; i<host_id.count; i++) {
         NSString *idd=[host_id objectAtIndex:i];
        if([USERID isEqualToString:idd]){
            btnSelectHost.hidden=NO;
            btnSelectPunctuality.hidden=NO;
            btnSubmit.hidden=NO;

        }
    }
    
    if(([checkBlankHostID isEqualToString:@""]) && ([self.is_admin isEqualToString:@"1"])){
        btnSelectHost.hidden=NO;
        btnSelectPunctuality.hidden=NO;
        btnSubmit.hidden=NO;
    }
    
    
    NSArray *rightHost=[dict objectForKey:@"rights"];
    BOOL contains = [rightHost containsObject:USERID];
    if(contains){
        btnSelectHost.hidden=NO;
        btnSelectPunctuality.hidden=NO;
        btnSubmit.hidden=NO;
    }

    
//    UIButton *btnPlusHost = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 47, 48)];
////    [btnPlusHost addTarget:self
////                      action:@selector(cmdSelectManually:)
////            forControlEvents:UIControlEventTouchUpInside];
//    [btnPlusHost setBackgroundImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
//    [fotterView addSubview:btnPlusHost];
         [self.view addSubview:stack];
    
   
    return fotterView;
    
}
-(void)cmdSubmit:(id)sender{
    [self submitDiarieyData];
    return;
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    NSString *kitty_done=[dict objectForKey:@"kitty_done"];
    NSString *kitty_date=[dict objectForKey:@"kitty_date"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDate *Date=[dateFormatter dateFromString:kitty_date];
    NSDate *now = [NSDate date];
    if(!([kitty_done isEqualToString:@"1"] &&([now compare:Date]==NSOrderedSame || [now compare:Date]==NSOrderedDescending)) ){
        [AlertView showAlertWithMessage:[NSString stringWithFormat:@"You cannot edit this page before the Kitty Day - %@",kitty_date]];
        [arrPuncunality removeAllObjects];
        [arryPaid removeAllObjects];
        [arrPresent removeAllObjects];
        [self.tblDiary reloadData];
        return;
    }

    if(!([noOfPuncunality isEqualToString:@"0"])){
        if(!(arryPunculanitySelected.count>0)){
            if(kittyNumber==0){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"You want to take out Punctuality." delegate:self cancelButtonTitle:@"Now" otherButtonTitles:@"Later", nil];
                alert.tag=2;
                [alert show];
            }
        }else{
            [self submitDiarieyData];
        }
    }else{
        [self submitDiarieyData];
    }
}
-(void)submitDiarieyData{
    
    NSMutableDictionary *dictRespo=[[NSMutableDictionary alloc]init];
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    arrMember=[dict objectForKey:@"members"];
    NSMutableArray *arrData=[[NSMutableArray alloc]init];
    for (int i=0; i<arrMember.count; i++) {
        NSDictionary *dictData=[arrMember objectAtIndex:i];
        
        NSMutableDictionary *sendDict=[[NSMutableDictionary alloc]init];
        if([arryPaid containsObject:[NSString stringWithFormat:@"%d",i]]){
            [sendDict setObject:@"1" forKey:@"paid"];
        }else{
            [sendDict setObject:@"0" forKey:@"paid"];
        }
        if([arrPresent containsObject:[NSString stringWithFormat:@"%d",i]]){
            [sendDict setObject:@"1" forKey:@"present"];
        }else{
            [sendDict setObject:@"0" forKey:@"present"];
        }
        if([arrPuncunality containsObject:[NSString stringWithFormat:@"%d",i]]){
            [sendDict setObject:@"1" forKey:@"punctuality"];
        }else{
            [sendDict setObject:@"0" forKey:@"punctuality"];
        }
        [sendDict setObject:[dictData objectForKey:@"name"] forKey:@"name"];
        [sendDict setObject:[dictData objectForKey:@"number"] forKey:@"number"];
        [sendDict setObject:[dictData objectForKey:@"id"] forKey:@"id"];
        [arrData addObject:sendDict];
    }
    [dictRespo setObject:arrData forKey:@"members"];
    [dictRespo  setObject:[dict objectForKey:@"group_id"] forKey:@"group_id"];
    [dictRespo setObject:[dict objectForKey:@"id"] forKey:@"KittyId"];
    NSLog(@"dict %@",dictRespo);
    
    if(!([noOfPuncunality isEqualToString:@"0"])){
        if(!(arryPunculanitySelected)){
            [dictRespo setObject:@"0" forKey:@"get_punctuality"];
        }else{
            [dictRespo setObject:@"1" forKey:@"get_punctuality"];
        }
    }
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
   
    if(!(status == NotReachable)){
        [self.view addSubview:ind];
        [[ApiClient sharedInstance]submitDiaries:dictRespo success:^(id responseObject) {
            [ind removeFromSuperview];
            noOfTimePuncunalityClicked=0;
            [arryPunculanitySelected removeAllObjects];
            [AlertView showAlertWithMessage:@"Diary Updated Successfully."];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *arryOffline= [defaults objectForKey:@"OffLinedataStored"];
        NSArray *arryOfflineName= [defaults objectForKey:@"OffLinedataStoredName"];
        NSMutableArray *arrDataOfline;
        NSMutableArray *arryDataOfflineName;
        if(!(arryOffline)){
            arrDataOfline=[[NSMutableArray alloc]init];
            arryDataOfflineName=[[NSMutableArray alloc]init];
            
            NSMutableDictionary *dictTobeStored=[[NSMutableDictionary alloc]init];
            NSString *groupId=[dict objectForKey:@"group_id"];
            NSString *KittyId=[dict objectForKey:@"id"];
            NSString *strNameToBeGiven=[NSString stringWithFormat:@"%@%@",groupId,KittyId];
            [arryDataOfflineName addObject:strNameToBeGiven];
            
            [dictTobeStored setObject:dictRespo forKey:strNameToBeGiven];
            [arrDataOfline addObject:dictTobeStored];
        }else{
            arrDataOfline=[arryOffline mutableCopy];
            arryDataOfflineName=[arryOfflineName mutableCopy];
            NSMutableDictionary *dictTobeStored=[[NSMutableDictionary alloc]init];
            NSString *groupId=[dict objectForKey:@"group_id"];
            NSString *KittyId=[dict objectForKey:@"id"];
            NSString *strNameToBeGiven=[NSString stringWithFormat:@"%@%@",groupId,KittyId];
            
            NSArray *saveData= [arryOfflineName filteredArrayUsingPredicate:[NSPredicate
                                                                             predicateWithFormat:@"self == %@", strNameToBeGiven]];
            NSInteger containObjectIndex=[arryDataOfflineName indexOfObject:strNameToBeGiven];
            if(saveData.count>0){
                [arrDataOfline removeObjectAtIndex:containObjectIndex];
                [arryDataOfflineName removeObjectAtIndex:containObjectIndex];
            }
            [arryDataOfflineName addObject:strNameToBeGiven];
            [dictTobeStored setObject:dictRespo forKey:strNameToBeGiven];
            [arrDataOfline addObject:dictTobeStored];
        }
        NSArray *Arr=arrDataOfline;
        NSArray *arrName=arryDataOfflineName;
        [defaults setObject:arrName forKey:@"OffLinedataStoredName"];
        [defaults setObject:Arr forKey:@"OffLinedataStored"];
        [defaults synchronize];
        noOfTimePuncunalityClicked=0;
        [arryPunculanitySelected removeAllObjects];
         [AlertView showAlertWithMessage:@"Diary Updated Successfully."];
    }
}
-(void)cmdSelectHost:(id)sender{
    
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    NSString *kitty_done=[dict objectForKey:@"kitty_done"];
    NSString *kitty_date=[dict objectForKey:@"kitty_date"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDate *Date=[dateFormatter dateFromString:kitty_date];
    NSDate *now = [NSDate date];
    if(!([kitty_done isEqualToString:@"1"] &&([now compare:Date]==NSOrderedSame || [now compare:Date]==NSOrderedDescending)) ){
        [AlertView showAlertWithMessage:[NSString stringWithFormat:@"You cannot edit this page before the Kitty Day - %@",kitty_date]];
        return;
        
    }
    
    if([kitty_done isEqualToString:@"0"]){
        [AlertView showAlertWithMessage:@"Host has been already selected."];
        return;
    }
    if([leftKitties isEqualToString:@"0"]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *UserName= [prefs stringForKey:@"UserName"];
        [AlertView showAlertWithMessage:[NSString stringWithFormat:@"%@ Your's is the last kitty. Please ask the group admin to refresh the group.",UserName]];
        return;
    }
    
  
    NSString *strGuoupName=[NSString stringWithFormat:@"HOST%@",self.groupID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *hostselected = [defaults objectForKey:strGuoupName];
    if(hostselected){
        [AlertView showAlertWithMessage:@"Host has been already selected."];
        return;
    }
    SelcectHostViewController* controller = [[SelcectHostViewController alloc] initWithNibName:@"SelcectHostViewController" bundle:nil];
    controller.groupId=self.groupID;
    controller.noOfHost=noOfHost;
    controller.kitty_date=[dict objectForKey:@"kitty_date"];
    controller.strKittyId=[dict objectForKey:@"id"];
    controller.strCategory=self.strCategory;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdSelectRandomly:(id)sender{
    
    
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    NSString *kitty_done=[dict objectForKey:@"kitty_done"];
    NSString *kitty_date=[dict objectForKey:@"kitty_date"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDate *Date=[dateFormatter dateFromString:kitty_date];
    NSDate *now = [NSDate date];
    if(!([kitty_done isEqualToString:@"1"] &&([now compare:Date]==NSOrderedSame || [now compare:Date]==NSOrderedDescending)) ){
        [AlertView showAlertWithMessage:[NSString stringWithFormat:@"You cannot edit this page before the Kitty Day - %@",kitty_date]];
        return;
        
    }

    
    if([noOfPuncunality isEqualToString:@"0"]){
        [AlertView showAlertWithMessage:@"Punctuality-Not Applicable."];
    }else{
        
        NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
        NSString *get_punctuality=[dict objectForKey:@"get_punctuality"];
        if([get_punctuality isEqualToString:@"1" ]){
            [AlertView showAlertWithMessage:@"Punctuality has been already selected."];
            return;
        }
        if(arrPuncunality.count>0){
            puncunalityArry=[arrPuncunality mutableCopy];
            for (int i=0; i<arryPunculanitySelected.count; i++) {
                NSDictionary *DictSelected=[arryPunculanitySelected objectAtIndex:i];
                NSInteger index1 = [arrMember indexOfObject:DictSelected];
                [puncunalityArry removeObject:[NSString stringWithFormat:@"%ld",(long)index1]];
            }
            if([noOfPuncunality isEqualToString:@"1"]){
                if(noOfTimePuncunalityClicked==1){
                    [AlertView showAlertWithMessage:@"Punctuality has been already selected."];
                    return;
                }
                noOfTimePuncunalityClicked++;
               
                NSString *selectedMember=[arrPuncunality objectAtIndex: arc4random() % [arrPuncunality count]];
                NSDictionary *dictData=[arrMember objectAtIndex:[selectedMember intValue]];
                arryPunculanitySelected=[[NSMutableArray alloc]init];
                NSString *msg;
                if([[dictData objectForKey:@"name"] isEqualToString:@" "]){
                    msg=[NSString stringWithFormat:@"The Punctuality gose to %@",[dictData objectForKey:@"number"]];
                }else{
                    msg=[NSString stringWithFormat:@"The Punctuality gose to %@",[dictData objectForKey:@"name"]];
                }
              //  NSString *msg=[NSString stringWithFormat:@"The puncunality gose to %@",[dictData objectForKey:@"name"]];
                [self showPncunalityPopUp:msg];
                [arryPunculanitySelected addObject:dictData];
                [puncunalityArry removeObject:dictData];
                NSLog(@"hello %@",[arrPuncunality objectAtIndex: arc4random() % [puncunalityArry count]]);
            }else if([noOfPuncunality isEqualToString:@"2"]){
                if(noOfTimePuncunalityClicked==3){
                    [AlertView showAlertWithMessage:@"Both punctuality already selected."];
                    return;
                }
                noOfTimePuncunalityClicked++;
                
                NSString *selectedMember=[puncunalityArry objectAtIndex: arc4random() % [puncunalityArry count]];
                NSDictionary *dictData=[arrMember objectAtIndex:[selectedMember intValue]];
                if(noOfTimePuncunalityClicked==1){
                    
                    NSString *msg;
                    if([[dictData objectForKey:@"name"] isEqualToString:@" "]){
                        msg=[NSString stringWithFormat:@"The 1st goes to %@ now its turn for the 2nd Punctuality",[dictData objectForKey:@"number"]];
                    }else{
                        msg=[NSString stringWithFormat:@"The 1st goes to %@ now its turn for the 2nd Punctuality",[dictData objectForKey:@"name"]];
                    }
                    
                    [self showPncunalityPopUp:msg];
                     [puncunalityArry removeObject:dictData];
                }else{
                     NSString *msg;
                    if([[dictData objectForKey:@"name"] isEqualToString:@" "]){
                        msg=[NSString stringWithFormat:@"The 2nd  punctuality goes to %@",[dictData objectForKey:@"number"]];
                    }else{
                        msg=[NSString stringWithFormat:@"The 2nd  punctuality goes to %@",[dictData objectForKey:@"name"]];
                    }
                   // NSString *msg=[NSString stringWithFormat:@"The second  puncunality gose to %@",[dictData objectForKey:@"name"]];
                    [self showPncunalityPopUp:msg];
                     noOfTimePuncunalityClicked++;
                    
                }
                
                if(arryPunculanitySelected){
                    [arryPunculanitySelected addObject:dictData];
                }else{
                    arryPunculanitySelected=[[NSMutableArray alloc]init];
                    [arryPunculanitySelected addObject:dictData];
                }
            }
        }else{
            [AlertView showAlertWithMessage:@"Mark the members who are punctual to select the punctuality."];
        }
    }
    
}
-(void)showPncunalityPopUp:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
-(void)cmdPaid:(id)sender{
    UIButton *btnTag=(UIButton *)sender;
    long Tag=btnTag.tag;
    if([arryPaid containsObject:[NSString stringWithFormat:@"%ld",Tag]]){
        [arryPaid removeObject:[NSString stringWithFormat:@"%ld",Tag]];
    }else{
        [arryPaid addObject:[NSString stringWithFormat:@"%ld",Tag]];
    }
    [self.tblDiary reloadData];
}
-(void)cmdPunctuality:(id)sender{
    if([noOfPuncunality isEqualToString:@"0"]){
        [AlertView showAlertWithMessage:@"Punctuality is not applicable."];
    }else{
        UIButton *btnTag=(UIButton *)sender;
        long Tag=btnTag.tag;
        if([arrPuncunality containsObject:[NSString stringWithFormat:@"%ld",Tag]]){
            [arrPuncunality removeObject:[NSString stringWithFormat:@"%ld",Tag]];
        }else{
            [arrPuncunality addObject:[NSString stringWithFormat:@"%ld",Tag]];
        }
        [self.tblDiary reloadData];
    }
}
-(void)cmdPresent:(id)sender{
    UIButton *btnTag=(UIButton *)sender;
    long Tag=btnTag.tag;
    if([arrPresent containsObject:[NSString stringWithFormat:@"%ld",Tag]]){
        [arrPresent removeObject:[NSString stringWithFormat:@"%ld",Tag]];
    }else{
        [arrPresent addObject:[NSString stringWithFormat:@"%ld",Tag]];
    }
    [self.tblDiary reloadData];

}

#pragma mark - Animation

-(void)setAnimation{
    if(stack)
        [stack removeFromSuperview];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if( screenHeight > 480 && screenHeight < 667 ){
        NSLog(@"iPhone 5/5s");
         stack.frame=CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-120, 50, 50);
    } else if ( screenHeight > 480 && screenHeight < 736 ){
        NSLog(@"iPhone 6");
        stack.frame=CGRectMake(self.view.frame.size.width-10, self.view.frame.size.height-25, 50, 50);
    } else if ( screenHeight > 735 ){
        NSLog(@"iPhone 6 Plus");
        stack.frame=CGRectMake(screenRect.size.width-60, screenRect.size.height-120, 50, 50);
    } else {
         stack.frame=CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-210, 50, 50);
        NSLog(@"iPhone 4/4s");
    }
   
    contentView.layer.cornerRadius=25;
    stack.clipsToBounds=NO;
    [stack.layer setBorderWidth:0];
    [stack.layer setShadowColor:[UIColor blackColor].CGColor];
    [stack.layer setShadowOpacity:0.8];
    [stack.layer setShadowRadius:3.0];
    [stack.layer setShadowOffset:CGSizeMake(1, 1)];
    [stack setDelegate:self];
    
    UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"personal_notes-1"] highlightedImage:nil title:@"Personal Notes"];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"rules"] highlightedImage:nil title:@"Kitty Rules"];
    UPStackMenuItem *triangleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"bill"] highlightedImage:nil title:@"Bill"];
    UPStackMenuItem *crossItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"diary_notes"] highlightedImage:nil title:@"Kitty Notes"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:crossItem,triangleItem,circleItem,squareItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];

    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];

    [stack addItems:items];
   // [self.view addSubview:stack];
    [self setStackIconClosed:YES];

}
- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}
#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    [self.view addSubview:backView];
    [backView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [backView addGestureRecognizer:singleTap];
    [self.view bringSubviewToFront:stack];
    [self setStackIconClosed:NO];
}
- (void)oneTap:(UIGestureRecognizer *)gesture {
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMenu" object:self];

}
- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    [backView removeFromSuperview];
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    if(index==0){
         NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
        
        PersonalNotesViewController* controller = [[PersonalNotesViewController alloc] initWithNibName:@"PersonalNotesViewController" bundle:nil];
        controller.strPersonalNoteORKittyNotes=@"KITTY NOTES";
        controller.groupID=self.groupID;
        controller.kittyNo=[dict objectForKey:@"id"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(index==1){
        NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
        NSString *KittyId=[dict objectForKey:@"id"];
        NSString *kitty_done=[dict objectForKey:@"kitty_done"];
        NSString *kitty_date=[dict objectForKey:@"kitty_date"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *Date=[dateFormatter dateFromString:kitty_date];
        NSDate *now = [NSDate date];
        if(!([kitty_done isEqualToString:@"1"] || ([now compare:Date]==NSOrderedSame || [now compare:Date]==NSOrderedDescending)) ){
            [AlertView showAlertWithMessage:[NSString stringWithFormat:@"You cannot edit this page before the Kitty Day - %@",kitty_date]];
            [arrPuncunality removeAllObjects];
            return;
        }
        BillViewController* billController = [[BillViewController alloc] initWithNibName:@"BillViewController" bundle:nil];
        billController.group_id=self.groupID;
        billController.kitty_id=KittyId;
        [self.navigationController pushViewController:billController animated:YES];
        
    }else if(index==2){
        KittyRulesViewController* KittyRulesController = [[KittyRulesViewController alloc] initWithNibName:@"KittyRulesViewController" bundle:nil];
        KittyRulesController.isAdmin=self.is_admin;
        KittyRulesController.groupId=self.groupID;
        [self.navigationController pushViewController:KittyRulesController animated:YES];

    }else if(index==3){
        NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
        PersonalNotesViewController* controller = [[PersonalNotesViewController alloc] initWithNibName:@"PersonalNotesViewController" bundle:nil];
        controller.strPersonalNoteORKittyNotes=@"PERSONAL NOTES";
        controller.groupID=self.groupID;
        controller.kittyNo=[dict objectForKey:@"id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark Api

-(void)getDairies{
    
    [self.view addSubview:ind];
    [self.view bringSubviewToFront:ind];
    [[ApiClient sharedInstance]getDiaries:self.groupID success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strGuoupName=[NSString stringWithFormat:@"GroupDiaries%@",self.groupID];

        [defaults setObject:dict forKey:strGuoupName];
        [defaults synchronize];
        
        [self showData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}
-(void)getDairiesInBackGround{
    
    [[ApiClient sharedInstance]getDiaries:self.groupID success:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strGuoupName=[NSString stringWithFormat:@"GroupDiaries%@",self.groupID];
        [defaults setObject:dict forKey:strGuoupName];
        [defaults synchronize];
        
        NSDictionary *dataDict=[dict objectForKey:@"data"];
        leftKitties=[dataDict objectForKey:@"leftKitties"];
        noOfHost=[dataDict objectForKey:@"noOfHost"];
         noOfPuncunality=[dataDict objectForKey:@"noOfPunctuality"];
        arryKittys=[dataDict objectForKey:@"kitties"];
        kittyNumber=0;
        [self getMemberList];
        [self giveRightToEdit];
        [self.tblDiary reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
      // [self showData];
    }];
}


-(void)showData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strGuoupName=[NSString stringWithFormat:@"GroupDiaries%@",self.groupID];
    NSDictionary *dict= [defaults objectForKey:strGuoupName];
    NSDictionary *dataDict=[dict objectForKey:@"data"];
    noOfHost=[dataDict objectForKey:@"noOfHost"];
    noOfPuncunality=[dataDict objectForKey:@"noOfPunctuality"];
    arryKittys=[dataDict objectForKey:@"kitties"];
    leftKitties=[dataDict objectForKey:@"leftKitties"];

    kittyNumber=0;
    [self getMemberList];
    [self giveRightToEdit];
    [self.tblDiary reloadData];
    [self getDairiesInBackGround];
}


#pragma handling Animation for dfferent group

-(void)rightswipe{
    
    if(kittyNumber+1>=arryKittys.count){
        return;
    }
    
    kittyNumber++;
    [self getMemberList];
    [self giveRightToEdit];
    [self.tblDiary reloadData];
    [self swipeRightAnimation];
}

-(void)leftswipe{
    
    if(kittyNumber<0){
       
        return;
    }
    if(kittyNumber==0){
        //kittyNumber--;
        return;
    }
    kittyNumber--;
    
    [self getMemberList];
    [self giveRightToEdit];
    [self.tblDiary reloadData];
    [self swipeLeftAnimation];
    
}
-(void)getMemberList{
    
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    
    NSString *groupId=[dict objectForKey:@"group_id"];
    NSString *KittyId=[dict objectForKey:@"id"];
    NSString *strNameToBeGiven=[NSString stringWithFormat:@"%@%@",groupId,KittyId];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arryOfflineName= [defaults objectForKey:@"OffLinedataStoredName"];
    
    NSArray *saveData= [arryOfflineName filteredArrayUsingPredicate:[NSPredicate
                                                                     predicateWithFormat:@"self == %@", strNameToBeGiven]];
    NSInteger anIndex=[arryOfflineName indexOfObject:strNameToBeGiven];
    
    if(saveData.count>0){
        
        NSArray *OfflineData= [defaults objectForKey:@"OffLinedataStored"];
        NSDictionary *offlineDict=[OfflineData objectAtIndex:anIndex];
        NSDictionary *DictObje=[offlineDict objectForKey:strNameToBeGiven];
        arrMember=[DictObje objectForKey:@"members"];
    }else{
        arrMember=[dict objectForKey:@"members"];
    }

    [self.tblDiary reloadData];
}
-(void)giveRightToEdit{
    
    [arryPaid removeAllObjects];
    [arrPuncunality removeAllObjects];
    [arrPresent removeAllObjects];
    for (int i=0; i<arrMember.count; i++) {

        
        NSDictionary *dict=[arrMember objectAtIndex:i];
        NSString *strPaid=[dict objectForKey:@"paid"];
        NSString *strPresent=[dict objectForKey:@"present"];;
        NSString *strPunctuality=[dict objectForKey:@"punctuality"];
        if([strPaid isEqualToString:@"1"]){
            [arryPaid addObject:[NSString stringWithFormat:@"%d",i]];
        }
        if([strPresent isEqualToString:@"1"]){
            [arrPresent addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        if([strPunctuality isEqualToString:@"1"]){
            [arrPuncunality addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    NSDictionary *dict=[arryKittys objectAtIndex:kittyNumber];
    arrMember=[dict objectForKey:@"members"];
    NSArray *host_id=[dict objectForKey:@"host_id"];
    for (int i=0; i<host_id.count; i++) {
        NSString *idd=[host_id objectAtIndex:i];
        if([idd isEqualToString:@""]){
            checkBlankId=YES;
            break;
        }else{
            checkBlankId =NO;
        }
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    for (int i=0; i<host_id.count; i++) {
        NSString *idd=[host_id objectAtIndex:i];
        if([USERID isEqualToString:idd]){
            editTable=YES;
            break;
        }else{
            editTable=NO;
        }
    }
}

-(void)swipeRightAnimation{
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.6;
    transition.subtype = kCATransitionFromLeft;
    [self.tblDiary.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
}

-(void)swipeLeftAnimation{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.6;
    transition.subtype = kCATransitionFromRight;
    [self.tblDiary.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
}

#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1){
        if(buttonIndex==0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if(alertView.tag==2){
        if(buttonIndex==0){
            [self submitDiarieyData];
        }
    }
}

@end
