//
//  HomeViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "HomeViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "ChatViewController.h"
#import "NotificationViewController.h"
#import "MyProfileViewController.h"
#import "MakeGroupViewController.h"
#import "VenuViewController.h"
#import "PermotionalListingViewController.h"
#import "DiaryViewController.h"
#import "NewChatViewController.h"
@interface HomeViewController (){
    NSIndexPath *indexPathTblChat;
    NSMutableArray *arryContact;
    IndecatorView *ind;
    IndecatorView *indChatLoging;
    NSDictionary *dictArticle;
    NSArray *tblContactData;
    UISearchBar *searchBar;
    NSMutableArray *contactSearchResult;
    BOOL showContactSearch;
    BOOL showChatSearch;
    NSMutableArray *chatSearchResult;
    NSArray *arryGroup;
    NSMutableArray *arrMergData;
}

@end
@implementation HomeViewController
@synthesize SelectedTabanimation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"NotificationPage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"ProfilePage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"RefreshGroup"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"OflineMode"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"OflineModeHost"
                                               object:nil];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.6; //seconds
    lpgr.delegate = self;
    [self.tblChats addGestureRecognizer:lpgr];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    UIButton *btnGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGroup.frame = CGRectMake(0, 0, 32, 32);
    [btnGroup setImage:[UIImage imageNamed:@"add_group"] forState:UIControlStateNormal];
    
    [btnGroup addTarget:self action:@selector(cmdAddGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnGroup];
    [arrRightBarItems addObject:btnGroupBar];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btnSearch.frame = CGRectMake(0, 0, 32, 32);
    
    [btnSearch addTarget:self action:@selector(cmdSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    [arrRightBarItems addObject:btnSearchBar];
    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    indChatLoging=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(PullTorefreshContact:) forControlEvents:UIControlEventValueChanged];
    [self.tblContacts addSubview:refreshControl];
    
    UIRefreshControl *refreshControlArtical = [[UIRefreshControl alloc] init];
    [refreshControlArtical addTarget:self action:@selector(PullTorefreshArtical:) forControlEvents:UIControlEventValueChanged];
    [self.tblArtical addSubview:refreshControlArtical];
    
    UIRefreshControl *refreshControlChats = [[UIRefreshControl alloc] init];
    [refreshControlChats addTarget:self action:@selector(PullTorefreshChats:) forControlEvents:UIControlEventValueChanged];
    [self.tblChats addSubview:refreshControlChats];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"StoreContactArtical"];
    if(!(dict)){
        [self getArticle];
    }else{
        [self getArticalData];
    }
    NSArray *arryDataGroup= [defaults objectForKey:@"GroupCreated"];
    if(arryDataGroup){
        [self showGroup];
        [self getGroupinBackground];
    }else{
        [self getGroup];
    }
    [self getBanner];
    
    QBUUser *user = [QBUUser new];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    USERID =[NSString stringWithFormat:@"0%@",USERID];
    NSString *UserName= [prefs stringForKey:@"UserName"];
    user.login = USERID;
    user.password = @"KittyBeeArun";
    user.fullName=UserName;
    //NSString  *password = user.password;
    //  self.view.userInteractionEnabled=NO;
    
    [self.view addSubview:indChatLoging];
    
    //    [ServicesManager.instance logInWithUser:user completion:^(BOOL success, NSString *errorMessage) {
    //        if (success) {
    self.observerDidBecomeActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                     object:nil queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note) {
                                                                                     if (![[QBChat instance] isConnected]) {
                                                                                         
                                                                                         //[SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_CONNECTING_TO_CHAT", nil) maskType:SVProgressHUDMaskTypeClear];
                                                                                     }
                                                                                 }];
    
    if ([ServicesManager instance].isAuthorized) {
        [indChatLoging removeFromSuperview];
        [self loadDialogs];
    }else{
        [indChatLoging removeFromSuperview];
        NSLog(@"not authorisied");
    }
    
    //self.view.userInteractionEnabled=YES;
    // self.navigationItem.title = [ServicesManager instance].currentUser.login;
    //            [ServicesManager.instance.chatService connectWithCompletionBlock:nil];
    //            [self createChatWithName:@"teteTest" completion:^(QBChatDialog *dialog) {
    //                [self.tblChats reloadData];
    //            }];
    //        }else{
    //            self.view.userInteractionEnabled=YES;
    //             NSLog(@"not login");
    //        }
    //    }];
    
    [[ServicesManager instance].chatService addDelegate:self];
    
    //self.navigationItem.leftBarButtonItems=arrRightBarItems;
    // self.navigationItem.rightBarButtonItem = uploadButton;
}
-(void)cmdSearch:(id)sender{
    CGFloat xOffset = self.ScrollView.contentOffset.x;
    if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
        if(showContactSearch){
            showContactSearch=NO;
        }else{
            showContactSearch=YES;
        }
        
        [self.tblContacts reloadData];
    }else if(xOffset<self.view.frame.size.width){
        
        if(showChatSearch){
            showChatSearch=NO;
        }else{
            showChatSearch=YES;
        }
        [self.tblChats reloadData];
    }
}

- (void)PullTorefreshChats:(UIRefreshControl *)refreshControl {
    [self getGroup];
    [refreshControl endRefreshing];
}


- (void)PullTorefreshArtical:(UIRefreshControl *)refreshControl {
    [self getArticle];
    [refreshControl endRefreshing];
}


