//
//  SettingPageViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 22/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "SettingPageViewController.h"
#import "MyProfileViewController.h"
#import "NewMembersViewController.h"
#import "DeleteMemberViewController.h"
@interface SettingPageViewController (){
    IndecatorView *ind;
    NSDictionary *dictGroup;
    NSArray *memberArry;
    NSString *checkBlankHostID;
    UIView *contentView;
    UPStackMenu *stack;
    UIView *backView;


}

@end

@implementation SettingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_button"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    contentView.backgroundColor=[UIColor clearColor];
    icon.frame=contentView.bounds;
    [contentView addSubview:icon];
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
     [self setAnimation];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self getSetting];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"SETTING";
    if([self.is_admin isEqualToString:@"1"]){
        NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
        UIButton *btnGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGroup.frame = CGRectMake(0, 0, 32, 32);
        [btnGroup setImage:[UIImage imageNamed:@"add-people"] forState:UIControlStateNormal];
        
        [btnGroup addTarget:self action:@selector(cmdAddGroup:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnGroup];
        [arrRightBarItems addObject:btnGroupBar];
        self.navigationItem.rightBarButtonItems=arrRightBarItems;
    }
    
    checkBlankHostID=@"NoBlankID";
    
    for (int i=0; i<self.host_id.count; i++) {
        NSString *idd=[self.host_id objectAtIndex:i];
        if([idd isEqualToString:@""]){
            checkBlankHostID=idd;
            break;
        }
    }
    
}


-(void)cmdAddGroup:(id)sender{
    
    NewMembersViewController* controller = [[NewMembersViewController alloc] initWithNibName:@"NewMembersViewController" bundle:nil];
    controller.groupId=self.groupId;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 250;
    }
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    return memberArry.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    
    if(indexPath.section==0){
        cell.backgroundColor=[UIColor clearColor];
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 210, self.view.frame.size.width, 40)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:22];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        //lblName.text=[dict objectForKey:@"name"];
        lblName.text=[dictGroup objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(changeName:)];
        [lblName addGestureRecognizer:singleFingerTap];
        
        return cell;
    }else if(indexPath.section==1){
        NSDictionary *dict=[memberArry objectAtIndex:indexPath.row];
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner.showActivityIndicator=YES;
        
        NSString *strImgUrl=[dict objectForKey:@"profile"];
        strImgUrl=[strImgUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strImgUrl];
        
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        banner.layer.cornerRadius=20;
        [cell.contentView addSubview:banner];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *USERID = [prefs stringForKey:@"USERID"];
        if([USERID isEqualToString:[dict objectForKey:@"user_id"]]){
            if([self.is_admin isEqualToString:@"1"]){
                
            }
        }
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 130, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text=[dict objectForKey:@"name"];
        
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 15)];
        lblList.backgroundColor=[UIColor clearColor];
        lblList.numberOfLines=2;
        lblList.lineBreakMode=NSLineBreakByWordWrapping;
        lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList.text=[dict objectForKey:@"status"];
        lblList.alpha=0.5;
        lblList.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList];
        
        
        if((([checkBlankHostID isEqualToString:@""]) && ([self.is_admin isEqualToString:@"1"])) || [self.strToHost isEqualToString:@"1"]){
            
            if(!([[dict objectForKey:@"user_id"] isEqualToString:@""])){
                
                UIButton *btnGiveRight = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 20, 100, 20)];
                [btnGiveRight addTarget:self
                                 action:@selector(cmdGiveRight:)
                       forControlEvents:UIControlEventTouchUpInside];
                btnGiveRight.tag=indexPath.row;
                btnGiveRight.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:10];
                [btnGiveRight setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
                [btnGiveRight setTitle:@"Give Right To Edit" forState:UIControlStateNormal];
                btnGiveRight.layer.cornerRadius=10;
                btnGiveRight.clipsToBounds=YES;
                [cell.contentView addSubview:btnGiveRight];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 30)];
    view.backgroundColor=[UIColor   colorWithPatternImage:[UIImage imageNamed:@"gradient-strip"]];
