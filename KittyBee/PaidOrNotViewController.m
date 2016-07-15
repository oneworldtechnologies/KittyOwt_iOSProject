//
//  PaidOrNotViewController.m
//  KittyBee
//
//  Created by Arun on 07/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "PaidOrNotViewController.h"
#import "SelectCoupleViewController.h"
#import "kidsViewController.h"
@interface PaidOrNotViewController (){
    NSMutableIndexSet *selectedPaidData;
    NSMutableIndexSet *selectedNotPaidData;
    IndecatorView *ind;

}

@end

@implementation PaidOrNotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedPaidData = [[NSMutableIndexSet alloc] init];
    selectedNotPaidData = [[NSMutableIndexSet alloc] init];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arryGroupMember.count;
    
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
    
    
    NSDictionary *dict=[self.arryGroupMember objectAtIndex:indexPath.row];
    
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
    lblName.text=[dict objectForKey:@"name"];;
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
    
    UIButton *btnPaid = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-113, 15, 40, 40)];
    [btnPaid addTarget:self
                action:@selector(cmdPaid:)
      forControlEvents:UIControlEventTouchUpInside];
    btnPaid.tag=indexPath.row;
    if ([selectedPaidData containsIndex:indexPath.row]){
        [btnPaid setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else{
        [btnPaid setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    }
    
    [cell.contentView addSubview:btnPaid];
    
    
    UIButton *btnNotPaid = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-52, 15, 40, 40)];
    [btnNotPaid addTarget:self
                action:@selector(cmdNotPaid:)
      forControlEvents:UIControlEventTouchUpInside];
    btnNotPaid.tag=indexPath.row;
    if ([selectedNotPaidData containsIndex:indexPath.row]){
        [btnNotPaid setImage:[UIImage imageNamed:@"radio_active"] forState:UIControlStateNormal];
    }else{
        [btnNotPaid setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    }
    
    [cell.contentView addSubview:btnNotPaid];
    
    
//    AsyncImageView *checkImage1=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 24,19,19)];
//    checkImage1.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
//    if ([selectedData containsIndex:indexPath.row]){
//        
//
//    }else{
//        checkImage1.image=[UIImage imageNamed:@"uncheck"];
//    }
//    [checkImage1 setContentMode:UIViewContentModeScaleAspectFill];
//    [cell.contentView addSubview:checkImage1];
//
//    
//    
//    AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 24,19,19)];
//    checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
//    if ([selectedData containsIndex:indexPath.row]){
//        
//        checkImage.image=[UIImage imageNamed:@"check"];
//    }else{
//        checkImage.image=[UIImage imageNamed:@"uncheck"];
//    }
//    [checkImage setContentMode:UIViewContentModeScaleAspectFill];
//    [cell.contentView addSubview:checkImage];
    
    
    return cell;
}

-(void)cmdNotPaid:(id)sender{
     UIButton *btn=(UIButton *)sender;
    NSLog(@"button.tag %ld",(long)btn.tag);
    if ([selectedNotPaidData containsIndex:btn.tag]){
       // [selectedNotPaidData removeIndex:btn.tag];
    }else{
        [selectedNotPaidData addIndex:btn.tag];
        if([selectedPaidData containsIndex:btn.tag]){
            [selectedPaidData removeIndex:btn.tag];
        }
    }
    [self.tblPaid reloadData];
}

-(void)cmdPaid:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"button.tag %ld",(long)btn.tag);
    
    if ([selectedPaidData containsIndex:btn.tag]){
        //[selectedPaidData removeIndex:btn.tag];
    }else{
        [selectedPaidData addIndex:btn.tag];
        if([selectedNotPaidData containsIndex:btn.tag]){
            [selectedNotPaidData removeIndex:btn.tag];
        }
    }
    [self.tblPaid reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    
    UILabel *lblMemberName=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width/2-20, 30)];
    lblMemberName.numberOfLines=2;
    lblMemberName.lineBreakMode=NSLineBreakByWordWrapping;
    lblMemberName.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblMemberName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblMemberName.text=@"Name of Member";
    lblMemberName.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:lblMemberName];
    
    UILabel *lblSelectCouple = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-115, 5, 40, 30)];
    lblSelectCouple.numberOfLines=2;
    lblSelectCouple.lineBreakMode=NSLineBreakByWordWrapping;
    lblSelectCouple.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblSelectCouple.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblSelectCouple.text=@"Paid";
    lblSelectCouple.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblSelectCouple];
    
    
    UILabel *lblSelectCouple1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 5, 80, 30)];
    lblSelectCouple1.numberOfLines=2;
    lblSelectCouple1.lineBreakMode=NSLineBreakByWordWrapping;
    lblSelectCouple1.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblSelectCouple1.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblSelectCouple1.text=@"Not Paid";
    lblSelectCouple1.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblSelectCouple1];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([selectedPaidData containsIndex:indexPath.row]){
//        [selectedPaidData removeIndex:indexPath.row];
//    }else{
//        [selectedPaidData addIndex:indexPath.row];
//    }
//    [self.tblPaid reloadData];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *btnnext = [[UIButton alloc]initWithFrame:fotterView.frame];
    [btnnext addTarget:self
                action:@selector(cmdNext:)
      forControlEvents:UIControlEventTouchUpInside];
    btnnext.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];
    [btnnext setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    if([self.catagory isEqualToString:@"Normal Kitty"]){
        
        [btnnext setTitle:@"DONE" forState:UIControlStateNormal];
        
    }else{
        
        [btnnext setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    
    [fotterView addSubview:btnnext];
    return fotterView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(void)cmdNext:(id)sender{
    NSInteger paidCount=selectedPaidData.count;
    NSInteger notpaidCount=selectedNotPaidData.count;
    
    if(!(paidCount+notpaidCount == self.arryGroupMember.count)){
        [AlertView showAlertWithMessage:@"Please give information for all members for kitty paid."];
        return;
    }
    
    
    if([self.catagory isEqualToString:@"Normal Kitty"]){
        [self addMemberForNormalKitty];
    }else if([self.catagory isEqualToString:@"Kitty with Kids"]){
        __block NSMutableArray *ArrValue=[[NSMutableArray alloc]init];
        for (int i=0; i<self.arryGroupMember.count; i++) {
            NSMutableDictionary *dict=[[self.arryGroupMember objectAtIndex:i]mutableCopy];
            [dict setObject:@"0" forKey:@"is_Paid"];
            [ArrValue addObject:dict];
        }
        [selectedPaidData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dict=[[ArrValue objectAtIndex:idx] mutableCopy];
            [dict setObject:@"1" forKey:@"is_Paid"];
            [ArrValue replaceObjectAtIndex:idx withObject:dict];
        }];
        NSMutableArray *arryKidsValue;
       
            arryKidsValue = [NSMutableArray array];
            for (int i=0; i<self.arryGroupMember.count; i++) {
                [arryKidsValue addObject:@"00"];
            }
        

        kidsViewController* controller = [[kidsViewController alloc] initWithNibName:@"kidsViewController" bundle:nil];
        controller.arrMember=ArrValue;
        controller.arryKidsValue=arryKidsValue;
        controller.addMember=@"yes";
        controller.groupId=self.groupId;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else  if([self.catagory isEqualToString:@"Couple Kitty"]){
        
        NSMutableArray * mutableArr = [[NSMutableArray alloc]init];
        for (int i=0; i<self.arryGroupMember.count; i++) {
            NSMutableDictionary *dataDict=[[self.arryGroupMember objectAtIndex:i]mutableCopy];
            [dataDict setObject:@"0" forKey:@"is_Paid"];
            [mutableArr addObject:dataDict];
        }
        
        [selectedPaidData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dict=[[self.arryGroupMember objectAtIndex:idx] mutableCopy];
            [dict setObject:@"1" forKey:@"is_Paid"];
            [mutableArr replaceObjectAtIndex:idx withObject:dict];
        }];
        
        if(self.unpairedMember.count >0){
            for (int i=0; i<self.unpairedMember.count; i++) {
                NSMutableDictionary *dict=[[self.unpairedMember objectAtIndex:i] mutableCopy];
                [dict setObject:@"1" forKey:@"is_Paid"];
                [mutableArr addObject:dict];
            }
        }

        SelectCoupleViewController* controller = [[SelectCoupleViewController alloc] initWithNibName:@"SelectCoupleViewController" bundle:nil];
        
        controller.groupId=self.groupId;
        controller.arrMember=mutableArr;
         controller.totalMember=mutableArr;
        controller.addMemeber= @"yes";
        [self.navigationController pushViewController:controller animated:YES];
    }
}



-(void)addMemberForNormalKitty{
    
    __block NSMutableArray *ArrValue=[[NSMutableArray alloc]init];
    for (int i=0; i<self.arryGroupMember.count; i++) {
        NSMutableDictionary *dict=[[self.arryGroupMember objectAtIndex:i]mutableCopy];
        [dict setObject:@"0" forKey:@"is_Paid"];
        [ArrValue addObject:dict];
    }
    [selectedPaidData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict=[[ArrValue objectAtIndex:idx] mutableCopy];
        [dict setObject:@"1" forKey:@"is_Paid"];
        [ArrValue replaceObjectAtIndex:idx withObject:dict];
    }];

        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:ArrValue forKey:@"member"];
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
    
}

@end
