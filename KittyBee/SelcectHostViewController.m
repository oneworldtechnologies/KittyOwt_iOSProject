//
//  SelcectHostViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "SelcectHostViewController.h"
#import "ManuallyViewController.h"
#import "DiaryViewController.h"
@interface SelcectHostViewController (){
    IndecatorView *ind;
    NSArray *dataHost;
    NSMutableArray *notHostedMember;
    NSString *nextKittyDateValue;
    NSMutableArray *selectedHost;
}

@end

@implementation SelcectHostViewController

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
    if([self.summery isEqualToString:@"1"]){
        self.title=@"SUMMARY";//summary
    }else{
        self.title=@"SELECT HOST";
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.popUp.frame=CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    
    NSDate *now = [NSDate date];
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*1];
    self.datePicker.minimumDate=newDate1;
    self.datePicker.backgroundColor=[UIColor whiteColor];
    [self.datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    self.lblDate.text=self.kitty_date;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strListName=[NSString stringWithFormat:@"listHost%@",self.groupId];
    NSDictionary *dict= [defaults objectForKey:strListName];
    if(dict){
        [self showData];
    }else{
       [self getList];
    }
    
}

- (void)changeDate:(UIDatePicker *)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = sender.date;
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    self.lblDate.text=[dateFormatter stringFromDate:yourDate];
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        return  120;
    }
    
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataHost.count;
    
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
     NSDictionary *dict=[dataHost objectAtIndex:indexPath.row];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
       
        
        NSString *image=[dict objectForKey:@"profile_pic"];
        NSArray *arrImage = [image componentsSeparatedByString:@"-!-"];
        NSString *name=[dict objectForKey:@"name"];
        NSArray *arrName = [name componentsSeparatedByString:@"-!-"];
        NSString *phone=[dict objectForKey:@"number"];
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
        if (strURL1.length>3) {
            strURL=[strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            banner2.imageURL=[NSURL URLWithString:strURL1];
            banner2.clipsToBounds=YES;
            [banner2 setContentMode:UIViewContentModeScaleAspectFill];
            banner2.layer.cornerRadius=20;
            [cell.contentView addSubview:banner2];
        }
       
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
        
        
        
        UILabel *lblHosted=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 50, 100, 20)];
        NSString *strCurrentHost=[dict objectForKey:@"current_host"];
        strCurrentHost=[strCurrentHost stringByReplacingOccurrencesOfString:@"-!-" withString:@""];
        int vov=[strCurrentHost intValue];
        if(vov==0){
            NSString *strHost=[dict objectForKey:@"host"];
            strHost=[strHost stringByReplacingOccurrencesOfString:@"-!-" withString:@""];
            int vo=[strHost intValue];
            if(vo>0){
                lblHosted.text=@"Hosted Successfully";
                lblHosted.backgroundColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
            }else{
                lblHosted.text=@"Not Hosted";
                lblHosted.backgroundColor=[UIColor colorWithRed:157/255.0 green:230/255.0 blue:239/255.0 alpha:1.0];
            }
        }else{
            lblHosted.text=@"Current Host";
            lblHosted.backgroundColor=[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0];
        }
        
        lblHosted.numberOfLines=2;
        lblHosted.lineBreakMode=NSLineBreakByWordWrapping;
        lblHosted.font = [UIFont fontWithName:@"GothamMedium" size:8];
        lblHosted.textColor= [UIColor whiteColor];
        
        lblHosted.textAlignment = NSTextAlignmentCenter;
        lblHosted.layer.cornerRadius=10;
        lblHosted.clipsToBounds=YES;
        [cell.contentView addSubview:lblHosted];
        
        
        
        
        UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(20, 120,self.view.frame.size.width-40 , 1)];
        sepView.backgroundColor=[UIColor lightGrayColor];
        sepView.alpha=0.5;
        [cell.contentView addSubview:sepView];
        
        

    }else{
        
        
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner.showActivityIndicator=YES;
        NSString *strImgUrl=[dict objectForKey:@"profile_pic"];
        strImgUrl=[strImgUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strImgUrl];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        banner.layer.cornerRadius=20;
        [cell.contentView addSubview:banner];
        
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 130, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text=[dict objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 15)];
        lblList.backgroundColor=[UIColor clearColor];
        lblList.numberOfLines=2;
        lblList.lineBreakMode=NSLineBreakByWordWrapping;
        lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList.text=[dict objectForKey:@"number"];
        lblList.alpha=0.5;
        lblList.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList];
        
        
        UILabel *lblHosted=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 20, 100, 20)];
        NSString *strCurrentHost=[dict objectForKey:@"current_host"];
        
        
        if([strCurrentHost isEqualToString:@"0"]){
            NSString *strHost=[dict objectForKey:@"host"];
            
            if([strHost isEqualToString:@"1"]){
                lblHosted.text=@"Hosted Successfully";//78,201,75
                lblHosted.backgroundColor=[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0];
            }else{
                lblHosted.text=@"Not Hosted";//0,188,212
                lblHosted.backgroundColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
            }
        }else{
            lblHosted.text=@"Current Host";//245,181,71
            lblHosted.backgroundColor=[UIColor colorWithRed:245/255.0 green:181/255.0 blue:71/255.0 alpha:1.0];
        }
        
        lblHosted.numberOfLines=2;
        lblHosted.lineBreakMode=NSLineBreakByWordWrapping;
        lblHosted.font = [UIFont fontWithName:@"GothamMedium" size:8];
        lblHosted.textColor= [UIColor whiteColor];
        
        lblHosted.textAlignment = NSTextAlignmentCenter;
        lblHosted.layer.cornerRadius=10;
        lblHosted.clipsToBounds=YES;
        [cell.contentView addSubview:lblHosted];
        
        UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(20, 59,self.view.frame.size.width-40 , 1)];//128,222,234
        sepView.backgroundColor=[UIColor colorWithRed:128/255.5 green:222/255.0 blue:234/255.0 alpha:1.0];
        sepView.alpha=0.5;
        [cell.contentView addSubview:sepView];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([self.summery isEqualToString:@"1"]){
        return 0;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    if([self.summery isEqualToString:@"1"]){
        fotterView.frame=CGRectMake(0, 0, self.view.frame.size.width, 0);
    }
    fotterView.backgroundColor=[UIColor whiteColor];
        UIButton *btnSelectRandomly = [[UIButton alloc]initWithFrame:CGRectMake(30, 15, (self.view.frame.size.width-80)/2, 30)];
        [btnSelectRandomly addTarget:self
                    action:@selector(cmdSelectRandomly:)
          forControlEvents:UIControlEventTouchUpInside];
        btnSelectRandomly.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:12];//245,181,71
        [btnSelectRandomly setBackgroundColor:[UIColor colorWithRed:245/255.0 green:181/255.0 blue:71/255.0 alpha:1.0]];
    btnSelectRandomly.layer.cornerRadius=2;
        [btnSelectRandomly setTitle:@"Select Randomly" forState:UIControlStateNormal];
        [fotterView addSubview:btnSelectRandomly];
    
    UIButton *btnSelectManually = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2+50, 15, (self.view.frame.size.width-80)/2, 30)];
    [btnSelectManually addTarget:self
                          action:@selector(cmdSelectManually:)
                forControlEvents:UIControlEventTouchUpInside];
    btnSelectManually.layer.cornerRadius=2;
    btnSelectManually.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:12];//0,188,212
    [btnSelectManually setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    [btnSelectManually setTitle:@"Select Manually" forState:UIControlStateNormal];
    [fotterView addSubview:btnSelectManually];
    
    return fotterView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 30)];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];;
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/3-10, 30)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=@"Particpants";
    lblName.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblName];
    
    UILabel *lblNumber=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 0, 100, 30)];
    lblNumber.numberOfLines=2;
    lblNumber.lineBreakMode=NSLineBreakByWordWrapping;
    lblNumber.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblNumber.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    
    lblNumber.text=[NSString stringWithFormat:@"%lu",(unsigned long)dataHost.count];
    lblNumber.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblNumber];
    return view;
}


