//
//  InMiddelKittyViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 27/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "InMiddelKittyViewController.h"
#import "KittyRulesViewController.h"
@interface InMiddelKittyViewController (){
    NSMutableIndexSet *selectedData;

}

@end

@implementation InMiddelKittyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedData = [[NSMutableIndexSet alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"Select Hosted Members";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    UIButton *btnBack =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 10, 15, 20)];
    [btnBack setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InviteBtnButton1 = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = InviteBtnButton1;

    

}

-(void)backPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    
    AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 24,19,19)];
    checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    if ([selectedData containsIndex:indexPath.row]){
        
        checkImage.image=[UIImage imageNamed:@"check"];
    }else{
        checkImage.image=[UIImage imageNamed:@"uncheck"];
    }
    [checkImage setContentMode:UIViewContentModeScaleAspectFill];
    [cell.contentView addSubview:checkImage];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedData containsIndex:indexPath.row]){
        [selectedData removeIndex:indexPath.row];
    }else{
        [selectedData addIndex:indexPath.row];
    }
    [self.tblHost reloadData];
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
    [btnnext setTitle:@"NEXT" forState:UIControlStateNormal];
    [fotterView addSubview:btnnext];
    return fotterView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(void)cmdNext:(id)sender{
    
//    *arryGroupMember;
//    *imgGroup;
//    *strGroupName;
//    *strKittyType;
    if(self.arryGroupMember.count==selectedData.count){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:nil message:@"Can't able to selcet all member as hosted member." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [Alert show];
        return;
    }
    
    __block NSMutableArray *ArrValue=[[NSMutableArray alloc]init];
    for (int i=0; i<self.arryGroupMember.count; i++) {
        NSMutableDictionary *dict=[[self.arryGroupMember objectAtIndex:i]mutableCopy];
         [dict setObject:@"0" forKey:@"is_host"];
         [ArrValue addObject:dict];
    }
    
    
  //  __block NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    
    [selectedData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict=[[ArrValue objectAtIndex:idx] mutableCopy];
        [dict setObject:@"1" forKey:@"is_host"];
        [ArrValue replaceObjectAtIndex:idx withObject:dict];
            }];
    

    KittyRulesViewController *controller = [[KittyRulesViewController alloc] initWithNibName:@"KittyRulesViewController" bundle:nil];
    controller.arryGroupMember=ArrValue;
    controller.strInMiddelKitty=@"Yes";
    controller.imgGroup=self.imgGroup;
    controller.strGroupName=self.strGroupName;
    controller.strKittyType=self.strKittyType;
    if(!([self.strKittyType isEqualToString:@"Couple Kitty"])){
        controller.strNoOfHost=[NSString stringWithFormat:@"%lu",(unsigned long)selectedData.count];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

@end
