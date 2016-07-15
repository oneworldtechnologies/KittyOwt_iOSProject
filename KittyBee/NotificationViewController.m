//
//  NotificationViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 25/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "NotificationViewController.h"
#import "InvatationCardViewController.h"
@interface NotificationViewController (){
    IndecatorView *ind;
    NSArray *arryNotification;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"NOTIFICATIONS";
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSString *strnotific=[NSString stringWithFormat:@"%@Notify",USERID];
    NSArray *arry= [prefs objectForKey:strnotific];
    
    if(arry)
    {
        arryNotification=arry;
        [self.tblNotification reloadData];
        [self getNotificationInBackGround];
    }else{
        [self getNotification];
    }
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setImage:[UIImage imageNamed:@"clear_all"] forState:UIControlStateNormal];
    btnClear.frame = CGRectMake(0, 0, 50, 13);
    
    [btnClear addTarget:self action:@selector(cmdClear:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnClear];
    [arrRightBarItems addObject:btnSearchBar];
    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cmdClear:(id)sender{
    [self.view addSubview:ind];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:USERID forKey:@"user_id"];
    [[ApiClient sharedInstance]deleteNotification:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictData=responseObject;
        arryNotification=[dictData objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strnotific=[NSString stringWithFormat:@"%@Notify",USERID];
        [defaults setObject:arryNotification forKey:strnotific];
        [defaults synchronize];
        [self.tblNotification reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arryNotification.count;
    
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
    NSDictionary *dict=[arryNotification objectAtIndex:indexPath.row];
    AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 20,40,40)];
    banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    NSString *strUrl=[dict objectForKey:@"groupImg"];
    strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    banner.image=[UIImage imageNamed:@"DefualtImg.png"];
    banner.imageURL=[NSURL URLWithString:strUrl];
    //
    banner.clipsToBounds=YES;
    [banner setContentMode:UIViewContentModeScaleAspectFill];
    banner.layer.cornerRadius=20;
    [cell.contentView addSubview:banner];
    
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(65, 20, 175, 40)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamBook" size:14];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=[dict objectForKey:@"message"];
    lblName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblName];
    
    UILabel *lbltime=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 70, 20)];
    lbltime.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    lbltime.font = [UIFont fontWithName:@"GothamBook" size:10];
    lbltime.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lbltime.text=[dict objectForKey:@"notifyTime"];
    lbltime.layer.cornerRadius=10;
    lbltime.clipsToBounds=YES;
    lblName.baselineAdjustment=UIBaselineAdjustmentNone;
    lbltime.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lbltime];
    NSString *type=[dict objectForKey:@"type"];
    if([type isEqualToString:@"add venue"] || [type isEqualToString:@"edit venue"]){
        lblName.frame=CGRectMake(65, 10, 175, 40);
        UIButton *btnYes = [[UIButton alloc]initWithFrame:CGRectMake(65, 50, 32, 20)];
                [btnYes addTarget:self
                           action:@selector(cmdYes:)
                 forControlEvents:UIControlEventTouchUpInside];
     
        [btnYes setBackgroundColor:[UIColor colorWithRed:106/255.0 green:188/255.0 blue:33/255.0 alpha:1.0]];
        btnYes.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:10];
        btnYes.layer.cornerRadius=10;
        [btnYes setTitle:@"Yes" forState:UIControlStateNormal];
        btnYes.tag=indexPath.row;
        [cell.contentView addSubview:btnYes];
        
        UIButton *btnNo = [[UIButton alloc]initWithFrame:CGRectMake(102, 50, 32, 20)];
                [btnNo addTarget:self
                           action:@selector(cmdNo:)
                 forControlEvents:UIControlEventTouchUpInside];
        btnNo.layer.cornerRadius=10;
        [btnNo setBackgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
        btnNo.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:10];
        [btnNo setTitle:@"No" forState:UIControlStateNormal];
        btnNo.tag=indexPath.row;
        [cell.contentView addSubview:btnNo];
        
        UIButton *btnMaybe = [[UIButton alloc]initWithFrame:CGRectMake(138, 50, 42, 20)];
                [btnMaybe addTarget:self
                           action:@selector(cmdMayBe:)
                 forControlEvents:UIControlEventTouchUpInside];
        btnMaybe.layer.cornerRadius=10;
        btnMaybe.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:10];
        [btnMaybe setBackgroundColor:[UIColor colorWithRed:255/255.0 green:222/255.0 blue:00/255.0 alpha:1.0]];
        [btnMaybe setTitle:@"Maybe" forState:UIControlStateNormal];
        btnMaybe.tag=indexPath.row;
        [cell.contentView addSubview:btnMaybe];

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // you hit delete
        NSDictionary *dict=[arryNotification objectAtIndex:indexPath.row];
        NSString *idd=[dict objectForKey:@"id"];
        [self deleteNotification:idd];
    }
}