-(NSString *)getName:(NSDictionary *)dictData{
     NSString *strName=[dictData  objectForKey:@"name"];
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        strName=[strName stringByReplacingOccurrencesOfString:@" " withString:@""];
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
            return strName;
        }else{
            return strName;
        }
    }else{
        
        NSString *strName1=[strName stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([strName1 isEqualToString:@""]){
            
            return [dictData objectForKey:@"number"];
        }else{
            return strName;
        }
    }

}
-(void)cmdSelectRandomly:(id)sender{
    
    int totalHost=[self.noOfHost intValue];
    if(selectedHost.count>totalHost){
        
        
    }else{
        NSDictionary *selectedmember=[notHostedMember objectAtIndex: arc4random() % [notHostedMember count]];
        if(!(selectedHost)){
            selectedHost=[[NSMutableArray alloc]init];
        }
            [selectedHost addObject:selectedmember];
        if(totalHost==1){
            
            self.lblHostName.text=[self getName:selectedmember];
        }else if(totalHost==2){
            NSString *msg;
            if(selectedHost.count==1){
                msg=[NSString stringWithFormat:@"New host is %@, Now select second host for kitty",[self getName:selectedmember]];
                 [AlertView showAlertWithMessage:msg];
                 self.lblHostName.text=[self getName:selectedmember];
            }else if(selectedHost.count==2){
                 self.lblHostName.text=[NSString stringWithFormat:@"%@,%@",self.lblHostName.text,[self getName:selectedmember]];
            }
        }else if(totalHost==3){
            NSString *msg;
            if(selectedHost.count==1){
                msg=[NSString stringWithFormat:@"New host is %@, Now select second host for kitty",[self getName:selectedmember]];
                [AlertView showAlertWithMessage:msg];
                self.lblHostName.text=[selectedmember objectForKey:@"name"];
            }else if(selectedHost.count==2){
                msg=[NSString stringWithFormat:@"Second host for kitty is %@, Now select third host for kitty",[self getName:selectedmember]];
                [AlertView showAlertWithMessage:msg];
                 self.lblHostName.text=[NSString stringWithFormat:@"%@,%@",self.lblHostName.text,[self getName:selectedmember]];
            }else if(selectedHost.count==3){
                 self.lblHostName.text=[NSString stringWithFormat:@"%@,%@",self.lblHostName.text,[self getName:selectedmember]];
            }
            
        }
            self.lblHostName.text=[self.lblHostName.text stringByReplacingOccurrencesOfString:@"-!-" withString:@","];
            if(selectedHost.count==totalHost){
        
                
                self.popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                
                [self.view addSubview:self.popUp];
                
                [UIView animateWithDuration:0.3/1.5 animations:^{
                    self.popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/2 animations:^{
                        self.popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/2 animations:^{
                            self.popUp.transform = CGAffineTransformIdentity;
                        }];
                    }];
                }];

                
        
            }
    }
}