- (void)PullTorefreshContact:(UIRefreshControl *)refreshControl {
    [self askPermissionContact];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cmdAddGroup:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Couple Kitty",@"Kitty with Kids",@"Normal Kitty", nil];
    [alert show];
    
}
- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"NotificationPage"]){
        NotificationViewController* controller = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else if([[notification name] isEqualToString:@"ProfilePage"]){
        MyProfileViewController* controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else if([[notification name] isEqualToString:@"RefreshGroup"]){//RefreshGroup
        [self getGroupinBackground];
    }else if([[notification name] isEqualToString:@"OflineMode"]){
        [self CheckOfflineSync];
    }else if([[notification name] isEqualToString:@"OflineModeHost"]){//OflineModeHost
        [self checkOflineHostSync];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    //        NSLog(@"Fonts%@",[UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    //        for(NSString *fontfamilyname in [UIFont familyNames])
    //        {
    //            NSLog(@"family:'%@'",fontfamilyname);
    //            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
    //            {
    //                NSLog(@"\tfont:'%@'",fontName);
    //            }
    //            NSLog(@"-------------");
    //        }
    showContactSearch=NO;
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"StoreContactData"];
    if(dict){
        [self getcontact];
    }else{
        [self askPermissionContact];
    }
    [self showChatData:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addingAnimationToTable];
    
    
}
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if(tableView==self.tblChats){
//        return 2;
//    }
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(self.tblContacts==tableView){
        return  60;
    }else if(self.tblChats==tableView){
        return  92;
    }else{
        if (indexPath.row==0) {
            return 60;
        }else  if (indexPath.row==1) {
            return 200;
        }else {
            return 300;
        }
        
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.tblArtical==tableView){
        return 3;
    }else if(self.tblContacts==tableView){
        return contactSearchResult.count;
    }else{
        return arrMergData.count;
    
    }
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
    cell.backgroundColor=[UIColor clearColor];
    if(self.tblContacts==tableView){
        NSDictionary *dict=[contactSearchResult objectAtIndex:indexPath.row];
        
        AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        
        banner.showActivityIndicator=YES;
        banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        banner.image=[UIImage imageNamed:@"DefualtImg.png"];
        NSString *strUrl=[dict objectForKey:@"image"];
        strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        banner.imageURL=[NSURL URLWithString:strUrl];
        banner.clipsToBounds=YES;
        [banner setContentMode:UIViewContentModeScaleAspectFill];
        banner.layer.cornerRadius=20;
        [cell.contentView addSubview:banner];
        
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 147, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=1;
        lblName.lineBreakMode=NSLineBreakByTruncatingTail;
        lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
        lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblName.text=[dict objectForKey:@"name"];
        lblName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblName];
        
        UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, self.view.frame.size.width-120, 25)];
        lblList.backgroundColor=[UIColor clearColor];
        lblList.numberOfLines=1;
        lblList.lineBreakMode=NSLineBreakByTruncatingTail;
        lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
        lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
        lblList.text=[dict objectForKey:@"status"];
        
        lblList.alpha=0.5;
        lblList.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblList];
        NSString *registeration=[dict objectForKey:@"registeration"];
        if([registeration isEqualToString:@"1"]){
            UIButton *btnCall = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-43, 15, 30, 30)];
            [btnCall addTarget:self
                        action:@selector(cmdCall:)
              forControlEvents:UIControlEventTouchUpInside];
            btnCall.tag=indexPath.row;
            [btnCall setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnCall];
        }else{
            lblList.text=[dict objectForKey:@"phone"];
            UIButton *btnCall = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-113, 15, 100, 30)];
            [btnCall addTarget:self
                        action:@selector(cmdInvite:)
              forControlEvents:UIControlEventTouchUpInside];
            btnCall.tag=indexPath.row;
            [btnCall setTitle:@"INVITE" forState:UIControlStateNormal];//128,222,234
            [btnCall setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
            btnCall.titleLabel.font=[UIFont fontWithName:@"GothamMedium" size:12];
            btnCall.layer.cornerRadius=15;
            btnCall.clipsToBounds=YES;
            
            [cell.contentView addSubview:btnCall];
        }
        
    }else if(self.tblChats==tableView){
        
        if(indexPath.section==0){
            
            NSDictionary *dict1= [arrMergData objectAtIndex:indexPath.row];
            NSDictionary *dict=[dict1 objectForKey:@"OurGroup"];
           
            QBChatDialog *chatDialog=[dict1 objectForKey:@"Dialog"];
            
            
            AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 15,56,56)];
            banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
            banner.image=[UIImage imageNamed:@"DefualtImg.png"];
            NSString *strURl;
            if(dict){
                strURl=[dict objectForKey:@"groupIMG"];
            }else{
                NSArray *imgArr=chatDialog.occupantIDs;
                NSString *user1=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:0]];
                NSString *user2=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:1]];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *userQuickId= [defaults objectForKey:@"quickID"];
                if([user1 isEqualToString:userQuickId]){
                    for (int i=0; i<tblContactData.count; i++) {
                        NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                        NSString *idd=[Dictdata objectForKey:@"ID"];
                        if([idd isEqualToString:user2]){
                            strURl=[Dictdata objectForKey:@"image"];
                            break;
                        }
                    }
                }else if ([user2 isEqualToString:userQuickId]){
                    for (int i=0; i<tblContactData.count; i++) {
                        NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                        NSString *idd=[Dictdata objectForKey:@"ID"];
                        if([idd isEqualToString:user1]){
                            strURl=[Dictdata objectForKey:@"image"];
                            break;
                        }
                    }
                }
            }
            strURl=[strURl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            banner.imageURL=[NSURL URLWithString:strURl];
            banner.clipsToBounds=YES;
            [banner setContentMode:UIViewContentModeScaleAspectFill];
            banner.layer.cornerRadius=28;
            [cell.contentView addSubview:banner];
            
            UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 160, 20)];
            lblName.backgroundColor=[UIColor clearColor];
            lblName.numberOfLines=1;
            lblName.lineBreakMode=NSLineBreakByWordWrapping;
            lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
            lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            // QBUUser *recipient = [[ServicesManager instance].usersService.usersMemoryStorage userWithID:chatDialog.recipientID];
            lblName.text=chatDialog.name;//recipient.login == nil ? (recipient.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)recipient.ID] : recipient.fullName) : recipient.login;//[dict objectForKey:@"name"];
            lblName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblName];
            
            UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, self.view.frame.size.width-120, 20)];
            lblList.backgroundColor=[UIColor clearColor];
            lblList.numberOfLines=1;
            lblList.lineBreakMode=NSLineBreakByWordWrapping;
            lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
            lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            lblList.text=chatDialog.lastMessageText;//@"7/5 race cource ambal cantt,haryana";
            lblList.alpha=0.5;
            lblList.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblList];
            
            
            
            UILabel *lblMessageCount=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, 36, 20, 20)];
            lblMessageCount.backgroundColor=[UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
            
            lblMessageCount.layer.cornerRadius=10;
            lblMessageCount.clipsToBounds=YES;
            lblMessageCount.numberOfLines=1;
            lblMessageCount.lineBreakMode=NSLineBreakByWordWrapping;
            lblMessageCount.font = [UIFont fontWithName:@"GothamBook" size:11];
            lblMessageCount.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            lblMessageCount.text=chatDialog.lastMessageText;//@"7/5 race cource ambal cantt,haryana";
            lblMessageCount.alpha=1;
            lblMessageCount.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lblMessageCount];
            
            
            BOOL hasUnreadMessages = chatDialog.unreadMessagesCount > 0;
            lblMessageCount.hidden = !hasUnreadMessages;
            if (hasUnreadMessages) {
                
                if (chatDialog.unreadMessagesCount > 99) {
                    lblMessageCount.text = @"99+";
                } else {
                    lblMessageCount.text =[NSString stringWithFormat:@"%lu", (unsigned long)chatDialog.unreadMessagesCount];
                }
                
            } else {
                lblMessageCount.text = @"";
            }
            
            NSString *isRuleSet=[dict objectForKey:@"set_rule"];
            if([isRuleSet isEqualToString:@"0"]){
                
            }else{
                if(dict){
                    NSString *is_admin=[dict objectForKey:@"is_admin"];
                    NSArray *host_id=[dict objectForKey:@"host_id"];
                    NSString *checkBlankHostID=@"NoBlankID";
                    
                    for (int i=0; i<host_id.count; i++) {
                        NSString *idd=[host_id objectAtIndex:i];
                        if([idd isEqualToString:@""]){
                            checkBlankHostID=idd;
                            break;
                        }
                    }
                    
                    NSString *strToHost=[dict objectForKey:@"is_host"];
                    if(([checkBlankHostID isEqualToString:@""]) && ([is_admin isEqualToString:@"1"])){
                        UIButton *btnHost = [[UIButton alloc]initWithFrame:CGRectMake(80, 50, 32, 29)];
                        [btnHost addTarget:self
                                    action:@selector(cmdHost:)
                          forControlEvents:UIControlEventTouchUpInside];
                        btnHost.tag=indexPath.row;
                        [btnHost setImage:[UIImage imageNamed:@"admin-host"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnHost];
                        
                        UIButton *btnPermotionalListing = [[UIButton alloc]initWithFrame:CGRectMake(117, 50, 32, 29)];
                        [btnPermotionalListing addTarget:self
                                                  action:@selector(cmdPermotionalListing:)
                                        forControlEvents:UIControlEventTouchUpInside];
                        [btnPermotionalListing setImage:[UIImage imageNamed:@"announcement"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnPermotionalListing];
                        
                    }else if([strToHost isEqualToString:@"1"]){
                        UIButton *btnHost = [[UIButton alloc]initWithFrame:CGRectMake(80, 50, 32, 29)];
                        [btnHost addTarget:self
                                    action:@selector(cmdHost:)
                          forControlEvents:UIControlEventTouchUpInside];
                        btnHost.tag=indexPath.row;
                        [btnHost setImage:[UIImage imageNamed:@"host"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnHost];
                        
                        UIButton *btnPermotionalListing = [[UIButton alloc]initWithFrame:CGRectMake(117, 50, 32, 29)];
                        [btnPermotionalListing addTarget:self
                                                  action:@selector(cmdPermotionalListing:)
                                        forControlEvents:UIControlEventTouchUpInside];
                        [btnPermotionalListing setImage:[UIImage imageNamed:@"announcement"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnPermotionalListing];
                    }//80, 50, 32, 29
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    NSString *USERID = [prefs stringForKey:@"USERID"];
                    
                    NSArray *rightHost=[dict objectForKey:@"rights"];
                    BOOL contains = [rightHost containsObject:USERID];
                    if(contains){
                        
                        UIButton *btnHost = [[UIButton alloc]initWithFrame:CGRectMake(80, 50, 32, 29)];
                        [btnHost addTarget:self
                                    action:@selector(cmdHost:)
                          forControlEvents:UIControlEventTouchUpInside];
                        btnHost.tag=indexPath.row;
                        [btnHost setImage:[UIImage imageNamed:@"host"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnHost];
                        
                        UIButton *btnPermotionalListing = [[UIButton alloc]initWithFrame:CGRectMake(117, 50, 32, 29)];
                        [btnPermotionalListing addTarget:self
                                                  action:@selector(cmdPermotionalListing:)
                                        forControlEvents:UIControlEventTouchUpInside];
                        [btnPermotionalListing setImage:[UIImage imageNamed:@"announcement"] forState:UIControlStateNormal];
                        [cell.contentView addSubview:btnPermotionalListing];
                    }
                    UIButton *btnDiary = [[UIButton alloc]initWithFrame:CGRectMake(153, 50, 32, 29)];
                    if([strToHost isEqualToString:@"0"]){
                        btnDiary.frame=CGRectMake(80, 50, 32, 29);
                    }
                    if(([checkBlankHostID isEqualToString:@""]) && ([is_admin isEqualToString:@"1"])){
                        btnDiary.frame=CGRectMake(153, 50, 32, 29);
                    }
                    if(contains){
                        btnDiary.frame=CGRectMake(153, 50, 32, 29);
                    }
                    
                    [btnDiary addTarget:self
                                 action:@selector(cmdDairy:)
                       forControlEvents:UIControlEventTouchUpInside];
                    btnDiary.tag=indexPath.row;
                    [btnDiary setImage:[UIImage imageNamed:@"diary_normal"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:btnDiary];
                }
                
            }
        }else if(indexPath.section==1){
            QBChatDialog *chatDialog = self.OneToOneChat[indexPath.row];
            NSArray *imgArr=chatDialog.occupantIDs;
            NSString *user1=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:0]];
            NSString *user2=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:1]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userQuickId= [defaults objectForKey:@"quickID"];
            NSString *strURl;
            if([user1 isEqualToString:userQuickId]){
                for (int i=0; i<tblContactData.count; i++) {
                    NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                    NSString *idd=[Dictdata objectForKey:@"ID"];
                    if([idd isEqualToString:user2]){
                        strURl=[Dictdata objectForKey:@"image"];
                        break;
                    }
                }
            }else if ([user2 isEqualToString:userQuickId]){
                for (int i=0; i<tblContactData.count; i++) {
                    NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                    NSString *idd=[Dictdata objectForKey:@"ID"];
                    if([idd isEqualToString:user1]){
                        strURl=[Dictdata objectForKey:@"image"];
                        break;
                    }
                }
            }
            // NSDictionary *dict=[chatSearchResult objectAtIndex:indexPath.row];
            AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 15,56,56)];
            banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
            banner.image=[UIImage imageNamed:@"DefualtImg.png"];
            if(strURl.length>10){
                strURl=[strURl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                banner.imageURL=[NSURL URLWithString:strURl];
            }
            banner.clipsToBounds=YES;
            [banner setContentMode:UIViewContentModeScaleAspectFill];
            banner.layer.cornerRadius=28;
            [cell.contentView addSubview:banner];
            
            
            UILabel *lblMessageCount=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, 36, 20, 20)];
            lblMessageCount.backgroundColor=[UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
            
            lblMessageCount.layer.cornerRadius=10;
            lblMessageCount.clipsToBounds=YES;
            
            lblMessageCount.numberOfLines=1;
            lblMessageCount.lineBreakMode=NSLineBreakByWordWrapping;
            lblMessageCount.font = [UIFont fontWithName:@"GothamBook" size:11];
            lblMessageCount.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            lblMessageCount.text=chatDialog.lastMessageText;//@"7/5 race cource ambal cantt,haryana";
            lblMessageCount.alpha=1;
            lblMessageCount.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lblMessageCount];
            
            
            BOOL hasUnreadMessages = chatDialog.unreadMessagesCount > 0;
            lblMessageCount.hidden = !hasUnreadMessages;
            if (hasUnreadMessages) {
                
                if (chatDialog.unreadMessagesCount > 99) {
                    lblMessageCount.text = @"99+";
                } else {
                    lblMessageCount.text =[NSString stringWithFormat:@"%lu", (unsigned long)chatDialog.unreadMessagesCount];
                }
                
            } else {
                lblMessageCount.text = @"";
            }
            
            UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, 160, 20)];
            lblName.backgroundColor=[UIColor clearColor];
            lblName.numberOfLines=1;
            lblName.lineBreakMode=NSLineBreakByWordWrapping;
            lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
            lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            // QBUUser *recipient = [[ServicesManager instance].usersService.usersMemoryStorage userWithID:chatDialog.recipientID];
            lblName.text=chatDialog.name;//recipient.login == nil ? (recipient.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)recipient.ID] : recipient.fullName) : recipient.login;//[dict objectForKey:@"name"];
            lblName.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblName];
            
            UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, self.view.frame.size.width-120, 20)];
            lblList.backgroundColor=[UIColor clearColor];
            lblList.numberOfLines=1;
            lblList.lineBreakMode=NSLineBreakByWordWrapping;
            lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
            lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            lblList.text=chatDialog.lastMessageText;//@"7/5 race cource ambal cantt,haryana";
            lblList.alpha=0.5;
            lblList.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblList];
            
        }
        
    }else if(self.tblArtical==tableView){
        if (indexPath.row==0) {
            UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, 40)];
            lblName.backgroundColor=[UIColor clearColor];
            lblName.numberOfLines=2;
            lblName.lineBreakMode=NSLineBreakByWordWrapping;
            //lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
            lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
            // lblName.text=[dictArticle objectForKey:@"title"];
            lblName.textAlignment = NSTextAlignmentLeft;
            
            
            NSString *labelText =[dictArticle objectForKey:@"title"];
            if(!(labelText)){
                labelText=@"";
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0] range:NSMakeRange(0, labelText.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"GothamMedium" size:15] range:NSMakeRange(0, labelText.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
            lblName.attributedText=attributedString;
            
            
            
            [cell.contentView addSubview:lblName];
            
            NSString *StrName=[NSString stringWithFormat:@"%@, %@",[dictArticle objectForKey:@"authorName"],[dictArticle objectForKey:@"added"]];
            UILabel *lblBy=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.view.frame.size.width-20, 20)];
            lblBy.backgroundColor=[UIColor clearColor];
            lblBy.numberOfLines=2;
            lblBy.lineBreakMode=NSLineBreakByWordWrapping;
            lblBy.font = [UIFont fontWithName:@"GothamBook" size:12];
            lblBy.textColor= [UIColor colorWithRed:149/255.0 green:147/255.0 blue:147/255.0 alpha:1.0];
            lblBy.text=StrName;
            lblBy.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:lblBy];
            
        }else  if (indexPath.row==1) {
            AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,self.view.frame.size.width-20 ,180)];
            banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
            banner.showActivityIndicator=YES;
            NSString *StrImage=[dictArticle objectForKey:@"articleImg"];
            if(!([StrImage isEqualToString:@""])){
                StrImage=[StrImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            }
            banner.imageURL=[NSURL URLWithString:StrImage];
            banner.clipsToBounds=YES;
            [banner setContentMode:UIViewContentModeScaleAspectFill];
            [cell.contentView addSubview:banner];
        }else {//149,147,147
            UITextView *txtDescripion=[[UITextView alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10 ,300)];
            txtDescripion.textColor=[UIColor colorWithRed:149/255.0 green:147/255.0 blue:147/255.0 alpha:1.0];
            txtDescripion.font=[UIFont fontWithName:@"GothamBook" size:14];
            txtDescripion.editable=NO;
            
            NSString *labelText =[dictArticle objectForKey:@"description"];
            if(!(labelText)){
                labelText=@"";
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:149/255.0 green:147/255.0 blue:147/255.0 alpha:1.0] range:NSMakeRange(0, labelText.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"GothamBook" size:14] range:NSMakeRange(0, labelText.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
            txtDescripion.attributedText=attributedString;
            [cell.contentView addSubview:txtDescripion];
        }
    }
    return cell;
}


