//
//  FMenuViewController.m
//  KittyApp
//
//
//  Copyright (c) 2016 Arun Kumar. All rights reserved.
//

#import "FMenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

#import "ContactUsViewController.h"
#import "HomeViewController.h"
#import "MyProfileViewController.h"
#import "NotificationViewController.h"
#import "MakeGroupViewController.h"
#import "PersonalNotesViewController.h"
#import "CalanderViewController.h"

@interface FMenuViewController (){
    NSArray *menuArry;
    NSArray *menuImgArry;
}

@end

@implementation FMenuViewController
@synthesize menuTbleVw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReloadTable)
                                                 name:@"ReloadMenuTable"
                                               object:nil];
}

-(void)ProfileEdited:(NSNotification *)notification
{
    [self.menuTbleVw reloadData];
}

-(void)ReloadTable{
    [menuTbleVw reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    menuImgArry=@[@"home@1x",@"profileMenu",@"notificationMenu",@"add_groupMenu",@"my_kittyMenu",@"personal_notesMenu",@"contact@1x"];
    menuArry=@[@"Home",@"Profile",@"Notification",@"Add Group",@"My Kitty",@"Personal Notes",@"Contact Us"];
    menuTbleVw.backgroundColor=[UIColor clearColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}




#pragma mark ----------------------------------- UITableViewDataSource --------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuArry.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier] ;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.row==0){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict= [defaults objectForKey:@"StoreProfileData"];
        NSString *strProfiePic;
        NSString *name;
        if(dict){
       strProfiePic=[dict objectForKey:@"profilePic"];
        strProfiePic=[strProfiePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            name=[dict objectForKey:@"name"];
        }else{
            strProfiePic=[defaults objectForKey:@"profilePic"];
            name=[defaults objectForKey:@"UserName"];
           
        }

        AsyncImageView *imgg=[[AsyncImageView alloc]initWithFrame:CGRectMake((self.menuTbleVw.frame.size.width/2)-60, 25, 120, 120)];
        imgg.showActivityIndicator=YES;
        imgg.activityIndicatorStyle=UIActivityIndicatorViewStyleWhite;
        imgg.imageURL=[NSURL URLWithString:strProfiePic];
        imgg.layer.cornerRadius=60;
        imgg.layer.borderWidth=10;
        imgg.clipsToBounds=YES;
        imgg.layer.borderColor=[UIColor colorWithRed:0/255.0 green:117/255.0 blue:132/255.0 alpha:1].CGColor;
        imgg.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imgg];
    
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake((self.menuTbleVw.frame.size.width/2)-100, 150, 200,20)];
        userName.font = [UIFont fontWithName:@"GothamMedium"size:14.0f];
        userName.text=name;
        userName.textAlignment=NSTextAlignmentCenter;
        userName.textColor=[UIColor whiteColor];
        [cell.contentView addSubview: userName];
        
        cell .backgroundColor=[UIColor colorWithRed:1/255.0 green:146/255.0 blue:165/255.0 alpha:1];
        return cell;
    }
    
    UIImageView *imgg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 16, 28, 28)];
    imgg.image=[UIImage imageNamed:[menuImgArry objectAtIndex:(indexPath.row-1)]];
    [cell.contentView addSubview:imgg];
   
    UILabel *menuTitle = [[UILabel alloc]initWithFrame:CGRectMake(55, 20, 150,20)];
    menuTitle.font = [UIFont fontWithName:@"GothamBook"size:12.0f];
    menuTitle.text=[menuArry objectAtIndex:(indexPath.row-1)];
    menuTitle.textColor=[UIColor whiteColor];
    [cell.contentView addSubview: menuTitle];
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 59, self.menuTbleVw.frame.size.width, 1)];
    backView.backgroundColor=[UIColor whiteColor];
    backView.alpha=0.3;
    [cell.contentView addSubview:backView];
    
    cell .backgroundColor=[UIColor colorWithRed:4/255.0 green:159/255.0 blue:179/255.0 alpha:1];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 170;
    }
    return 60;
}


#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"StoreContactData"];
    NSArray *dictData=dict;
    
    NSSortDescriptor *hopProfileName =
    [[NSSortDescriptor alloc] initWithKey:@"name"
                                ascending:YES];
    
    NSArray *descriptorsname = [NSArray arrayWithObjects:hopProfileName, nil];
    NSArray *arry = [dictData sortedArrayUsingDescriptors:descriptorsname];
    
    
    NSSortDescriptor *hopProfileDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"registeration"
                                ascending:NO];
    
    NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
    arry = [arry sortedArrayUsingDescriptors:descriptors];
    

    
    if(!(buttonIndex==0)){
        MakeGroupViewController* controller = [[MakeGroupViewController alloc] initWithNibName:@"MakeGroupViewController" bundle:nil];
        if(buttonIndex==1){
            controller.kittyName=@"Couple Kitty";
            
        }else if(buttonIndex==2){
            controller.kittyName=@"Kitty with Kids";
        }else if(buttonIndex==3){
            controller.kittyName=@"Normal Kitty";
        }
        controller.dictContact=arry;
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:controller];
        
        
    }
}

#pragma mark ------------------------------ UITableViewDelegate --------------------------------

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[MyProfileViewController alloc]init]];
    }else if(indexPath.row==1){
       
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
    }else if(indexPath.row==2){
        
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[MyProfileViewController alloc]init]];
    }else if(indexPath.row==3){
         self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[NotificationViewController alloc]init]];
    }else if(indexPath.row==4){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Couple Kitty",@"Kitty with Kids",@"Normal Kitty", nil];
        [alert show];
        
        
    }else if(indexPath.row==5){
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[CalanderViewController alloc]init]];
    }else if(indexPath.row==6){
        PersonalNotesViewController* controller = [[PersonalNotesViewController alloc] initWithNibName:@"PersonalNotesViewController" bundle:nil];
        controller.strFromMenu=@"FromMenu";
        controller.strPersonalNoteORKittyNotes=@"PERSONAL NOTES";
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:controller];
        
        //self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[PersonalNotesViewController alloc]init]];
    }else if(indexPath.row==7){
        self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[ContactUsViewController alloc]init]];
    }
    if(!(indexPath.row==1)){
        
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"removeProfileAndNotificationButton" object:self];
    }
}

#pragma mark ---------- Api Section ------------

@end