//view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:245/255.0 alpha:1.0];
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/3-10, 30)];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=@"Particpants";
    lblName.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lblName];
    
    UILabel *lblNumber=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 0, 50, 30)];
    lblNumber.numberOfLines=2;
    lblNumber.lineBreakMode=NSLineBreakByWordWrapping;
    lblNumber.font = [UIFont fontWithName:@"GothamMedium" size:12];
    lblNumber.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    
    lblNumber.text=[NSString stringWithFormat:@"%lu",(unsigned long)memberArry.count];
    lblNumber.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lblNumber];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo",@"Select Photo", nil];
        actionSheet.tag=1001;
        [actionSheet showInView:self.view];
        
    }else if(indexPath.section==1){
        NSDictionary *dict=[memberArry objectAtIndex:indexPath.row];
        if(!([[dict objectForKey:@"user_id"] isEqualToString:@""])){
            
            if([self.is_admin isEqualToString:@"1"]){
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:nil
                                              delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"Delete Member",@"ViewProfile", nil];
                actionSheet.tag=indexPath.row;
                [actionSheet showInView:self.view];
            }else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:nil
                                              delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"ViewProfile", nil];
                actionSheet.tag=indexPath.row;
                [actionSheet showInView:self.view];
            }
            
           
        }else{
             if([self.is_admin isEqualToString:@"1"]){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"Delete Member", nil];
            actionSheet.tag=indexPath.row;
            [actionSheet showInView:self.view];
             }else{
                 [AlertView showAlertWithMessage:@"Member not register."];
             }
            
        }
    }
}

-(void)changeName:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter new Group name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=10001;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alert show];
    
}