-(void)cmdInvite:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[contactSearchResult objectAtIndex:btn.tag];
    NSString *pNum=[dict objectForKey:@"phone"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name= [[defaults objectForKey:@"UserName"]mutableCopy];
    NSMutableDictionary *dictData = [NSMutableDictionary new];
    [dictData setObject:pNum forKey:@"phone"];
    [dictData setObject:name forKey:@"name"];
    [self invite:dictData];
}
-(void)cmdCall:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict=[tblContactData objectAtIndex:btn.tag];
    NSString *pNum=[dict objectForKey:@"phone"];
    NSString *strNum=[NSString stringWithFormat:@"telprompt://%@",pNum];
    strNum=[strNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNum]];
}
-(void)cmdHost:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict1=[arrMergData objectAtIndex:btn.tag];
    NSDictionary *dict=[dict1 objectForKey:@"OurGroup"];
    VenuViewController* controller = [[VenuViewController alloc] initWithNibName:@"VenuViewController" bundle:nil];
    controller.kittyDate=[dict objectForKey:@"kittyDate"];
    controller.punctuality=[dict objectForKey:@"punctuality"];
    controller.punctualityTime=[dict objectForKey:@"punctualityTime"];
    controller.punctualityTime2=[dict objectForKey:@"punctualityTime2"];
    controller.kittyId=[dict objectForKey:@"kitty_id"];
    controller.kittytime=[dict objectForKey:@"kittyTime"];
    controller.venuSet=[dict objectForKey:@"is_venue"];
    controller.groupId=[dict objectForKey:@"groupID"];
    controller.name=[dict objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)cmdPermotionalListing:(id)sender{
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"special";
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)cmdDairy:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *dict1=[arrMergData objectAtIndex:btn.tag];
     NSDictionary *dict=[dict1 objectForKey:@"OurGroup"];
    DiaryViewController* controller = [[DiaryViewController alloc] initWithNibName:@"DiaryViewController" bundle:nil];
    controller.is_admin=[dict objectForKey:@"is_admin"];
    controller.is_host=[dict objectForKey:@"is_host"];
    controller.kittyNo=[dict objectForKey:@"kitty_id"];
    controller.groupID=[dict objectForKey:@"groupID"];
    controller.strCategory=[dict objectForKey:@"category"];
    controller.punctuality=[dict objectForKey:@"punctuality"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tblChats){
        if(indexPath.section==0){
            NSDictionary *dict1= [arrMergData objectAtIndex:indexPath.row];
            NSDictionary *dict=[dict1 objectForKey:@"OurGroup"];
            
            QBChatDialog *chatDialog=[dict1 objectForKey:@"Dialog"];
            
            if(dict){
                NSArray *host_id=[dict objectForKey:@"host_id"];
                NSString *strToHost=[dict objectForKey:@"is_host"];
                NewChatViewController* controller = [[NewChatViewController alloc] initWithNibName:@"NewChatViewController" bundle:nil];
                controller.dialog=chatDialog;
                controller.groupChat=@"1";
                controller.is_admin=[dict objectForKey:@"is_admin"];
                controller.groupId=[dict objectForKey:@"groupID"];
                controller.kittyId=[dict objectForKey:@"kitty_id"];
                controller.host_id=host_id;
                controller.strToHost=strToHost;
                controller.category=[dict objectForKey:@"category"];
                controller.set_rule=[dict objectForKey:@"set_rule"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                NSArray *imgArr=chatDialog.occupantIDs;
                NSString *user1=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:0]];
                NSString *user2=[NSString stringWithFormat:@"%@",[imgArr objectAtIndex:1]];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *userQuickId= [defaults objectForKey:@"quickID"];
                NSString *strURl;
                NSString *userid;
                NSString *name;
                if([user1 isEqualToString:userQuickId]){
                    for (int i=0; i<tblContactData.count; i++) {
                        NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                        NSString *idd=[Dictdata objectForKey:@"ID"];
                        if([idd isEqualToString:user2]){
                            strURl=[Dictdata objectForKey:@"image"];
                            break;
                        }
                    }
                }else if ([user2 isEqualToString:userQuickId]){
                    for (int i=0; i<tblContactData.count; i++) {
                        NSDictionary *Dictdata=[tblContactData objectAtIndex:i];
                        NSString *idd=[Dictdata objectForKey:@"ID"];
                        if([idd isEqualToString:user1]){
                            strURl=[Dictdata objectForKey:@"image"];
                            userid=[Dictdata objectForKey:@"userid"];
                            name=[Dictdata objectForKey:@"name"];
                            break;
                        }
                    }
                }
                NewChatViewController* controller = [[NewChatViewController alloc] initWithNibName:@"NewChatViewController" bundle:nil];
                controller.dialog=chatDialog;
                controller.groupChat=@"0";
                controller.chatImage=strURl;
                controller.userId=userid;
                controller.name=name;
                [self.navigationController pushViewController:controller animated:YES];
                
            }
        }
    }else if(tableView  == self.tblContacts){
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        
        if(!(status == NotReachable)){
            
            NSDictionary *dict=[contactSearchResult objectAtIndex:indexPath.row];
            NSString *registeration=[dict objectForKey:@"registeration"];
            if([registeration isEqualToString:@"1"]){
                QBUUser *user = [QBUUser new];
                user.ID=[[dict objectForKey:@"ID"]intValue];
                user.login=[dict objectForKey:@"login"];
                user.fullName=[dict objectForKey:@"full_name"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *UserName= [defaults objectForKey:@"UserName"];
                NSString *strChatName=[NSString stringWithFormat:@"%@%@",user.login,UserName];
                [self createChatWithName:strChatName user:user completion:^(QBChatDialog *dialog) {
                    NewChatViewController *controller = [[NewChatViewController alloc] initWithNibName:@"NewChatViewController" bundle:nil];
                    controller.dialog=dialog;
                    [self.navigationController pushViewController:controller animated:YES];
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView==self.tblChats){
        if(section==0)
            return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrBaner= [defaults objectForKey:@"banner"];
    NSString *strUrl;
    for (int i=0; i<arrBaner.count; i++) {
        
        NSDictionary *dict=[arrBaner objectAtIndex:i];
        NSString *title=[dict objectForKey:@"slug"];
        if(self.tblArtical==tableView){
            if([title isEqualToString:@"article"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
            
        }else if(self.tblContacts==tableView){
            if([title isEqualToString:@"contact"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
            
        }else if(self.tblChats==tableView){
            if([title isEqualToString:@"chat"]){
                strUrl=[dict objectForKey:@"thamb"];
            }
        }
    }
    strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    //UIImage *myImage = [UIImage imageNamed:@"banner.png"];
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    imageView.frame = CGRectMake(10,5,self.view.frame.size.width-20,40);
    imageView.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    imageView.showActivityIndicator=YES;
    imageView.clipsToBounds=YES;
    imageView.image=[UIImage imageNamed:@"banner.png"];
    imageView.imageURL=[NSURL URLWithString:strUrl];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [fotterView addSubview:imageView];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(adsClick:)];
    [fotterView addGestureRecognizer:singleFingerTap];
    
    return fotterView;
}

- (void)adsClick:(UITapGestureRecognizer *)recognizer {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrBaner= [defaults objectForKey:@"banner"];
    NSString *strUrl;
    NSString *strUrl2;
    NSString *strUrl3;
    for (int i=0; i<arrBaner.count; i++) {
        
        NSDictionary *dict=[arrBaner objectAtIndex:i];
        NSString *title=[dict objectForKey:@"slug"];
        
        if([title isEqualToString:@"article"]){
            strUrl=[dict objectForKey:@"url"];
        }
        
        if([title isEqualToString:@"contact"]){
            strUrl2=[dict objectForKey:@"url"];
        }
        
        
        if([title isEqualToString:@"chat"]){
            strUrl3=[dict objectForKey:@"url"];
        }
        
    }
    
    strUrl=[strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    strUrl2=[strUrl2 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    strUrl3=[strUrl3 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    CGFloat xOffset = self.ScrollView.contentOffset.x;
    if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }else if(xOffset<self.view.frame.size.width){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl2]];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl3]];
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView==self.tblContacts){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        if(!(searchBar)){
            searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            searchBar.delegate=self;
            searchBar.returnKeyType=UIReturnKeyDone;
            
            searchBar.showsScopeBar=YES;
            [searchBar setShowsCancelButton:NO];
            
            
        }
        CGFloat xOffset = self.ScrollView.contentOffset.x;
        if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
            searchBar.placeholder=@"Search Contacts";
        }else if(xOffset<self.view.frame.size.width){
            searchBar.placeholder=@"Search Chats";
        }
        [searchBar becomeFirstResponder];
        [headerView addSubview:searchBar];
        return headerView;
        
    }else if(tableView==self.tblChats){
        return nil;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(showContactSearch){
        if(self.tblContacts ==tableView)
            return 0;
    }
    if(tableView==self.tblChats){
        if(chatSearchResult.count>0){
            return 0;
        }else{
            return 0;
        }
        
    }
    
    return 0;// The height of the search bar
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

-(void)checkLayout{
    
    CGRect frame=self.tblChats.frame;
    frame.size.width=SCREEN_SIZE.width;
    self.tblChats.frame=frame;
    
    frame=self.tblContacts.frame;
    frame.size.width=SCREEN_SIZE.width;
    frame.origin.x=SCREEN_SIZE.width;
    self.tblContacts.frame=frame;
    
    frame=self.tblArtical.frame;
    frame.size.width=SCREEN_SIZE.width;
    frame.origin.x=SCREEN_SIZE.width*2;
    self.tblArtical.frame=frame;
    
    int buttonSize=SCREEN_SIZE.width/3;
    int diffSize=SCREEN_SIZE.width-buttonSize*3;
    int diffDiv=diffSize/2;
    
    frame=self.btnChat.frame;
    frame.size.width=buttonSize;
    self.btnChat.frame=frame;
    
    frame=self.btnContacts.frame;
    frame.size.width=buttonSize;
    frame.origin.x=buttonSize+diffDiv;
    self.btnContacts.frame=frame;
    
    frame=self.btnArtical.frame;
    frame.size.width=buttonSize;
    frame.origin.x=(buttonSize*2)+diffDiv;
    self.btnArtical.frame=frame;
    
    frame=SelectedTabanimation.frame;
    frame.size.width=SCREEN_SIZE.width/3;
    SelectedTabanimation.frame=frame;
}
-(void)addingAnimationToTable{
    
    // CGRect frame                                   = CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height);
    // self.ScrollView                                = [[UIScrollView alloc] initWithFrame:frame];
    self.ScrollView.backgroundColor                = [UIColor whiteColor];
    self.ScrollView.pagingEnabled                  = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator   = NO;
    self.ScrollView.delegate                       = self;
    self.ScrollView.bounces                        = NO;
    [self.ScrollView setContentInset:UIEdgeInsetsMake(0, 0, -80, 0)];
    
    float width                 = SCREEN_SIZE.width * 3;
    float height                = CGRectGetHeight(self.ScrollView.frame);
    self.ScrollView.contentSize = (CGSize){width, height};
    [self performSelector:@selector(checkLayout) withObject:nil afterDelay:0.0];
}
#pragma mark ---------- ScrollView delegate --------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // CGFloat xOffset = scrollView.contentOffset.x;
    if(scrollView== self.ScrollView){
        CGFloat percentage = (scrollView.contentOffset.x / scrollView.contentSize.width);
        CGRect frame = SelectedTabanimation.frame;
        frame.origin.x = (scrollView.contentOffset.x + percentage * SCREEN_SIZE.width)/4;
        SelectedTabanimation.frame = frame;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendNewIndex:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self sendNewIndex:scrollView];
}

-(void)sendNewIndex:(UIScrollView *)scrollView{
    
    
    showChatSearch=NO;
    
    [searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
    
    
    CGFloat xOffset = scrollView.contentOffset.x;
    if(scrollView== self.ScrollView){
        if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
            showContactSearch=NO;
            [self.view endEditing:YES];
            contactSearchResult=[tblContactData mutableCopy];
            SelectedTabanimation.frame=CGRectMake(SCREEN_SIZE.width/3, SelectedTabanimation.frame.origin.y, SCREEN_SIZE.width/3, SelectedTabanimation.frame.size.height);
            
        }else if(xOffset<self.view.frame.size.width){
            [self.tblContacts reloadData];
            chatSearchResult=[arryGroup mutableCopy];
            [self.tblChats reloadData];
            [self.tblContacts setContentOffset:CGPointZero animated:YES];
            SelectedTabanimation.frame=CGRectMake(0, SelectedTabanimation.frame.origin.y, SCREEN_SIZE.width/3, SelectedTabanimation.frame.size.height);
        }else{
            SelectedTabanimation.frame=CGRectMake((SCREEN_SIZE.width/3)*2, SelectedTabanimation.frame.origin.y, SCREEN_SIZE.width/3, SelectedTabanimation.frame.size.height);
            [self.tblContacts setContentOffset:CGPointZero animated:YES];
        }
    }
}

-(void)fadeAnimation:(UIButton *)btn{
    UIColor *SelectedtitleColor=[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.2;
    fadeTextAnimation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    [UIView transitionWithView:btn
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    [btn setTitleColor:SelectedtitleColor forState:UIControlStateNormal];
    
}
-(void)buttonColor{
    [self.btnChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContacts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnArtical setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)cmdChat:(id)sender {
    [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)cmdContact:(id)sender {
    [self.ScrollView setContentOffset:CGPointMake(SCREEN_SIZE.width, 0) animated:YES];
    
}

- (IBAction)cmdArticle:(id)sender {
    [self.ScrollView setContentOffset:CGPointMake(SCREEN_SIZE.width*2, 0) animated:YES];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tblChats];
    
    indexPathTblChat = [self.tblChats indexPathForRowAtPoint:p];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if(indexPathTblChat){
            if(indexPathTblChat.section==0){
                NSDictionary *dict= [chatSearchResult objectAtIndex:indexPathTblChat.row];
                NSString *is_admin=[dict objectForKey:@"is_admin"];
                if([is_admin isEqualToString:@"1"]){
                    NSString *groupId=[dict objectForKey:@"groupID"];
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:nil
                                                  delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Delete Group",@"Refresh Group", nil];
                    actionSheet.tag=[groupId integerValue];
                    [actionSheet showInView:self.view];
                }
                
            }
        }
        
        // NSLog(@"long press on table view at row %ld", indexPathTblChat.row);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        
        // [AlertView showAlertWithMessage:@"Kitty Haven't finished"];
        [self.view addSubview:ind];
        __block NSString *tag=[NSString stringWithFormat:@"%ld",(long)actionSheet.tag];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"1" forKey:@"delete"];
        
        [[ApiClient sharedInstance]deleteGroup:tag deleteYesOrNo:dict success:^(id responseObject) {
            NSDictionary *dict= [chatSearchResult objectAtIndex:indexPathTblChat.row];
            NSString *strQuickID=[dict objectForKey:@"quick_id"];
            
            NSDictionary *DataVal=responseObject;
            NSArray *ArryKittyId=[DataVal objectForKey:@"kittyList"];
            for (int i=0; i<ArryKittyId.count; i++) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"BILL%@%@",tag,[ArryKittyId objectAtIndex:i]]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@PERSONAL NOTES",tag,[ArryKittyId objectAtIndex:i]]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@KITTY NOTES",tag,[ArryKittyId objectAtIndex:i]]];
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:tag];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"GroupDiaries%@",tag]];
            
            [QBRequest deleteDialogsWithIDs:[NSSet setWithObject:strQuickID] forAllUsers:NO
                               successBlock:^(QBResponse *response, NSArray *deletedObjectsIDs, NSArray *notFoundObjectsIDs, NSArray *wrongPermissionsObjectsIDs) {
                                   [ind removeFromSuperview];
                                   [self getGroup];
                                   [AlertView showAlertWithMessage:@"Group Refreshed Successfully."];
                               } errorBlock:^(QBResponse *response) {
                                   [ind removeFromSuperview];
                                   [AlertView showAlertWithMessage:[response.error description]];
                               }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
        
    }else if(buttonIndex==1){
        [self.view addSubview:ind];
        __block NSString *tag=[NSString stringWithFormat:@"%ld",(long)actionSheet.tag];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"0" forKey:@"delete"];
        [[ApiClient sharedInstance]deleteGroup:tag deleteYesOrNo:dict success:^(id responseObject) {
            
            NSDictionary *DataVal=responseObject;
            NSArray *ArryKittyId=[DataVal objectForKey:@"kittyList"];
            for (int i=0; i<ArryKittyId.count; i++) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"BILL%@%@",tag,[ArryKittyId objectAtIndex:i]]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@PERSONAL NOTES",tag,[ArryKittyId objectAtIndex:i]]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@KITTY NOTES",tag,[ArryKittyId objectAtIndex:i]]];
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:tag];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"GroupDiaries%@",tag]];
            [ind removeFromSuperview];
            [self getGroup];
            [AlertView showAlertWithMessage:@"Group Refreshed Successfully."];
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
        
        
    }
}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!(buttonIndex==0)){
        MakeGroupViewController* controller = [[MakeGroupViewController alloc] initWithNibName:@"MakeGroupViewController" bundle:nil];
        if(buttonIndex==1){
            controller.kittyName=@"Couple Kitty";
            
        }else if(buttonIndex==2){
            controller.kittyName=@"Kitty with Kids";
        }else if(buttonIndex==3){
            controller.kittyName=@"Normal Kitty";
        }
        controller.dictContact=tblContactData;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark contactFetch

-(void)askPermissionContact{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [Alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getAllContacts];
    }
    else {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable Goto Setting >> KittyBee >> allow access to contact " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [Alert show];
        
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
}
- (void)getAllContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    NSMutableDictionary * details=[[NSMutableDictionary alloc]init];
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            //contacts.firstNames = [(__bridge NSString*)firstName copy];
            NSString *FirstName=[(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            //contacts.lastNames = [(__bridge NSString*)lastName copy];
            NSString *LastName=[(__bridge NSString*)lastName copy];
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!FirstName) {
                FirstName = @"";
            }
            
            if (!LastName) {
                LastName = @"";
            }
            
            
            
            //contacts.contactId = ABRecordGetRecordID(person);
            
            //append first name and last name
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", FirstName, LastName];
            
            // get contacts picture, if pic doesn't exists, show standart one
            //            CFDataRef imgData = ABPersonCopyImageData(person);
            //            NSData *imageData = (__bridge NSData *)imgData;
            //            contacts.image = [UIImage imageWithData:imageData];
            //
            //            if (imgData != NULL) {
            //                CFRelease(imgData);
            //            }
            //
            //            if (!contacts.image) {
            //                contacts.image = [UIImage imageNamed:@"avatar.png"];
            //            }
            
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            //            [details setObject:strFullName forKey:@"ContactName"];
            //            [details setObject:phoneNumbers forKey:@"phoneNumbers"];
            NSMutableArray *countryCode=[[NSMutableArray alloc]init];
            //NSMutableArray *MobNo=[[NSMutableArray alloc]init];
            for(int i=0; i<phoneNumbers.count; i++){
                
                NSString *strOrignalNumber=[phoneNumbers objectAtIndex:i];
                NSString *strRealNumber = [[strOrignalNumber componentsSeparatedByCharactersInSet:
                                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                           componentsJoinedByString:@""];
                if(strRealNumber.length<10){
                    continue;
                }
                NSString *strNumberwithOutCountryCOde = [strRealNumber substringFromIndex: [strRealNumber length] - 10];
                NSString *strContryCode=[strRealNumber stringByReplacingOccurrencesOfString:strNumberwithOutCountryCOde withString:@""];
                [countryCode addObject:strContryCode];
                [details setObject:strFullName forKey:strNumberwithOutCountryCOde];
                //[MobNo addObject:strNumberwithOutCountryCOde];
            }
            
            // [details setObject:countryCode forKey:@"CountryCode"];
            //[details setObject:MobNo forKey:@"ContactNumber"];
            
            //          //  get Contact email
            //                        NSMutableArray *contactEmails = [NSMutableArray new];
            //                        ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            //
            //                        for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
            //                            @autoreleasepool {
            //                                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
            //                                NSString *contactEmail = CFBridgingRelease(contactEmailRef);
            //                                if (contactEmail != nil)[contactEmails addObject:contactEmail];
            //                                // NSLog(@"All emails are:%@", contactEmails);
            //                            }
            //                        }
            //
            //                        if (multiPhones != NULL) {
            //                            CFRelease(multiEmails);
            //                        }
            //
            //                        [contacts setEmails:contactEmails];
            
            
            
#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);//phone
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone= [defaults objectForKey:@"phone"];
    [details setObject:phone forKey:@"number"];
    
    [items addObject:details];
    arryContact=items;
    [self.tblContacts reloadData];
    [self refreshContact];
    NSLog(@"%@",items);
}
#pragma mark search bar
-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    CGFloat xOffset = self.ScrollView.contentOffset.x;
    if ([text length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
        
        
        if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
            contactSearchResult=[tblContactData mutableCopy];
            showContactSearch=NO;
            [self.tblContacts reloadData];
            return;
        }else if(xOffset<self.view.frame.size.width){
            
            chatSearchResult=[arryGroup mutableCopy];
            showChatSearch=NO;
            [self.tblChats reloadData];
            return;
        }
        
    }
    
    if(xOffset>=self.view.frame.size.width && xOffset<(self.view.frame.size.width*2)){
        
        [contactSearchResult removeAllObjects];
        contactSearchResult=nil;
        contactSearchResult=[[NSMutableArray alloc]init];
        for (int i=0; i<tblContactData.count; i++) {
            
            NSDictionary *Dict=[tblContactData objectAtIndex:i];
            
            NSRange nameRange = [[Dict objectForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [[Dict objectForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            
            NSRange textrange=[searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRangetxt = [searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location == textrange.location || descriptionRangetxt.location == descriptionRange.location)
            {
                //NSInteger atIndex=[name indexOfObject:strMatchText];
                [contactSearchResult addObject:Dict];
                
            }
            
        }
        [self.tblContacts reloadData];
        
    }else if(xOffset<self.view.frame.size.width){
        [chatSearchResult  removeAllObjects];
        chatSearchResult=nil;
        chatSearchResult=[[NSMutableArray alloc]init];
        for (int i=0; i<arryGroup.count; i++) {
            
            NSDictionary *Dict=[arryGroup objectAtIndex:i];
            
            NSRange nameRange = [[Dict objectForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [[Dict objectForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            
            NSRange textrange=[searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRangetxt = [searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location == textrange.location || descriptionRangetxt.location == descriptionRange.location)
            {
                //NSInteger atIndex=[name indexOfObject:strMatchText];
                [chatSearchResult addObject:Dict];
            }
        }
        [self.tblChats reloadData];
        
    }
    // searchBar.enablesReturnKeyAutomatically = NO;
    
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 performSelector:@selector(resignFirstResponder)
                     withObject:nil
                     afterDelay:0];
    // Do the search...
}
#pragma  mark Api
-(void)getArticle{
    [self.view addSubview:ind];
    [[ApiClient sharedInstance] getArtical:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary  *dict =responseObject;
        dictArticle=[dict objectForKey:@"data"];
        [self.tblArtical reloadData];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dict objectForKey:@"data"] forKey:@"StoreContactArtical"];
        [defaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [self getArticalData];
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
}
-(void)getArticalData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict= [defaults objectForKey:@"StoreContactArtical"];
    dictArticle=dict;
    [self.tblArtical reloadData];
}

-(void)refreshContact{
    [self.view addSubview:ind];
    if(arryContact.count>0){
        NSDictionary *contact=[arryContact objectAtIndex:0];
        [[ApiClient sharedInstance]addContact:contact success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"StoreContactData"];
            [defaults synchronize];
            [self getcontact];
            NSLog(@"sorted array of dictionaries: %@", tblContactData);
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [self getcontact];
            [AlertView showAlertWithMessage:errorString];
        }];
    }else{
        [AlertView showAlertWithMessage:@"Please give permission to fetch contact."];
    }
}
-(void)getcontact{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"StoreContactData"];
    NSArray *dictData=dict;
    
    NSSortDescriptor *hopProfileName =
    [[NSSortDescriptor alloc] initWithKey:@"name"
                                ascending:YES];
    
    NSArray *descriptorsname = [NSArray arrayWithObjects:hopProfileName, nil];
    tblContactData = [dictData sortedArrayUsingDescriptors:descriptorsname];
    
    
    NSSortDescriptor *hopProfileDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"registeration"
                                ascending:NO];
    
    NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
    tblContactData = [tblContactData sortedArrayUsingDescriptors:descriptors];
    contactSearchResult=[tblContactData mutableCopy];
    [self.tblContacts reloadData];
    
}

-(void)invite:(NSDictionary *)dict{
    [[ApiClient sharedInstance] invite:dict success:^(id responseObject) {
        NSDictionary *Dictdata=responseObject;
        NSString *StrMessage=[Dictdata  objectForKey:@"message"];
        [AlertView showAlertWithMessage:StrMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [AlertView showAlertWithMessage:errorString];
    }];
}

-(void)getBanner{
    
    [[ApiClient sharedInstance]getBanner:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSArray *arrData=[dict objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:arrData forKey:@"banner"];
        [defaults synchronize];
        [self.tblChats reloadData];
        [self.tblContacts reloadData];
        [self.tblArtical    reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        
        
    }];
    
}

-(void)getGroup{
    NSDictionary *dict=[[NSDictionary alloc]init];
    [self.view addSubview:ind];
    
    [[ApiClient sharedInstance]getGroup:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dictResonse=responseObject;
        arryGroup=[dictResonse objectForKey:@"data"];
        
        if(!(arryGroup)){
            self.imgStartChat.hidden=NO;
        }else{
            self.imgStartChat.hidden=YES;
        }
        
        chatSearchResult=[[dictResonse objectForKey:@"data"] mutableCopy];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dictResonse objectForKey:@"data"] forKey:@"GroupCreated"];
        [defaults synchronize];
        [self.tblChats reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        if([errorString isEqualToString:@"No Data found!"]){
            self.imgStartChat.hidden=NO;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"GroupCreated"];
            [defaults synchronize];
            [self showGroup];
            
        }
        [AlertView showAlertWithMessage:errorString];
    }];
    
}

-(void)getGroupinBackground{
    NSDictionary *dict=[[NSDictionary alloc]init];
    [[ApiClient sharedInstance]getGroup:dict success:^(id responseObject) {
        NSDictionary *dictResonse=responseObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dictResonse objectForKey:@"data"] forKey:@"GroupCreated"];
        [defaults synchronize];
        [self showGroup];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        if([errorString isEqualToString:@"No Data found!"]){
            self.imgStartChat.hidden=NO;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"GroupCreated"];
            [defaults synchronize];
            [self showGroup];
        }
        [self showGroup];
    }];
}





