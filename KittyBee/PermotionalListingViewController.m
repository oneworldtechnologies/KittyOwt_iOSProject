//
//  PermotionalListingViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 18/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "PermotionalListingViewController.h"
#import "PermotionalDetailsViewController.h"
#import "HomeViewController.h"
@interface PermotionalListingViewController (){
    IndecatorView *ind;
    NSArray *arrShowData;
}

@end

@implementation PermotionalListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self getData];
    UIButton *InviteBtn1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [InviteBtn1 setFrame:CGRectMake(0, 10, 25, 42)];
    [InviteBtn1 setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [InviteBtn1 addTarget:self action:@selector(cmdback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InviteBtnButton1 = [[UIBarButtonItem alloc] initWithCustomView:InviteBtn1];
    self.navigationItem.leftBarButtonItem = InviteBtnButton1;
    // Do any additional setup after loading the view from its nib.
}
-(void)cmdback{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    Jewellery
//    Restaurant
//    Parlour
//    Boutique
//    Taxi
    if([self.pageNumber isEqualToString:@"1"]){
        self.title=@"JEWELLERY";
    }else if([self.pageNumber isEqualToString:@"2"]){
        self.title=@"RESTAURANT";
    }else if([self.pageNumber isEqualToString:@"3"]){
        self.title=@"PARLOUR";
    }else if([self.pageNumber isEqualToString:@"4"]){
        self.title=@"BOUTIQUE";
    }else if([self.pageNumber isEqualToString:@"5"]){
        self.title=@"TAXI";
    }else if([self.pageNumber isEqualToString:@"special"]){
        self.title=@"SPECIAL OFFER";
    }
    //1:2  2:3 3:5 4:6 5:8 6:9 7:11 8:12  1,2,3,4,5,6,7,8  2,3,5,6,8,9,11,12
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return (indexPath.row%2==0) ? (170) : (200);

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return roundf(arrShowData.count/1.5);
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
        NSDictionary *dict;
        NSDictionary *dict2;
        long indexValue=3*(indexPath.row/2);
        
             dict=[arrShowData objectAtIndex:indexValue];
            if(arrShowData.count>indexValue+1)
             dict2=[arrShowData objectAtIndex:indexValue+1];
        
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/2-1,168)];
        banner.showActivityIndicator=YES;
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        NSString *strURl=[dict objectForKey:@"thumb"];
        strURl=[strURl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strURl];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:banner];
              
        AsyncImageView *banner2=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+1, 0,self.view.frame.size.width/2-1,168)];
        banner.showActivityIndicator=YES;
        banner2.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        NSString *strURl1=[dict2 objectForKey:@"thumb"];
        strURl1=[strURl1 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner2.imageURL=[NSURL URLWithString:strURl1];
        banner2.clipsToBounds=YES;
        [banner2 setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:banner2];
        
        
        UIView *detaialView=[[UIView alloc]initWithFrame:CGRectMake(0, 118, self.view.frame.size.width/2-1, 50)];
        detaialView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];
        
        // drop shadow
        [detaialView.layer setShadowColor:[UIColor whiteColor].CGColor];
        [detaialView.layer setShadowOpacity:0.8];
        [detaialView.layer setShadowRadius:3.0];
        [detaialView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        [cell.contentView addSubview:detaialView];
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width/2-1, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:11];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text=[dict objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblName];
        
        UILabel *lblAddress=[[UILabel alloc]initWithFrame:CGRectMake(15, 25, self.view.frame.size.width/2-26, 20)];
        lblAddress.backgroundColor=[UIColor clearColor];
        lblAddress.text=[dict objectForKey:@"address"];
        lblAddress.numberOfLines=3;
        lblAddress.lineBreakMode=NSLineBreakByWordWrapping;
        lblAddress.font = [UIFont fontWithName:@"GothamBook" size:9];
        lblAddress.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblAddress.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblAddress];
        