-(void)cmdGiveRight:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict1=[memberArry objectAtIndex:btn.tag];
    NSString *userID=[dict1 objectForKey:@"user_id"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [dict setObject:self.kittyId forKey:@"kitty_id"];
    [dict setObject:USERID forKey:@"from"];
    [dict setObject:userID forKey:@"to"];
    
    [self.view addSubview:ind];
    [[ApiClient sharedInstance]giveRightToEdit:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}
#pragma mark ---------- Action sheet delegate ------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag==1001){
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
    }else {
         NSDictionary *dict=[memberArry objectAtIndex:actionSheet.tag];
        if(buttonIndex==0){
            [self.view addSubview:ind];
            if([self.is_admin isEqualToString:@"1"]){
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSString *USERID = [prefs stringForKey:@"USERID"];
                if([USERID isEqualToString:[dict objectForKey:@"user_id"]]){
                    if([self.is_admin isEqualToString:@"1"]){
                        [AlertView showAlertWithMessage:@"Admin can't delete its self"];
                        return;
                    }
                }
                if([[dict objectForKey:@"current_host"] isEqualToString:@"1"]){
                    [AlertView showAlertWithMessage:@"Cannot delete current host"];

                    return;
                }
                
                NSMutableDictionary *dictData=[[NSMutableDictionary alloc]init];
                [dictData setObject:self.kittyId forKey:@"kitty_id"];
                [dictData setObject:self.groupId forKey:@"group_id"];
                [dictData   setObject:[dict objectForKey:@"id"] forKey:@"member_id"];
                [[ApiClient sharedInstance]deleteMember:dictData success:^(id responseObject) {
                    [ind removeFromSuperview];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                    [ind removeFromSuperview];
                    [AlertView showAlertWithMessage:errorString];
                }];

            }else{
                NSLog(@"[actionSheet buttonTitleAtIndex:buttonIndex] %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
                MyProfileViewController* controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
                controller.strOtherPersonProfile=[dict objectForKey:@"user_id"];
                controller.strOtherPersonName=[dict objectForKey:@"name"];
                [self.navigationController pushViewController:controller animated:YES];
            }

        }else if(buttonIndex==1){
             NSLog(@"[actionSheet buttonTitleAtIndex:buttonIndex] %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
            if(!([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"])){
            MyProfileViewController* controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
            controller.strOtherPersonProfile=[dict objectForKey:@"user_id"];
            controller.strOtherPersonName=[dict objectForKey:@"name"];
            [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark ---------- imagePickerController delegate ------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgGroup.image=chosenImage;
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)showMsg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to update the group image ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1001){
        NSString *strChild=[[alertView textFieldAtIndex:0] text];
        strChild=[strChild stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(buttonIndex==1){
            if(!(strChild.length==0)){
                [self.view addSubview:ind];
                NSMutableDictionary *Dict=[[NSMutableDictionary alloc]init];
                [Dict setObject:[[alertView textFieldAtIndex:0] text] forKey:@"name"];
                [[ApiClient sharedInstance]updateGroupImage:self.groupId dict:Dict success:^(id responseObject) {
                    [ind removeFromSuperview];
                } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                    [ind removeFromSuperview];
                    [AlertView showAlertWithMessage:errorString];
                }];
            }else{
                [AlertView showAlertWithMessage:@"Please enter proper text"];
            }
        }
    }else{
        if(buttonIndex==1){
            [self.view addSubview:ind];
            NSMutableDictionary *Dict=[[NSMutableDictionary alloc]init];
            NSData *dataForProfile = UIImageJPEGRepresentation(self.imgGroup.image, 0.6f);
            NSString *myProfileBase64String = [dataForProfile base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [Dict setObject:myProfileBase64String forKey:@"groupIMG"];
            [[ApiClient sharedInstance]updateGroupImage:self.groupId dict:Dict success:^(id responseObject) {
                [ind removeFromSuperview];
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:errorString];
            }];
        }
    }
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)getSetting{
    
    [self.view addSubview:ind];
    [[ApiClient sharedInstance]getSetting:self.groupId success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        dictGroup=[dict objectForKey:@"data"];
        NSString *strImgUrl=[dictGroup objectForKey:@"groupIMG"];
        strImgUrl=[strImgUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        self.imgGroup.showActivityIndicator=YES;
        self.imgGroup.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        self.imgGroup.imageURL=[NSURL URLWithString:strImgUrl];
        
        memberArry=[dictGroup objectForKey:@"participant"];
        [self.tblSetting reloadData];
        [self.view addSubview:stack];
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [self.view addSubview:stack];
        [AlertView showAlertWithMessage:errorString];
    }];
}

#pragma mark - Animation

-(void)setAnimation{
    if(stack)
        [stack removeFromSuperview];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if( screenHeight > 480 && screenHeight < 667 ){
        NSLog(@"iPhone 5/5s");
        stack.frame=CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-120, 50, 50);
    } else if ( screenHeight > 480 && screenHeight < 736 ){
        NSLog(@"iPhone 6");
        stack.frame=CGRectMake(self.view.frame.size.width-10, self.view.frame.size.height-25, 50, 50);
    } else if ( screenHeight > 735 ){
        NSLog(@"iPhone 6 Plus");
        stack.frame=CGRectMake(screenRect.size.width-60, screenRect.size.height-120, 50, 50);
    } else {
        stack.frame=CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-210, 50, 50);
        NSLog(@"iPhone 4/4s");
    }
    
    contentView.layer.cornerRadius=25;
    stack.clipsToBounds=NO;
    [stack.layer setBorderWidth:0];
    [stack.layer setShadowColor:[UIColor blackColor].CGColor];
    [stack.layer setShadowOpacity:0.8];
    [stack.layer setShadowRadius:3.0];
    [stack.layer setShadowOffset:CGSizeMake(1, 1)];
    [stack setDelegate:self];
    
   // UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"personal_notes-1"] highlightedImage:nil title:@"View Profile"];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"add-member"] highlightedImage:nil title:@"Add Member"];
    UPStackMenuItem *triangleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"delete-member"] highlightedImage:nil title:@"Delete Member"];
    UPStackMenuItem *crossItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"refresh-group"] highlightedImage:nil title:@"Refresh Group"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:crossItem,triangleItem,circleItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];
    
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];
    
    [stack addItems:items];
    // [self.view addSubview:stack];
    [self setStackIconClosed:YES];
    
}
- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}
#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    [self.view addSubview:backView];
    [backView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [backView addGestureRecognizer:singleTap];
    [self.view bringSubviewToFront:stack];
    [self setStackIconClosed:NO];
}
- (void)oneTap:(UIGestureRecognizer *)gesture {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMenu" object:self];
    
}
- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    [backView removeFromSuperview];
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    if(index==2){
        
        if([self.is_admin isEqualToString:@"1"]){
            NewMembersViewController* controller = [[NewMembersViewController alloc] initWithNibName:@"NewMembersViewController" bundle:nil];
            controller.groupId=self.groupId;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [AlertView showAlertWithMessage:@"Only admin can add new member"];
        }
        

    }else if(index==1){
        DeleteMemberViewController* controller = [[DeleteMemberViewController alloc] initWithNibName:@"DeleteMemberViewController" bundle:nil];
        controller.arryMemberList=memberArry;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(index==0){
        if([self.is_admin isEqualToString:@"1"]){
            [self.view addSubview:ind];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:@"0" forKey:@"delete"];
            [[ApiClient sharedInstance]deleteGroup:self.groupId deleteYesOrNo:dict success:^(id responseObject) {
                
                NSDictionary *DataVal=responseObject;
                NSArray *ArryKittyId=[DataVal objectForKey:@"kittyList"];
                for (int i=0; i<ArryKittyId.count; i++) {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"BILL%@%@",self.groupId,[ArryKittyId objectAtIndex:i]]];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@PERSONAL NOTES",self.groupId,[ArryKittyId objectAtIndex:i]]];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@KITTY NOTES",self.groupId,[ArryKittyId objectAtIndex:i]]];
                    
                }
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.groupId];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"GroupDiaries%@",self.groupId]];
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:@"Group Refreshed Successfully."];
                
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:errorString];
            }];

            
        }else{
            [AlertView showAlertWithMessage:@"Only admin can refresh group."];
        }
    }else if(index==3){
    }
}


@end
