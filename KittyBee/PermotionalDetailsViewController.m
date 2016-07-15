//
//  PermotionalDetailsViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 25/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "PermotionalDetailsViewController.h"
#import "StarRatingView.h"
@interface PermotionalDetailsViewController ()

@end

@implementation PermotionalDetailsViewController

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
    self.title=[self.dictDetails objectForKey:@"name"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
//    self.webView=[[UIWebView alloc]init];
//    self.webView.scrollView.scrollEnabled = TRUE;
//    self.webView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.webView loadHTMLString:@"<html><body><ul style=\"margin:0; padding:20px;\"><h2 style=\"font-family:arial; font-size:20px; color:#3d342b; line-height:25px;\">Terms & Conditions</h2><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">It is a long established fact that a reader will be.</li><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">Lorem Ipsum is simply dummy text of the printing and typesetting </li><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">There are many variations of passages of Lorem Ipsum available,</li><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">Contrary to popular belief, Lorem Ipsum is not simply random text. </li><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">There are many variations of passages of Lorem Ipsum available,</li><li style=\"font-family:arial; font-size:15px; color:#3d342b; line-height:25px;\">Contrary to popular belief, Lorem Ipsum is not simply random text. </li></ul></body></html>" baseURL:nil];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.view.frame.size.height-50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
    if(indexPath.row==0){
        

        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height-50)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner.showActivityIndicator=YES;
        NSString *strURl=[self.dictDetails objectForKey:@"banner"];
        strURl=[strURl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strURl];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:banner];
        UIView *detaialView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-150, self.view.frame.size.width, 100)];
        detaialView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];

        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:12];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text= [self.dictDetails objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblName];
        
        UILabel *lblAddress=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 20)];
        lblAddress.backgroundColor=[UIColor clearColor];
        lblAddress.numberOfLines=2;
        lblAddress.lineBreakMode=NSLineBreakByWordWrapping;
        lblAddress.font = [UIFont fontWithName:@"GothamBook" size:9];
        lblAddress.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblAddress.text=[self.dictDetails objectForKey:@"address"];
        lblAddress.textAlignment = NSTextAlignmentCenter;
        [detaialView addSubview:lblAddress];
        [cell.contentView addSubview:detaialView];
        
        int Rating=[[self.dictDetails objectForKey:@"rating"] intValue]*20;
        StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-80, 40, 160.0f, 30.0f) andRating:Rating withLabel:NO animated:YES];
        starview.userInteractionEnabled=NO;
        [detaialView addSubview:starview];
        //detail
    }else{
//        self.webView.frame=CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height/2);
//        [cell.contentView addSubview:self.webView];
        
    }
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIButton *btnContact = [[UIButton alloc]initWithFrame:fotterView.frame];
            [btnContact addTarget:self
                       action:@selector(cmdContact:)
             forControlEvents:UIControlEventTouchUpInside];
    btnContact.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];
    [btnContact setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    [btnContact setTitle:@"Contact" forState:UIControlStateNormal];
    [fotterView addSubview:btnContact];
    return fotterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(void)cmdContact:(id)sender{
    NSString *pNum=[self.dictDetails objectForKey:@"phone"];
    NSString *strNum=[NSString stringWithFormat:@"telprompt://%@",pNum];
    strNum=[strNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNum]];
}

@end