-(void)cmdSelectManually:(id)sender{
    ManuallyViewController* controller = [[ManuallyViewController alloc] initWithNibName:@"ManuallyViewController" bundle:nil];
    controller.noOfHost=self.noOfHost;
    controller.kitty_date=self.kitty_date;
    controller.arryHostValue=notHostedMember;
    controller.nextKittyDateValue=nextKittyDateValue;
    controller.groupId=self.groupId;
    controller.strCategory=self.strCategory;
    controller.strKittyId=self.strKittyId;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)getList{
    [self.view addSubview:ind];
    
    [[ApiClient sharedInstance]hostList:self.groupId success:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strListName=[NSString stringWithFormat:@"listHost%@",self.groupId];
        [defaults setObject:dict forKey:strListName];
        [defaults synchronize];
        [self showData];
        
        [ind removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}
-(void)getListInBackground{
    
    [[ApiClient sharedInstance]hostList:self.groupId success:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strListName=[NSString stringWithFormat:@"listHost%@",self.groupId];
        [defaults setObject:dict forKey:strListName];
        [defaults synchronize];
        [self showDataBAckGround];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
    }];
}

-(void)showDataBAckGround{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strListName=[NSString stringWithFormat:@"listHost%@",self.groupId];
    NSDictionary *dict= [defaults objectForKey:strListName];
    self.lblDate.text=[dict objectForKey:@"kittynext"];
    self.kitty_date=[dict objectForKey:@"kittynext"];
    dataHost=[dict objectForKey:@"data"];
    notHostedMember=[[NSMutableArray alloc]init];
    for (int i=0; i<dataHost.count; i++) {
        NSDictionary *dict1=[dataHost objectAtIndex:i];
        NSString *strHost=[dict1 objectForKey:@"host"];
        if([self.strCategory isEqualToString:@"Couple Kitty"]){
            strHost=[strHost stringByReplacingOccurrencesOfString:@"-!-" withString:@""];
            int vo=[strHost intValue];
            if(vo==0){
                [notHostedMember addObject:dict1];
            }
        }else{
            if([strHost isEqualToString:@"0"]){
                [notHostedMember addObject:dict1];
            }
        }
        
    }
    //NSString *strHost=[dict objectForKey:@"host"];
    nextKittyDateValue=[dict objectForKey:@"kittynext"];
    [self.tblSelectHost reloadData];
    
}


-(void)showData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strListName=[NSString stringWithFormat:@"listHost%@",self.groupId];
    NSDictionary *dict= [defaults objectForKey:strListName];
    self.lblDate.text=[dict objectForKey:@"kittynext"];
    self.kitty_date=[dict objectForKey:@"kittynext"];
    dataHost=[dict objectForKey:@"data"];
    notHostedMember=[[NSMutableArray alloc]init];
    for (int i=0; i<dataHost.count; i++) {
        NSDictionary *dict1=[dataHost objectAtIndex:i];
        NSString *strHost=[dict1 objectForKey:@"host"];
        if([self.strCategory isEqualToString:@"Couple Kitty"]){
            strHost=[strHost stringByReplacingOccurrencesOfString:@"-!-" withString:@""];
            int vo=[strHost intValue];
            if(vo==0){
                [notHostedMember addObject:dict1];
            }
        }else{
            if([strHost isEqualToString:@"0"]){
                [notHostedMember addObject:dict1];
            }
        }
        
    }
    //NSString *strHost=[dict objectForKey:@"host"];
    nextKittyDateValue=[dict objectForKey:@"kittynext"];
    [self.tblSelectHost reloadData];
    [self getListInBackground];

}
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        }
}
- (IBAction)cmdDone:(id)sender {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(!(status == NotReachable)){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:self.lblDate.text forKey:@"kitty_date"];
        [dict setObject:selectedHost forKey:@"member"];
        [dict setObject:self.groupId forKey:@"groupId"];
        [dict setObject:self.strKittyId forKey:@"KittyId"];
        [[ApiClient  sharedInstance]selectHost:self.groupId dict:dict success:^(id responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [AlertView showAlertWithMessage:errorString];
        }];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:self.lblDate.text forKey:@"kitty_date"];
        [dict setObject:selectedHost forKey:@"member"];
        [dict setObject:self.groupId forKey:@"groupId"];
        [dict setObject:self.strKittyId forKey:@"KittyId"];
        NSMutableArray *arryData= [[defaults objectForKey:@"HOST"] mutableCopy];
        if(!(arryData)){
            arryData=[[NSMutableArray alloc]init];
        }
        [arryData addObject:dict];
        [defaults setObject:arryData forKey:@"HOST"];
        [defaults synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end
