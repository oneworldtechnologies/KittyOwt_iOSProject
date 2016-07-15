//
//  DeleteMemberViewController.m
//  KittyBee
//
//  Created by Arun on 13/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "DeleteMemberViewController.h"

@interface DeleteMemberViewController (){
    NSMutableIndexSet *selectedData;
    BOOL showSearch;
    UISearchBar *searchBar;
    NSMutableArray *searchResults;
    NSMutableArray *arryRowValue;
    NSMutableArray *arrySelectedValue;
    IndecatorView *ind;
}

@end

@implementation DeleteMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selectedData = [[NSMutableIndexSet alloc] init];
    
//    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
//    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    btnSearch.frame = CGRectMake(0, 0, 32, 32);
//    
//    [btnSearch addTarget:self action:@selector(cmdSearch:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
//    [arrRightBarItems addObject:btnSearchBar];
//    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    searchResults=[self.arryMemberList mutableCopy];
    arryRowValue=[[NSMutableArray alloc]init];
    arrySelectedValue=[[NSMutableArray alloc]init];
    for (int i=0; i<searchResults.count; i++) {
        [arryRowValue addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
}

-(void)cmdSearch:(id)sender{
    if(showSearch){
        showSearch=NO;
        [searchBar removeFromSuperview];
        searchResults=[self.arryMemberList mutableCopy];
        [self.tblDeleteMember reloadData];
        
    }else{
        showSearch=YES;
    }
    [self.tblDeleteMember reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"DELETE MEMBER";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arryMemberList.count;
    
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
    NSDictionary *dict=[self.arryMemberList objectAtIndex:indexPath.row];
    AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
    banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    banner.showActivityIndicator=YES;
    NSString *strURL=[dict objectForKey:@"profile"];
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
    
    
    AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 20,19,19)];
    checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    //    if ([selectedData containsIndex:indexPath.row]){
    //
    //        checkImage.image=[UIImage imageNamed:@"check"];
    //    }else{
    //         checkImage.image=[UIImage imageNamed:@"uncheck"];
    //    }
    [checkImage setContentMode:UIViewContentModeScaleAspectFill];
    
    if([searchBar.text isEqualToString:@""]){
        
        
        if ([arrySelectedValue containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            checkImage.image=[UIImage imageNamed:@"check"];
        }else {
            checkImage.image=[UIImage imageNamed:@"uncheck"];
            
            
        }
    }else{
        if(!(arrySelectedValue.count>0)){
            checkImage.image=[UIImage imageNamed:@"uncheck"];
        }
        for(int i=0; i<arrySelectedValue.count;i++){
            
            if ([arryRowValue containsObject:[arrySelectedValue objectAtIndex:i]]) {
                NSInteger indexVal=[arryRowValue indexOfObject:[arrySelectedValue objectAtIndex:i]];
                NSLog(@"%ld",(long)indexPath.row);
                if(indexPath.row==indexVal){
                    checkImage.image=[UIImage imageNamed:@"check"];
                    break;
                }else{
                    checkImage.image=[UIImage imageNamed:@"uncheck"];
                }
            }else{
                checkImage.image=[UIImage imageNamed:@"uncheck"];
            }
        }
    }
    
    [cell.contentView addSubview:checkImage];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([arrySelectedValue containsObject:[arryRowValue objectAtIndex:indexPath.row]]) {
        
        [arrySelectedValue removeObject:[arryRowValue objectAtIndex:indexPath.row]];
        
        
        
        // [selectedData removeIndex:indexPath.row];
        
    }else{
        
        [arrySelectedValue addObject:[arryRowValue objectAtIndex:indexPath.row]];
        // [selectedData addIndex:indexPath.row];
    }
    [self.tblDeleteMember reloadData];
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
    [btnnext setTitle:@"DONE" forState:UIControlStateNormal];
    [fotterView addSubview:btnnext];
    return fotterView;
    
}
-(void)cmdNext:(id)sender{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(showSearch)
        return 50;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    if(showSearch)
        headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 0);
    if(!(searchBar)){
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.delegate=self;
        searchBar.returnKeyType=UIReturnKeyDone;
        searchBar.placeholder=@"Search Member";
        [searchBar setShowsCancelButton:NO];
    }
    [searchBar becomeFirstResponder];
    [headerView addSubview:searchBar];
    return headerView;
    
}

#pragma mark searchbar
-(void)searchBar:(UISearchBar*)searchbar textDidChange:(NSString*)text
{
    if ([text length] == 0)
    {
        searchResults=[self.arryMemberList mutableCopy];
        [self.tblDeleteMember reloadData];
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
        [self viewDown];
    }else{
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -65, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
    }
    [arryRowValue removeAllObjects];
    arryRowValue=nil;
    [searchResults removeAllObjects];
    searchResults=nil;
    searchResults=[[NSMutableArray alloc]init];
    arryRowValue=[[NSMutableArray alloc]init];
    for (int i=0; i<self.arryMemberList.count; i++) {
        NSDictionary *Dict=[self.arryMemberList objectAtIndex:i];
        NSString *strName=[Dict objectForKey:@"name"];
        NSRange nameRange = [strName rangeOfString:text options:NSCaseInsensitiveSearch];
        NSRange descriptionRange = [strName rangeOfString:text options:NSCaseInsensitiveSearch];
        
        NSRange textrange=[searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
        NSRange descriptionRangetxt = [searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
        
        if(nameRange.location == textrange.location || descriptionRange.location == descriptionRangetxt.location)
        {
            [arryRowValue addObject:[NSString stringWithFormat:@"%d",i]];
            [searchResults addObject:Dict];
            
        }
    }
    
    [self.tblDeleteMember reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
    [self viewDown];
    
}
-(void)viewDown{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

@end