-(void)getNotification{
    
    [self.view addSubview:ind];
    [[ApiClient  sharedInstance]getNotification:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *USERID = [prefs stringForKey:@"USERID"];
       
        arryNotification=[dict objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strnotific=[NSString stringWithFormat:@"%@Notify",USERID];
        [defaults setObject:arryNotification forKey:strnotific];
        [defaults synchronize];
        
        [self.tblNotification reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}

-(void)getNotificationInBackGround{
    
    [[ApiClient  sharedInstance]getNotification:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *USERID = [prefs stringForKey:@"USERID"];
        
        arryNotification=[dict objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strnotific=[NSString stringWithFormat:@"%@Notify",USERID];
        [defaults setObject:arryNotification forKey:strnotific];
        [defaults synchronize];
        
        [self.tblNotification reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [AlertView showAlertWithMessage:errorString];
    }];
    
}


-(void)deleteNotification:(NSString *)str{
    [self.view addSubview:ind];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:USERID forKey:@"user_id"];
    [dict setObject:str forKey:@"id"];
    [[ApiClient sharedInstance]deleteNotification:dict success:^(id responseObject) {
         [ind removeFromSuperview];
        NSDictionary *dictData=responseObject;
        arryNotification=[dictData objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strnotific=[NSString stringWithFormat:@"%@Notify",USERID];
        [defaults setObject:arryNotification forKey:strnotific];
        [defaults synchronize];
        [self.tblNotification reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
         [ind removeFromSuperview];
         [AlertView showAlertWithMessage:errorString];
    }];
}
-(void)cmdYes:(id)sender{

    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[arryNotification objectAtIndex:btn.tag];
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"1" forKey:@"yes"];
    [DictData setObject:@"0" forKey:@"no"];
    [DictData setObject:@"0" forKey:@"maybe"];
    [DictData setObject:[dict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];

}
-(void)cmdNo:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[arryNotification objectAtIndex:btn.tag];
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"0" forKey:@"yes"];
    [DictData setObject:@"0" forKey:@"no"];
    [DictData setObject:@"1" forKey:@"maybe"];
    [DictData setObject:[dict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];
}
-(void)cmdMayBe:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[arryNotification objectAtIndex:btn.tag];
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"0" forKey:@"yes"];
    [DictData setObject:@"0" forKey:@"no"];
    [DictData setObject:@"1" forKey:@"maybe"];
    [DictData setObject:[dict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];
}

-(void)addAttandance:(NSDictionary *)dict{
    [self.view addSubview:ind];
    [[ApiClient sharedInstance]addAttandance:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        [AlertView showAlertWithMessage:[dict objectForKey:@"message"]];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[arryNotification objectAtIndex:indexPath.row];
    NSString *type=[dict objectForKey:@"type"];
    if([type isEqualToString:@"add venue"] || [type isEqualToString:@"edit venue"]){
         NSDictionary *dict=[arryNotification objectAtIndex:indexPath.row];
        InvatationCardViewController* controller = [[InvatationCardViewController alloc] initWithNibName:@"InvatationCardViewController" bundle:nil];
        controller.dict=dict;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