-(void)showGroup{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"GroupCreated"];
    arryGroup=dict ;
    if(!(arryGroup)){
        self.imgStartChat.hidden=NO;
    }else{
        self.imgStartChat.hidden=YES;
    }
    chatSearchResult=[dict mutableCopy];
    [self.tblChats reloadData];
}

- (NSArray *)dialogs {
    // Retrieving dialogs sorted by updatedAt date from memory storage.
    //    NSArray *arryDataMsg=[ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
    //    [self.groupChat removeAllObjects];
    //    self.groupChat=nil;
    //    [self.OneToOneChat removeAllObjects];
    //    self.OneToOneChat=nil;
    //    self.groupChat=[[NSMutableArray alloc]init];
    //    self.OneToOneChat=[[NSMutableArray alloc]init];
    //    for (int i=0; i<arryDataMsg.count; i++) {
    //        QBChatDialog *chatDialog = self.dialogs[i];
    //        NSString *chatType=[NSString stringWithFormat:@"%lu",(unsigned long)chatDialog.type];
    //        if([chatType isEqualToString:@"2"]){
    //            [self.groupChat addObject:chatDialog];
    //        }else if([chatType isEqualToString:@"3"]){
    //            [self.OneToOneChat addObject:chatDialog];
    //        }
    //    }
    
    
    
    
   
    

//    NSArray *arry=[ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
//    arrMergData=[[NSMutableArray alloc]init];
//    if(arry.count>0){
//        
//        for (int i=0; i<arry.count; i++) {
//            QBChatDialog *chatDialog1 = arry[i];
//             NSMutableDictionary *dictMerge=[[NSMutableDictionary  alloc]init];
//             [dictMerge setObject:chatDialog1 forKey:@"Dialog"];
//            [arrMergData addObject:dictMerge];
//        }
//        for(int i=0;i<chatSearchResult.count;i++){
//            NSDictionary *dict= [chatSearchResult objectAtIndex:i];
//            NSString *strQuickID=[dict objectForKey:@"quick_id"];
//            for (int j=0; j<arry.count; j++) {
//                QBChatDialog *chatDialog1 = arry[j];
//                 NSString *StrId=chatDialog1.ID;
//                if([strQuickID isEqualToString:StrId]){
//                    NSMutableDictionary *dictMerge=[[NSMutableDictionary  alloc]init];
//                    [dictMerge setObject:dict forKey:@"OurGroup"];
//                    [dictMerge setObject:chatDialog1 forKey:@"Dialog"];
//                    [arrMergData replaceObjectAtIndex:j withObject:dictMerge];
//                    break;
//                }
//            }
//        }
//        
//        
//    }
//    return arrMergData;
    
    return [ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
}
-(void)showChatData:(NSArray *)chatData{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
    chatData = [chatData sortedArrayUsingDescriptors:@[sort]];
    
    
    NSArray *arry=self.dialogs;
    arrMergData=[[NSMutableArray alloc]init];
    
    if(arry.count>0){
        
        for (int i=0; i<arry.count; i++) {
            QBChatDialog *chatDialog1 = arry[i];
            NSMutableDictionary *dictMerge=[[NSMutableDictionary  alloc]init];
            [dictMerge setObject:chatDialog1 forKey:@"Dialog"];
            [arrMergData addObject:dictMerge];
        }
        for(int i=0;i<chatSearchResult.count;i++){
            NSDictionary *dict= [chatSearchResult objectAtIndex:i];
            NSString *strQuickID=[dict objectForKey:@"quick_id"];
            for (int j=0; j<arry.count; j++) {
                QBChatDialog *chatDialog1 = arry[j];
                NSString *StrId=chatDialog1.ID;
                if([strQuickID isEqualToString:StrId]){
                    NSMutableDictionary *dictMerge=[[NSMutableDictionary  alloc]init];
                    [dictMerge setObject:dict forKey:@"OurGroup"];
                    [dictMerge setObject:chatDialog1 forKey:@"Dialog"];
                    [arrMergData replaceObjectAtIndex:j withObject:dictMerge];
                    break;
                }
            }
        }
        
        
    }
   
  //  [self.tblChats reloadData];
}
#pragma mark check offline mode
-(void)CheckOfflineSync{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSMutableArray *arryOffline= [[defaults objectForKey:@"OffLinedataStored"]mutableCopy];
    __block NSMutableArray *arryOfflineName= [[defaults objectForKey:@"OffLinedataStoredName"] mutableCopy];
    if(arryOffline){
        for (int i=0; i<arryOffline.count; i++) {
            __block NSDictionary *dict1=[arryOffline objectAtIndex:i];
            __block NSString *StrDictName=[arryOfflineName objectAtIndex:i];
            NSDictionary *dict=[dict1 objectForKey:[arryOfflineName objectAtIndex:i]];
            [self.view addSubview:ind];
            ind.Loading.text=@"Syncing...";
            [[ApiClient sharedInstance]submitDiaries:dict success:^(id responseObject) {
                [ind removeFromSuperview];
                if(arryOffline.count==1){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OffLinedataStored"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OffLinedataStoredName"];
                }else{
                    [arryOffline removeObject:dict1];
                    [arryOfflineName removeObject:StrDictName];
                    NSArray *Arr=arryOffline;
                    NSArray *arrName=arryOfflineName;
                    [defaults setObject:arrName forKey:@"OffLinedataStoredName"];
                    [defaults setObject:Arr forKey:@"OffLinedataStored"];
                    [defaults synchronize];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:errorString];
            }];
        }
    }
}

