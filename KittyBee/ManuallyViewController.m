//
//  ManuallyViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "ManuallyViewController.h"
#import "DiaryViewController.h"
@interface ManuallyViewController (){
    NSMutableIndexSet *selectedData;

}

@end

@implementation ManuallyViewController

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
    self.title=@"SELECT HOST MANUALLY";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    selectedData = [[NSMutableIndexSet alloc] init];
    UIButton *btnBack =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 10, 15, 20)];
    [btnBack setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InviteBtnButton1 = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = InviteBtnButton1;
    self.popUp.frame=CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    self.lblDate.text=self.kitty_date;
}
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([self.strCategory isEqualToString:@"Couple Kitty"]){
        return  120;
    }
    
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arryHostValue.count;
    
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
    NSDictionary *dict=[self.arryHostValue objectAtIndex:indexPath.row];
   
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
        
        
        
        AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-42, 46,32,32)];
        checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        if ([selectedData containsIndex:indexPath.row]){
            
            checkImage.image=[UIImage imageNamed:@"check"];
        }else{
            checkImage.image=[UIImage imageNamed:@"uncheck"];
        }
        [checkImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:checkImage];
        
        
        
        
        UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(20, 120,self.view.frame.size.width-40 , 1)];
        sepView.backgroundColor=[UIColor lightGrayColor];
        sepView.alpha=0.5;
        [cell.contentView addSubview:sepView];
        
        
        
    }else{
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        
        
        NSString *strImgUrl=[dict objectForKey:@"profile_pic"];
        strImgUrl=[strImgUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strImgUrl];
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
        lblName.text=[dict objectForKey:@"name"];;
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 20)];
        lblList.backgroundColor=[UIColor clearColor];
        lblList.numberOfLines=2;
        lblList.lineBreakMode=NSLineBreakByWordWrapping;
        lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList.text=[dict objectForKey:@"number"];
        lblList.alpha=0.5;
        lblList.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList];
        
        AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-42, 20,20,20)];
        checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        if ([selectedData containsIndex:indexPath.row]){
            
            checkImage.image=[UIImage imageNamed:@"check"];
        }else{
            checkImage.image=[UIImage imageNamed:@"uncheck"];
        }
        [checkImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:checkImage];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    long noHost=[self.noOfHost integerValue];
    if([selectedData containsIndex:indexPath.row]){
        [selectedData removeIndex:indexPath.row];
         [self.tblHostManually reloadData];
    }else{
        if(selectedData.count>=noHost){
            [AlertView showAlertWithMessage:[NSString stringWithFormat:@"you can select only %@ Host",self.noOfHost]];
        }else{
            if ([selectedData containsIndex:indexPath.row]){
                
            }else{
                [selectedData addIndex:indexPath.row];
            }
            [self.tblHostManually reloadData];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *btnnext = [[UIButton alloc]initWithFrame:fotterView.frame];
    [btnnext addTarget:self
                action:@selector(cmdNext:)
      forControlEvents:UIControlEventTouchUpInside];
    btnnext.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];//78,201,75
    [btnnext setBackgroundColor:[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0]];
    [btnnext setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [fotterView addSubview:btnnext];
    return fotterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
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


-(void)cmdNext:(id)sender{
    int totalHost=[self.noOfHost intValue];
    if(selectedData.count>=totalHost || selectedData.count>=self.arryHostValue.count){
            [selectedData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSDictionary *dict=[self.arryHostValue objectAtIndex:idx];
                if([self.lblHostName.text isEqualToString:@""]){
                    self.lblHostName.text=[self getName:dict];
                }else{
                    self.lblHostName.text=[NSString stringWithFormat:@"%@,%@",self.lblHostName.text,[self getName:dict]];
                }
            }];
        self.lblHostName.text=[self.lblHostName.text stringByReplacingOccurrencesOfString:@"-!-" withString:@","];
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
    }else{
        [AlertView showAlertWithMessage:[NSString stringWithFormat:@"Number of host must be %@",self.noOfHost]];
    }
   
}


- (IBAction)cmdDone:(id)sender {
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.lblDate.text forKey:@"kitty_date"];
    __block NSMutableArray *arry=[[NSMutableArray alloc]init];
    [selectedData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSDictionary *dict1=[self.arryHostValue objectAtIndex:idx];
        [arry addObject:dict1];
    }];
    [dict setObject:arry forKey:@"member"];
    [dict setObject:self.groupId forKey:@"groupId"];
     [dict setObject:self.strKittyId forKey:@"KittyId"];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(!(status == NotReachable)){
        [[ApiClient  sharedInstance]selectHost:self.groupId dict:dict success:^(id responseObject) {
            
            for (UIViewController*vc in [self.navigationController viewControllers]) {
                if ([vc isKindOfClass: [DiaryViewController class]]){
                    [[self navigationController] popToViewController:vc animated:YES];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [AlertView showAlertWithMessage:errorString];
        }];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arryData= [[defaults objectForKey:@"HOST"] mutableCopy];
        if(!(arryData)){
            arryData=[[NSMutableArray alloc]init];
        }
        [arryData addObject:dict];
        
        [defaults setObject:arryData forKey:@"HOST"];
        [defaults synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        for (UIViewController*vc in [self.navigationController viewControllers]) {
            if ([vc isKindOfClass: [DiaryViewController class]]){
                [[self navigationController] popToViewController:vc animated:YES];
            }
        }
        
    }
}


@end
