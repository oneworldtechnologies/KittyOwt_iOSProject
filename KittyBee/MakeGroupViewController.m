//
//  MakeGroupViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 26/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "MakeGroupViewController.h"
#import "InMiddelKittyViewController.h"
#import "KittyRulesViewController.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface MakeGroupViewController (){
    NSMutableIndexSet *selectedData;
    BOOL showSearch;
    UISearchBar *searchBar;
    NSMutableArray *searchResults;
    NSMutableArray *arryRowValue;
    NSMutableArray *arrySelectedValue;
    IndecatorView *ind;

}

@end

@implementation MakeGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedData = [[NSMutableIndexSet alloc] init];
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btnSearch.frame = CGRectMake(0, 0, 32, 32);
    
    [btnSearch addTarget:self action:@selector(cmdSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    [arrRightBarItems addObject:btnSearchBar];
    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    searchResults=[self.dictContact mutableCopy];
    arryRowValue=[[NSMutableArray alloc]init];
    arrySelectedValue=[[NSMutableArray alloc]init];
    for (int i=0; i<searchResults.count; i++) {
        [arryRowValue addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)cmdSearch:(id)sender{
    if(showSearch){
        showSearch=NO;
        [searchBar removeFromSuperview];
        searchResults=[self.dictContact mutableCopy];
        [self.tblView reloadData];
        
    }else{
        showSearch=YES;
    }
    [self.tblView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"Create Group";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    
    self.btnGroupPic.layer.cornerRadius=35;
    self.btnGroupPic.clipsToBounds=YES;
    
    self.viewGroup.layer.shadowColor =[UIColor blackColor].CGColor;
    self.viewGroup.layer.shadowRadius =8.0f;
    self.viewGroup.layer.shadowOpacity =0.7f;
    self.viewGroup.layer.shadowOffset =CGSizeMake(-5.0f, -5.0f);
    [self changePlaceHolder];
}
-(void)changePlaceHolder{
   
    [self placeholderValue:self.txtGroupName textPlaceHold:@"Enter Group Name..."];
    
}

-(void)placeholderValue:(UITextField *)txtFeild textPlaceHold:(NSString *)textPlaceHold{
    UIColor *color=[UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    txtFeild.attributedPlaceholder=[[NSAttributedString alloc] initWithString:textPlaceHold attributes:@{NSForegroundColorAttributeName: color}];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchResults.count;
    
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
    NSDictionary *dict=[searchResults objectAtIndex:indexPath.row];
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
    if([self.txtGroupName isFirstResponder])
    {
        [self.view endEditing:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([arrySelectedValue containsObject:[arryRowValue objectAtIndex:indexPath.row]]) {
        
        [arrySelectedValue removeObject:[arryRowValue objectAtIndex:indexPath.row]];
        
        
        
        // [selectedData removeIndex:indexPath.row];
        
    }else{
        
        [arrySelectedValue addObject:[arryRowValue objectAtIndex:indexPath.row]];
        // [selectedData addIndex:indexPath.row];
    }
    [self.tblView reloadData];
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
        searchBar.placeholder=@"Search Contacts";
        [searchBar setShowsCancelButton:NO];
    }
    [searchBar becomeFirstResponder];
    [headerView addSubview:searchBar];
    return headerView;
    
}
-(void)cmdAddPic:(id)sender{
    
}
-(void)cmdNext:(id)sender{
    [self viewDown];
    NSString *strGroupName=self.txtGroupName.text;
    strGroupName=[strGroupName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strGroupName.length>0){
        if(arrySelectedValue.count>0){
            //        if(!(selectedData.count==0)){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Want to create kitty group" delegate:self cancelButtonTitle:@"Now" otherButtonTitles:@"Later", nil];
            alert.tag=101;
            [alert show];
            
        }else{
            [AlertView showAlertWithMessage:@"Please select atleast one member for group."];
        }
        
    }else{
        [AlertView showAlertWithMessage:@"Please enter group name."];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if(alertView.tag==101){
        if(buttonIndex==0){//now
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Middle Of Kitty?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag=102;
            [alert show];
            
            
        }else if(buttonIndex==1){//later
            [self.view addSubview:ind];
            __block NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:@"0" forKey:@"setRule"];
            [dict setObject:self.kittyName forKey:@"category"];
             NSMutableArray *mutableArr=[self arryMember];
            UIImage *img = [self.btnGroupPic imageForState:UIControlStateNormal];
            UIImage *imageCheck=[UIImage imageNamed:@"group_icon"];
            NSData *data1 = UIImagePNGRepresentation(img);
            NSData *data2 = UIImagePNGRepresentation(imageCheck);
            __block UIImage *imgGroup;
            if([data1 isEqual:data2]){
                imgGroup=[UIImage new];
            }else{
                imgGroup=img;
            }

            NSMutableArray *arrgroupMember1=[[NSMutableArray alloc]init];
            for (int i=0; i<mutableArr.count; i++) {
                NSDictionary *dict1=[mutableArr objectAtIndex:i];
                NSString *registeration=[dict1 objectForKey:@"registeration"];
                if([registeration isEqualToString:@"1"]){
                    QBUUser *user = [QBUUser new];
                    user.ID=[[dict1 objectForKey:@"ID"]intValue];
                    user.login=[dict1 objectForKey:@"name"];
                    user.fullName=[dict1 objectForKey:@"full_name"];
                    [arrgroupMember1 addObject:user];
                }
            }
            [dict setObject:mutableArr forKey:@"groupMember"];
            [self createChatWithName:self.txtGroupName.text arruser:arrgroupMember1 completion:^(QBChatDialog *dialog) {
                
                
                [dict setObject:[NSString stringWithFormat:@"%@",dialog.ID] forKey:@"QuickGroupId"];
                [dict setObject:self.txtGroupName.text forKey:@"name"];
                
                NSData *dataForProfile = UIImageJPEGRepresentation(imgGroup, 0.6f);
                NSString *myProfileBase64String = [dataForProfile base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if(!(myProfileBase64String)){
                    [dict setObject:@"" forKey:@"groupIMG"];
                }else{
                    [dict setObject:myProfileBase64String forKey:@"groupIMG"];
                }
                [[ApiClient sharedInstance] addGroup:dict success:^(id responseObject) {
                    [ind removeFromSuperview];
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"RefreshGroup"
                     object:self];
                    self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
                } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                    [ind removeFromSuperview];
                    [AlertView showAlertWithMessage:errorString];
                }];
                
            }];
            
        }
    }
    if(alertView.tag==102){
        NSMutableArray *mutableArr=[self arryMember];
        UIImage *img = [self.btnGroupPic imageForState:UIControlStateNormal];
        UIImage *imageCheck=[UIImage imageNamed:@"group_icon"];
        NSData *data1 = UIImagePNGRepresentation(img);
        NSData *data2 = UIImagePNGRepresentation(imageCheck);
        UIImage *imgGroup;
        if([data1 isEqual:data2]){
            imgGroup=[UIImage new];
        }else{
            imgGroup=img;
        }
        if(buttonIndex==1){
            
            KittyRulesViewController* controller = [[KittyRulesViewController alloc] initWithNibName:@"KittyRulesViewController" bundle:nil];
            controller.arryGroupMember=mutableArr;
            controller.imgGroup=imgGroup;
            controller.strInMiddelKitty=@"No";
            controller.strGroupName=self.txtGroupName.text;
            controller.strKittyType=self.kittyName;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(buttonIndex==0){
            
            InMiddelKittyViewController* controller = [[InMiddelKittyViewController alloc] initWithNibName:@"InMiddelKittyViewController" bundle:nil];
            controller.arryGroupMember=mutableArr;
            controller.imgGroup=imgGroup;
            controller.strGroupName=self.txtGroupName.text;
            controller.strKittyType=self.kittyName;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    }
    
    
}

-(NSMutableArray *)arryMember{
    
    NSMutableArray * mutableArr = [[NSMutableArray alloc]init];
    
    //    [selectedData enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    //        NSDictionary *dict=[self.dictContact objectAtIndex:idx];
    //        [mutableArr addObject:dict];
    //    }];
    
    for (int i=0; i<arrySelectedValue.count; i++) {
        NSDictionary *dataDict=[self.dictContact objectAtIndex:[[arrySelectedValue objectAtIndex:i] integerValue]];
        [mutableArr addObject:dataDict];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSString *UserName=[prefs stringForKey:@"UserName"];
    NSString *profilePic=[prefs stringForKey:@"profilePic"];
    NSString *phone=[prefs stringForKey:@"phone"];
    NSString *status=[prefs stringForKey:@"status"];
    NSString *ID=[prefs stringForKey:@"quickID"];
    NSString *login=[prefs stringForKey:@"quicklogin"];
    NSString *full_name=[prefs stringForKey:@"quickfull_name"];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:profilePic forKey:@"image"];
    [dict setObject:UserName forKey:@"name"];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:@"1" forKey:@"registeration"];
    [dict setObject:status forKey:@"status"];
    [dict setObject:USERID forKey:@"userid"];
    
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:login forKey:@"login"];
    [dict setObject:full_name forKey:@"full_name"];
    [mutableArr addObject:dict];
    return mutableArr;
    
}
#pragma mark ---------- Action sheet delegate ------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(buttonIndex==0){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if(buttonIndex==1){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark ---------- imagePickerController delegate ------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.btnGroupPic setImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cmdgroupPic:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
    
}



#pragma mark searchbar
-(void)searchBar:(UISearchBar*)searchbar textDidChange:(NSString*)text
{
    if ([text length] == 0)
    {
        searchResults=[self.dictContact mutableCopy];
        [self.tblView reloadData];
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
    for (int i=0; i<self.dictContact.count; i++) {
        NSDictionary *Dict=[self.dictContact objectAtIndex:i];
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
    
    [self.tblView  reloadData];
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





- (void)createChatWithName:(NSString *)name arruser:(NSArray *)arruser completion:(void(^)(QBChatDialog *dialog))completion {
    
    
    NSArray *selectedUsers = arruser;//[self.dataSource.users objectsAtIndexes:selectedUsersIndexSet];
    
    //    if (selectedUsers.count == 1) {
    //        // Creating private chat dialog.
    //        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:selectedUsers.firstObject completion:^(QBResponse *response, QBChatDialog *createdDialog) {
    //            if (!response.success && createdDialog == nil) {
    //                if (completion) {
    //                    completion(nil);
    //                }
    //            }
    //            else {
    //                if (completion) {
    //                    completion(createdDialog);
    //                }
    //            }
    //        }];
    //    } else if (selectedUsers.count > 1) {
    if (name == nil || [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"%@_", [QBSession currentSession].currentUser.fullName];
        for (QBUUser *user in selectedUsers) {
            name = [NSString stringWithFormat:@"%@%@,", name, user.fullName];
        }
        name = [name substringToIndex:name.length - 1]; // remove last , (comma)
    }
    else {
        name = [name stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    // [SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING", nil) maskType:SVProgressHUDMaskTypeClear];
    
    
    // Creating group chat dialog.
    [ServicesManager.instance.chatService createGroupChatDialogWithName:name photo:nil occupants:selectedUsers completion:^(QBResponse *response, QBChatDialog *createdDialog) {
        if (response.success) {
            NSString * notificationText = [self updatedMessageWithUsers:selectedUsers];
            // Notifying users about created dialog.
            [[ServicesManager instance].chatService sendSystemMessageAboutAddingToDialog:createdDialog
                                                                              toUsersIDs:createdDialog.occupantIDs
                                                                                withText:notificationText
                                                                              completion:^(NSError *error) {
                                                                                  
                                                                                  // Notify occupants that dialog was updated.
                                                                                  [[ServicesManager instance].chatService sendNotificationMessageAboutAddingOccupants:createdDialog.occupantIDs
                                                                                                                                                             toDialog:createdDialog
                                                                                                                                                 withNotificationText:notificationText
                                                                                                                                                           completion:nil];
                                                                                  
                                                                                  if (completion) {
                                                                                      completion(createdDialog);
                                                                                  }
                                                                              }];
        } else {
            if (completion) {
                completion(nil);
            }
        }
    }];
    //    } else {
    //        assert("no given users");
    //    }
}

#pragma mark - Helpers
- (NSString *)updatedMessageWithUsers:(NSArray *)users {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@ ", [ServicesManager instance].currentUser.fullName, NSLocalizedString(@"SA_STR_CREATE_NEW", nil)];
    
    for (QBUUser *user in users) {
        message = [NSString stringWithFormat:@"%@%@,", message, user.fullName];
    }
    message = [message substringToIndex:message.length - 1]; // remove last , (comma)
    
    return message;
}


@end