-(void)checkOflineHostSync{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSMutableArray *host= [[defaults objectForKey:@"HOST"]mutableCopy];
    if(host){
        for (int i=0; i<host.count; i++) {
            __block NSDictionary *dict=[host objectAtIndex:i];
            NSString *stGroupId=[dict objectForKey:@"groupId"];
            [self.view addSubview:ind];
            ind.Loading.text=@"Syncing...";
            [[ApiClient sharedInstance]selectHost:stGroupId dict:dict success:^(id responseObject) {
                [ind removeFromSuperview];
                if(host.count==1){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HOST"];
                }else{
                    [host removeObject:dict];
                    NSArray *Arr=host;
                    [defaults setObject:Arr forKey:@"HOST"];
                    [defaults synchronize];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                [ind removeFromSuperview];
                [AlertView showAlertWithMessage:errorString];
            }];
        }
    }
}




- (void)loadDialogs {
    __weak __typeof(self) weakSelf = self;
    
    if ([ServicesManager instance].lastActivityDate != nil) {
        [[ServicesManager instance].chatService fetchDialogsUpdatedFromDate:[ServicesManager instance].lastActivityDate andPageLimit:kDialogsPageLimit iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            //
            [weakSelf.tblChats reloadData];
        } completionBlock:^(QBResponse *response) {
            //
            if ([ServicesManager instance].isAuthorized && response.success) {
                [ServicesManager instance].lastActivityDate = [NSDate date];
            }
        }];
    }
    else {
        
        [[ServicesManager instance].chatService allDialogsWithPageLimit:kDialogsPageLimit extendedRequest:nil iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            [weakSelf.tblChats reloadData];
        } completion:^(QBResponse *response) {
            if ([ServicesManager instance].isAuthorized) {
                if (response.success) {
                    
                    [ServicesManager instance].lastActivityDate = [NSDate date];
                }
                else {
                    NSLog(@"errore in loaddialog");
                    
                }
            }
        }];
    }
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
    [self showChatData:chatDialogs];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
    [self showChatData:nil];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
    [self showChatData:dialogs];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
     [self showChatData:nil];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
     [self showChatData:nil];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
     [self showChatData:nil];
    [self.tblChats reloadData];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
     [self showChatData:nil];
    [self.tblChats reloadData];
}

