//
//  AttendenceViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 27/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "AttendenceViewController.h"
@interface AttendenceViewController ()
{
    IndecatorView *ind;
    NSArray *arryAttData;

}

@end
@implementation AttendenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"Attendence";
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    [self getAttandance];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arryAttData.count;
    
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
    NSDictionary *dict=[arryAttData objectAtIndex:indexPath.row];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width/3-10, 20)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:11];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=[dict objectForKey:@"name"];
    lblName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblName];
    
    UILabel *lblNumber=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3+10, 10, self.view.frame.size.width/3-10, 20)];
    lblNumber.numberOfLines=2;
    lblNumber.lineBreakMode=NSLineBreakByWordWrapping;
    lblNumber.font = [UIFont fontWithName:@"GothamBook" size:11];
    lblNumber.textColor= [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    lblNumber.text=[dict objectForKey:@"number"];
    lblNumber.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblNumber];
    
    float size=self.view.frame.size.width/3-10;
    
    AsyncImageView *yesImg=[[AsyncImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+10, 13,15,14)];
    yesImg.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    NSString *yes=[dict objectForKey:@"yes"];
    if([yes isEqualToString:@"1"]){
        yesImg.image=[UIImage imageNamed:@"active_checkbox"];
    }else{
        yesImg.image=[UIImage imageNamed:@"yes_inactive"];
    }
    
    yesImg.clipsToBounds=YES;
    [yesImg setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:yesImg];
     NSString *no=[dict objectForKey:@"no"];
    AsyncImageView *noImg=[[AsyncImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+size/3+10, 13,15,14)];
    noImg.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    if([no isEqualToString:@"1"]){
         noImg.image=[UIImage imageNamed:@"no-1"];
    }else{
         noImg.image=[UIImage imageNamed:@"no"];
    }
    noImg.clipsToBounds=YES;
    [noImg setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:noImg];
    
    NSString *maybe=[dict objectForKey:@"maybe"];
    
    AsyncImageView *maybeImg=[[AsyncImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+size/3*2+10, 13,15,14)];
    maybeImg.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    if([maybe isEqualToString:@"1"]){
        maybeImg.image=[UIImage imageNamed:@"maybe-1"];
    }else{
        maybeImg.image=[UIImage imageNamed:@"maybe"];
    }
    maybeImg.clipsToBounds=YES;
    [maybeImg setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:maybeImg];
    //128,222,234
    UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(10, 39,self.view.frame.size.width-20 , 1)];
    sepView.backgroundColor=[UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
    sepView.alpha=0.5;
    [cell.contentView addSubview:sepView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
   // view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/3-10, 30)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=@"Name";
    lblName.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblName];
    
    UILabel *lblNumber=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3+10, 0, self.view.frame.size.width/3-10, 30)];
    lblNumber.numberOfLines=2;
    lblNumber.lineBreakMode=NSLineBreakByWordWrapping;
    lblNumber.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblNumber.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblNumber.text=@"Phone Number";
    lblNumber.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblNumber];
    
    float size=self.view.frame.size.width/3-10;
    
    UILabel *lblYes=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+10, 0,25,30)];
    lblYes.numberOfLines=2;
    lblYes.lineBreakMode=NSLineBreakByWordWrapping;
    lblYes.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblYes.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblYes.text=@"Yes";
    lblYes.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblYes];
    
    UILabel *lblNo=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+size/3+10, 0,20,30)];
    lblNo.numberOfLines=2;
    lblNo.lineBreakMode=NSLineBreakByWordWrapping;
    lblNo.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblNo.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblNo.text=@"No";
    lblNo.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblNo];
    
    UILabel *lblMayBe=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2+size/3*2, 0,40,30)];
    lblMayBe.numberOfLines=2;
    lblMayBe.lineBreakMode=NSLineBreakByWordWrapping;
    lblMayBe.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblMayBe.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblMayBe.text=@"Maybe";
    lblMayBe.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblMayBe];

    return view;
}

-(void)getAttandance{
    [self.view addSubview:ind];
    NSMutableDictionary *Dict=[[NSMutableDictionary alloc]init];
    [Dict setObject:self.groupId forKey:@"group_id"];
    [Dict setObject:self.kittyId forKey:@"kitty_id"];
    
    [[ApiClient sharedInstance]getAttandance:Dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        NSLog(@"%@",dict);
        arryAttData=[dict objectForKey:@"data"];
        [self.tblAttendence reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}


@end
