//
//  SelectCoupleViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "SelectCoupleViewController.h"

@interface SelectCoupleViewController (){
    long tabeleRowSelected;
    long rowSelected;
    IndecatorView *ind;

}

@end

@implementation SelectCoupleViewController
@synthesize arryCoupleSlelected;
- (void)viewDidLoad {
    [super viewDidLoad];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReset.frame = CGRectMake(0, 0, 32, 32);
    [btnReset setImage:[UIImage imageNamed:@"reset@1x"] forState:UIControlStateNormal];
    
    [btnReset addTarget:self action:@selector(cmdReset:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnReset];
    [arrRightBarItems addObject:btnGroupBar];
    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    NSLog(@"%@",self.totalMember);
    if([self.addMemeber isEqualToString:@"yes"]){
        [self cmdReset:nil];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)cmdReset:(id)sender{
    //totalMember
    self.arrMember=[self.totalMember mutableCopy];
    [self.arryCoupleSlelected removeAllObjects];//totalADDMember
    [self.tblSelectCouple reloadData];
    if(!([self.addMemeber isEqualToString:@"yes"])){
        NSMutableDictionary *dictionary=[[NSMutableDictionary   alloc]init];
        [dictionary setObject:arryCoupleSlelected forKey:@"Couple"];
        [dictionary setObject:self.arrMember forKey:@"notSelectedCouple"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCouplesToKittyRulesPage" object:nil userInfo:dictionary];
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!(arryCoupleSlelected))
    arryCoupleSlelected=[[NSMutableArray alloc]init];
    self.title=@"SELECT COUPLE";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
    return self.arrMember.count;
    
    return arryCoupleSlelected.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section==0)
    return  60;
    
    return 120;
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
    if(indexPath.section==0){
    NSDictionary *dict=[self.arrMember objectAtIndex:indexPath.row];
    
    AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
    banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    banner.showActivityIndicator=YES;
    NSString *strURL=[dict objectForKey:@"image"];
    strURL=[strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    banner.imageURL=[NSURL URLWithString:strURL];
    banner.clipsToBounds=YES;
    [banner setContentMode:UIViewContentModeScaleAspectFill];
    banner.layer.cornerRadius=20;
    [cell.contentView addSubview:banner];
    
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 160, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=[dict objectForKey:@"name"];
    lblName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblName];
    
    UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 25)];
    lblList.backgroundColor=[UIColor clearColor];
    lblList.numberOfLines=2;
    lblList.lineBreakMode=NSLineBreakByWordWrapping;
    lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
    lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblList.text=[dict objectForKey:@"phone"];
    lblList.alpha=0.5;
    lblList.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblList];
    
    
    UIView *sep=[[UIView alloc]initWithFrame:CGRectMake(20, 59, self.view.frame.size.width, 1)];//78,201,75
    sep.backgroundColor=[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0];
    sep.alpha=0.5;
    [cell.contentView addSubview:sep];
    
    
    UIButton *btnHost = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, 12, 35, 35)];
    //        [button addTarget:self
    //                   action:@selector(aMethod:)
    //         forControlEvents:UIControlEventTouchUpInside];
    [btnHost setImage:[UIImage imageNamed:@"select-couple"] forState:UIControlStateNormal];
    [cell.contentView addSubview:btnHost];
    }else{
        NSDictionary *dict=[arryCoupleSlelected objectAtIndex:indexPath.row];
        
        NSString *image=[dict objectForKey:@"image"];
        NSArray *arrImage = [image componentsSeparatedByString:@"-!-"];
        NSString *name=[dict objectForKey:@"name"];
        NSArray *arrName = [name componentsSeparatedByString:@"-!-"];
        NSString *phone=[dict objectForKey:@"phone"];
         NSArray *arrPhone= [phone componentsSeparatedByString:@"-!-"];
        
       // NSString *registeration=[dict objectForKey:@"registeration"];
        
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner.showActivityIndicator=YES;
        NSString *strURL=[arrImage objectAtIndex:0];
        strURL=[strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strURL];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        banner.layer.cornerRadius=20;
        [cell.contentView addSubview:banner];
        
        AsyncImageView *banner2=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 70,40,40)];
        banner2.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner2.showActivityIndicator=YES;
        NSString *strURL1=[arrImage objectAtIndex:1];
        strURL=[strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner2.imageURL=[NSURL URLWithString:strURL1];
        banner2.clipsToBounds=YES;
        [banner2 setContentMode:UIViewContentModeScaleAspectFill];
        banner2.layer.cornerRadius=20;
        [cell.contentView addSubview:banner2];
        
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 160, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text=[arrName objectAtIndex:0];
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UILabel *lblName2=[[UILabel alloc]initWithFrame:CGRectMake(60, 70, 160, 20)];
        lblName2.backgroundColor=[UIColor clearColor];
        lblName2.numberOfLines=2;
        lblName2.lineBreakMode=NSLineBreakByWordWrapping;
        lblName2.font = [UIFont fontWithName:@"GothamMedium" size:14];
        lblName2.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName2.text=[arrName objectAtIndex:1];
        lblName2.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName2];
        
        
        UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 25)];
        lblList.backgroundColor=[UIColor clearColor];
        lblList.numberOfLines=2;
        lblList.lineBreakMode=NSLineBreakByWordWrapping;
        lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList.text=[arrPhone objectAtIndex:0];
        lblList.alpha=0.5;
        lblList.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList];
        
        UILabel *lblList2=[[UILabel alloc]initWithFrame:CGRectMake(60, 90, 200, 25)];
        lblList2.backgroundColor=[UIColor clearColor];
        lblList2.numberOfLines=2;
        lblList2.lineBreakMode=NSLineBreakByWordWrapping;
        lblList2.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList2.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList2.text=[arrPhone objectAtIndex:1];
        lblList2.alpha=0.5;
        lblList2.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList2];

        UIButton *btnHost = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, 42, 35, 35)];
        //        [button addTarget:self
        //                   action:@selector(aMethod:)
        //         forControlEvents:UIControlEventTouchUpInside];
        btnHost.userInteractionEnabled=NO;
        [btnHost setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnHost];
        
        UIView *sep=[[UIView alloc]initWithFrame:CGRectMake(20, 119, self.view.frame.size.width, 1)];
        sep.backgroundColor=sep.backgroundColor=[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0];
        sep.alpha=0.5;
        [cell.contentView addSubview:sep];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
    if(self.arrMember.count>0){
        return 40;
    }else{
        return 0;
    }
    }else{
        if(arryCoupleSlelected.count>0){
            return 40;
        }else{
            return 0;
        }
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
    UILabel *lblMemberName=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width/2-20, 30)];
    lblMemberName.numberOfLines=2;
    lblMemberName.lineBreakMode=NSLineBreakByWordWrapping;
    lblMemberName.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblMemberName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblMemberName.text=@"Name of Member";
    lblMemberName.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:lblMemberName];
    
    UILabel *lblSelectCouple = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 5, 120, 30)];
    lblSelectCouple.numberOfLines=2;
    lblSelectCouple.lineBreakMode=NSLineBreakByWordWrapping;
    lblSelectCouple.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblSelectCouple.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    if(section==0){
    lblSelectCouple.text=@"Select couple";
    }else{
        lblSelectCouple.text=@"Selected couple";
        lblSelectCouple.frame=CGRectMake(self.view.frame.size.width-140, 5, 120, 30);
    }
    lblSelectCouple.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblSelectCouple];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tabeleRowSelected=indexPath.row;
    [self addDatePicker];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *btnnext = [[UIButton alloc]initWithFrame:fotterView.frame];
    [btnnext addTarget:self
                action:@selector(cmdDone:)
      forControlEvents:UIControlEventTouchUpInside];
    btnnext.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];
    [btnnext setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    [btnnext setTitle:@"DONE" forState:UIControlStateNormal];
    [fotterView addSubview:btnnext];
    return fotterView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0)
        return 0;
    return 40;
}
-(void)cmdDone:(id)sender{
    
    if([self.addMemeber isEqualToString:@"yes"]){
        NSMutableArray *mutableArry=[[NSMutableArray alloc]init];
        for (int i=0; i<arryCoupleSlelected.count; i++) {
            NSDictionary *dict=[arryCoupleSlelected objectAtIndex:i];
            [mutableArry addObject:dict];
        }
        for (int i=0; i<self.arrMember.count; i++) {
            NSDictionary *dict=[self.arrMember objectAtIndex:i];
            [mutableArry addObject:dict];
        }
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:mutableArry forKey:@"member"];
        [dict setObject:self.groupId forKey:@"group_id"];
        [self.view addSubview:ind];
        [[ApiClient sharedInstance]addSelectedMembers:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            [self.navigationController popToRootViewControllerAnimated:YES];
            [AlertView showAlertWithMessage:[dict objectForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];

        
        
    }else{
        
        if(arryCoupleSlelected.count>0){
            NSMutableDictionary *dictionary=[[NSMutableDictionary   alloc]init];
            [dictionary setObject:arryCoupleSlelected forKey:@"Couple"];
            [dictionary setObject:self.arrMember forKey:@"notSelectedCouple"];
            
            // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arryCoupleSlelected forKey:@"Couple"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCouplesToKittyRulesPage" object:nil userInfo:dictionary];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"You have not paired any Couple.Do you want to continue ?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSMutableDictionary *dictionary=[[NSMutableDictionary   alloc]init];
        [dictionary setObject:arryCoupleSlelected forKey:@"Couple"];
        [dictionary setObject:self.arrMember forKey:@"notSelectedCouple"];
        
        // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arryCoupleSlelected forKey:@"Couple"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCouplesToKittyRulesPage" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];    }
    if(buttonIndex==1){
         NSLog(@"10");
    }

}

-(void)addDatePicker{
    
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
    
    UIPickerView *datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, screenRect.size.width, 216)] ;
    datePicker.tag = 10;
    datePicker.delegate = self;
    datePicker.dataSource = self;
    datePicker.showsSelectionIndicator = YES;
    datePicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, screenRect.size.width, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDoneDatePicker:)] ;
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
- (void)dismissDoneDatePicker:(id)sender{
    if(tabeleRowSelected==rowSelected){
        [AlertView showAlertWithMessage:@"can't select same person as a patner."];
        rowSelected=0;
    }else{
   
    NSDictionary *dictTableRowSelected=[self.arrMember objectAtIndex:tabeleRowSelected];
    NSDictionary *dictPickerRowSelected=[self.arrMember objectAtIndex:rowSelected];
    
    NSString *image=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"image"],[dictPickerRowSelected objectForKey:@"image"]];
    NSString *name=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"name"],[dictPickerRowSelected objectForKey:@"name"]];
    NSString *phone=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"phone"],[dictPickerRowSelected objectForKey:@"phone"]];
    NSString *registeration=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"registeration"],[dictPickerRowSelected objectForKey:@"registeration"]];
    NSString *status=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"status"],[dictPickerRowSelected objectForKey:@"status"]];
    NSString *is_host=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"is_host"],[dictPickerRowSelected objectForKey:@"is_host"]];
        NSString *userid=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"userid"],[dictPickerRowSelected objectForKey:@"userid"]];
        
       
    NSMutableDictionary *dictCombind=[[NSMutableDictionary   alloc]init];
        if([self.strMakingkitty isEqualToString:@"yes"]){
            NSString *userMemberId=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"member_id"],[dictPickerRowSelected objectForKey:@"member_id"]];
            [dictCombind setObject:userMemberId forKey:@"member_id"];
        }
    [dictCombind setObject:image forKey:@"image"];
    [dictCombind setObject:name forKey:@"name"];
    [dictCombind setObject:phone forKey:@"phone"];
    [dictCombind setObject:registeration forKey:@"registeration"];
    [dictCombind setObject:status forKey:@"status"];
    [dictCombind setObject:userid forKey:@"userid"];
    if([self.strInMiddelKitty isEqualToString:@"Yes"]){
         [dictCombind setObject:is_host forKey:@"is_host"];
    }
    
        if([self.addMemeber isEqualToString:@"yes"]){
            NSString *memberId;
             memberId=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"mamber_id"],[dictPickerRowSelected objectForKey:@"mamber_id"]];
            NSString *strMemberIdDictTableRowSelected=[dictTableRowSelected objectForKey:@"mamber_id"];
            NSString *strMemberIddictPickerRowSelected=[dictPickerRowSelected objectForKey:@"mamber_id"];
            
            if(!(strMemberIdDictTableRowSelected) && !(strMemberIddictPickerRowSelected)){//ff
                 memberId=[NSString stringWithFormat:@"0-!-0"];
                
            }else if(!(strMemberIdDictTableRowSelected) && strMemberIddictPickerRowSelected){//ft
                 memberId=[NSString stringWithFormat:@"0-!-%@",[dictPickerRowSelected objectForKey:@"mamber_id"]];
                
            }else if(strMemberIdDictTableRowSelected && !(strMemberIddictPickerRowSelected)){//tf
                memberId=[NSString stringWithFormat:@"%@-!-0",[dictTableRowSelected objectForKey:@"mamber_id"]];
            }else if(strMemberIdDictTableRowSelected && strMemberIddictPickerRowSelected){//tt
                  memberId=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"mamber_id"],[dictPickerRowSelected objectForKey:@"mamber_id"]];
            }
            
            
             NSString *isPaid=[NSString stringWithFormat:@"%@-!-%@",[dictTableRowSelected objectForKey:@"is_Paid"],[dictPickerRowSelected objectForKey:@"is_Paid"]];
            [dictCombind setObject:isPaid forKey:@"is_Paid"];
            
            
             [dictCombind setObject:memberId forKey:@"mamber_id"];
            
                      
            if(!(strMemberIdDictTableRowSelected) && !(strMemberIddictPickerRowSelected)){//ff
                [dictCombind setObject:@"0-!-0" forKey:@"is_member"];
                
            }else if(!(strMemberIdDictTableRowSelected) && strMemberIddictPickerRowSelected){//ft
                [dictCombind setObject:@"0-!-1" forKey:@"is_member"];
                
            }else if(strMemberIdDictTableRowSelected && !(strMemberIddictPickerRowSelected)){//tf
                [dictCombind setObject:@"1-!-0" forKey:@"is_member"];
            }else if(strMemberIdDictTableRowSelected && strMemberIddictPickerRowSelected){//tt
                [dictCombind setObject:@"1-!-1" forKey:@"is_member"];
            }
            
        }
    [arryCoupleSlelected addObject:dictCombind];
        if(rowSelected>tabeleRowSelected){
             [self.arrMember removeObjectAtIndex:rowSelected];
             [self.arrMember removeObjectAtIndex:tabeleRowSelected];
        }else{
             [self.arrMember removeObjectAtIndex:tabeleRowSelected];
             [self.arrMember removeObjectAtIndex:rowSelected];
        }
        rowSelected=0;
    [self.tblSelectCouple reloadData];
    NSLog(@"dict: %@",dictCombind);
        [self dismissDatePicker:sender];
    }
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

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrMember.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict=[self.arrMember objectAtIndex:row];
    NSString *strPickerValue=[NSString stringWithFormat:@"%@:%@",[dict objectForKey:@"name"],[dict objectForKey:@"phone"]];
    return strPickerValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        rowSelected=row;
}
@end