#pragma mark - QMChatConnectionDelegate

- (void)chatServiceChatDidConnect:(QMChatService *)chatService {
    // [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_CONNECTED", nil) maskType:SVProgressHUDMaskTypeClear];
    [self loadDialogs];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService {
    //  [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SA_STR_RECONNECTED", nil) maskType:SVProgressHUDMaskTypeClear];
    [self loadDialogs];
}

- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService *)chatService {
    // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_DISCONNECTED", nil)];
}

- (void)chatService:(QMChatService *)chatService chatDidNotConnectWithError:(NSError *)error {
    // [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_DID_NOT_CONNECT_ERROR", nil), [error localizedDescription]]];
}

- (void)chatServiceChatDidFailWithStreamError:(NSError *)error {
    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SA_STR_FAILED_TO_CONNECT_WITH_ERROR", nil), [error localizedDescription]]];
}




- (void)createChatWithName:(NSString *)name user:(QBUUser *)user completion:(void(^)(QBChatDialog *dialog))completion {
    NSMutableIndexSet *selectedUsersIndexSet = [NSMutableIndexSet indexSet];
    [self.tblChats.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath* obj, NSUInteger idx, BOOL *stop) {
        [selectedUsersIndexSet addIndex:obj.row];
    }];
    
    NSArray *selectedUsers = [NSArray arrayWithObjects:user, nil];//[self.dataSource.users objectsAtIndexes:selectedUsersIndexSet];
    
    if (selectedUsers.count == 1) {
        // Creating private chat dialog.
        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:selectedUsers.firstObject completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (!response.success && createdDialog == nil) {
                if (completion) {
                    completion(nil);
                }
            }
            else {
                if (completion) {
                    completion(createdDialog);
                }
            }
        }];
    } else if (selectedUsers.count > 1) {
        if (name == nil || [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            name = [NSString stringWithFormat:@"%@_", [QBSession currentSession].currentUser.login];
            for (QBUUser *user in selectedUsers) {
                name = [NSString stringWithFormat:@"%@%@,", name, user.login];
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
    } else {
        assert("no given users");
    }
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