//        UILabel *lblcheck=[[UILabel alloc]initWithFrame:CGRectMake(15, 105, self.view.frame.size.width/2-26, 50)];
//        lblcheck.text=@"SCF 51-52,Phase 7, Near HDFC Bank, ";
//        lblcheck.lineBreakMode=NSLineBreakByWordWrapping;
//        lblcheck.numberOfLines=2;
//        lblcheck.font=[UIFont fontWithName:@"Gotham-Book" size:10];
//        [cell.contentView addSubview:lblcheck];
        
        
        UIView *detaialView1=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+1, 118, self.view.frame.size.width/2-1, 50)];
        detaialView1.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];
        
        // drop shadow
        [detaialView1.layer setShadowColor:[UIColor whiteColor].CGColor];
        [detaialView1.layer setShadowOpacity:0.8];
        [detaialView1.layer setShadowRadius:3.0];
        [detaialView1.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        [cell.contentView addSubview:detaialView1];

        UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width/2-1, 20)];
        lblName1.backgroundColor=[UIColor clearColor];
        lblName1.numberOfLines=2;
        lblName1.lineBreakMode=NSLineBreakByWordWrapping;
        lblName1.font = [UIFont fontWithName:@"GothamMedium" size:12];
        lblName1.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName1.text=[dict2 objectForKey:@"name"];
        lblName1.textAlignment = NSTextAlignmentCenter;
        [detaialView1 addSubview:lblName1];
        
        
        UILabel *lblAddress1=[[UILabel alloc]initWithFrame:CGRectMake(15, 25, self.view.frame.size.width/2-26, 20)];
        lblAddress1.backgroundColor=[UIColor clearColor];
        lblAddress1.text=[dict2 objectForKey:@"address"];;
        lblAddress1.numberOfLines=3;
    
        lblAddress1.lineBreakMode=NSLineBreakByClipping;
        lblName1.clipsToBounds=YES;
        lblAddress1.font = [UIFont fontWithName:@"GothamBook" size:9];
        lblAddress1.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblAddress1.textAlignment = NSTextAlignmentCenter;
        [detaialView1 addSubview:lblAddress1];
        
        
        
        
        UIButton *btnBanner = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/2-1,168)];
        [btnBanner addTarget:self
                      action:@selector(cmdBanner:)
            forControlEvents:UIControlEventTouchUpInside];
        btnBanner.tag=indexValue;
        [cell.contentView addSubview:btnBanner];
        if(dict2){
        UIButton *btnBanner1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+1, 0,self.view.frame.size.width/2-1,168)];
        [btnBanner1 addTarget:self
                       action:@selector(cmdBanner:)
             forControlEvents:UIControlEventTouchUpInside];
        btnBanner1.tag=indexValue+1;
        [cell.contentView addSubview:btnBanner1];

        }

    }else{
        long indexValue=3*((indexPath.row-1)/2)+2;
        
        NSDictionary  *dict=[arrShowData objectAtIndex:indexValue];
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,198)];
        banner.showActivityIndicator=YES;
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        NSString *strURl=[dict objectForKey:@"thumb"];
        strURl=[strURl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strURl];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:banner];
        
        UIView *detaialView=[[UIView alloc]initWithFrame:CGRectMake(0, 148, self.view.frame.size.width, 50)];
        detaialView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];
        
        // drop shadow
        [detaialView.layer setShadowColor:[UIColor whiteColor].CGColor];
        [detaialView.layer setShadowOpacity:0.8];
        [detaialView.layer setShadowRadius:3.0];
        [detaialView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        [cell.contentView addSubview:detaialView];

        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:12];
        lblName.textColor=  [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];

        lblName.text=[dict objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblName];
        
        UILabel *lblAddress=[[UILabel alloc]initWithFrame:CGRectMake(20, 25, self.view.frame.size.width-40, 20)];
        lblAddress.backgroundColor=[UIColor clearColor];
        lblAddress.numberOfLines=2;
        lblAddress.lineBreakMode=NSLineBreakByWordWrapping;
        lblAddress.font = [UIFont fontWithName:@"GothamBook" size:9];
        lblAddress.textColor=  [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblAddress.text=[dict objectForKey:@"address"];
        lblAddress.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblAddress];
        
        UIButton *btnBanner = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,198)];
        [btnBanner addTarget:self
                      action:@selector(cmdBanner:)
            forControlEvents:UIControlEventTouchUpInside];
        btnBanner.tag=indexValue;
        [cell.contentView addSubview:btnBanner];
        
    }
    return cell;
    
}

-(void)cmdBanner:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[arrShowData objectAtIndex:btn.tag];
    PermotionalDetailsViewController* controller = [[PermotionalDetailsViewController alloc] initWithNibName:@"PermotionalDetailsViewController" bundle:nil];
    controller.dictDetails=dict;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark Api

-(void)getData{
    [self.view addSubview:ind];
   
    [[ApiClient sharedInstance]permotionalListing:self.pageNumber success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        arrShowData=[dict objectForKey:@"data"];
        if([self.pageNumber isEqualToString:@"1"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"JEWELLERY"];
            [defaults synchronize];
          
        }else if([self.pageNumber isEqualToString:@"2"]){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"RESTAURANT"];
            [defaults synchronize];
          
        }else if([self.pageNumber isEqualToString:@"3"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"PARLOUR"];
            [defaults synchronize];
            
        }else if([self.pageNumber isEqualToString:@"4"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"BOUTIQUE"];
            [defaults synchronize];
            
        }else if([self.pageNumber isEqualToString:@"5"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"TAXI"];
            [defaults synchronize];
        }
        [self.tblListing reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        
        if([self.pageNumber isEqualToString:@"1"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *dict= [defaults objectForKey:@"JEWELLERY"];
            arrShowData=dict;

        }else if([self.pageNumber isEqualToString:@"2"]){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *dict= [defaults objectForKey:@"RESTAURANT"];
            arrShowData=dict;
            
        }else if([self.pageNumber isEqualToString:@"3"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *dict= [defaults objectForKey:@"PARLOUR"];
            arrShowData=dict;
            
            
        }else if([self.pageNumber isEqualToString:@"4"]){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *dict= [defaults objectForKey:@"BOUTIQUE"];
            arrShowData=dict;
            
        }else if([self.pageNumber isEqualToString:@"5"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *dict= [defaults objectForKey:@"TAXI"];
            arrShowData=dict;
        }
        [self.tblListing reloadData];

        [AlertView showAlertWithMessage:errorString];
    }];
    

}

@end
