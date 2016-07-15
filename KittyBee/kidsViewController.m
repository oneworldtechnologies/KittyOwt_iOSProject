//
//  kidsViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "kidsViewController.h"

@interface kidsViewController (){
    IndecatorView *ind;

}

@end

@implementation kidsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.title=@"KIDS";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrMember.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  60;
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

    
    UIView *sep=[[UIView alloc]initWithFrame:CGRectMake(20, 59, self.view.frame.size.width, 1)];//128,222,234
    sep.backgroundColor=[UIColor colorWithRed:128/225.0 green:222/225.0 blue:234/255.0 alpha:1.0];
    [cell.contentView addSubview:sep];
    UIButton *btnAddkids = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 12, 35, 35)];
    [btnAddkids setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    [btnAddkids setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddkids setTitle:[self.arryKidsValue objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    btnAddkids.titleLabel.font=[UIFont fontWithName:@"GothamMedium" size:14];
            [btnAddkids addTarget:self
                       action:@selector(cmdAddKids:)
             forControlEvents:UIControlEventTouchUpInside];
    btnAddkids.tag=indexPath.row;
    btnAddkids.layer.cornerRadius=17;
    btnAddkids.clipsToBounds=YES;
    [cell.contentView addSubview:btnAddkids];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
   // view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
    UILabel *lblMemberName=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width/2-20, 30)];
    lblMemberName.numberOfLines=2;
    lblMemberName.lineBreakMode=NSLineBreakByWordWrapping;
    lblMemberName.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblMemberName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblMemberName.text=@"Name of Member";
    lblMemberName.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:lblMemberName];
    
    UILabel *lblSelectCouple = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 5, 100, 30)];
    lblSelectCouple.numberOfLines=2;
    lblSelectCouple.lineBreakMode=NSLineBreakByWordWrapping;
    lblSelectCouple.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblSelectCouple.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblSelectCouple.text=@"No of Kids";
    lblSelectCouple.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblSelectCouple];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *btnnext = [[UIButton alloc]initWithFrame:fotterView.frame];
    [btnnext addTarget:self
                action:@selector(cmdDone:)
      forControlEvents:UIControlEventTouchUpInside];
    btnnext.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];//78,201,75
    [btnnext setBackgroundColor:[UIColor colorWithRed:78/255.0 green:201/255.0 blue:75/255.0 alpha:1.0]];
    [btnnext setTitle:@"DONE" forState:UIControlStateNormal];
    [fotterView addSubview:btnnext];
    return fotterView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(void)cmdDone:(id)sender{
    if([self.addMember isEqualToString:@"yes"]){
        NSMutableArray *arrData=[[NSMutableArray alloc]init];

        for (int i =0; i<self.arrMember.count; i++) {
            NSMutableDictionary *dict=[[self.arrMember objectAtIndex:i] mutableCopy];
            [dict setObject:[self.arryKidsValue objectAtIndex:i]forKey:@"kids"];
            [arrData addObject:dict];
        }
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:arrData forKey:@"member"];
        [dict setObject:self.groupId forKey:@"group_id"];
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
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.arryKidsValue forKey:@"KidsValue"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddkidsToKittyRulesPage" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)cmdAddKids:(id)sender{
    UIButton *btn=(UIButton *)sender;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter No. of kids" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=btn.tag;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strChild=[[alertView textFieldAtIndex:0] text];
    strChild=[strChild stringByReplacingOccurrencesOfString:@" " withString:@""];
    int noOfChild=[strChild intValue];
    if(buttonIndex==1){
        if(noOfChild<10){
            if([strChild isEqualToString:@""]){
                [self.arryKidsValue replaceObjectAtIndex:alertView.tag withObject:@"0"];
            }else{
                int kidsNum=[strChild intValue];
                [self.arryKidsValue replaceObjectAtIndex:alertView.tag withObject:[NSString stringWithFormat:@"%d",kidsNum]];
            }
        }else{
            [AlertView showAlertWithMessage:@"Please enter valid child number."];
        }
        [self.tblKids reloadData];
    }
}

@end
