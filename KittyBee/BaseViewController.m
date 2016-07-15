//
//  BaseViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 31/03/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "BaseViewController.h"
#import "PermotionalListingViewController.h"
@interface BaseViewController (){
    CGSize keyboardSize;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"GothamMedium" size:14.0f],
      NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if ([self showBaseMenu])
    {
        [self createMenu];
    }
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Supper class methods

- (BOOL) showBaseMenu
{
    return YES;
}

#pragma mark create Full app menu for Permotional Listing
-(void)createMenu{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    float btnWidth=(screenWidth/5);
    float btnHeight=55;
    float btnYaxis=screenHeight-btnHeight-64;//239,239,241
    UIColor *color=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1.0];
    //Jewellery Button
    UIButton *bntJewellery=[[UIButton alloc] initWithFrame:CGRectMake(0, btnYaxis,btnWidth,btnHeight)];
    bntJewellery.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bntJewellery setImage:[UIImage imageNamed:@"jewellery"] forState:UIControlStateNormal];
    [bntJewellery setBackgroundColor:color];
    [bntJewellery addTarget:self action:@selector(cmdJewellery:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bntJewellery];
    //Restaurant
    UIButton *bntRestaurant=[[UIButton alloc] initWithFrame:CGRectMake(btnWidth*2, btnYaxis,btnWidth,btnHeight)];
     [bntRestaurant setImage:[UIImage imageNamed:@"restro"] forState:UIControlStateNormal];
    bntRestaurant.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bntRestaurant setBackgroundColor:color];
    [bntRestaurant addTarget:self action:@selector(cmdRestaurant:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bntRestaurant];
    // Parlour
    UIButton *bntParlour=[[UIButton alloc] initWithFrame:CGRectMake(btnWidth*3, btnYaxis,btnWidth,btnHeight)];
    bntParlour.imageView.contentMode = UIViewContentModeScaleAspectFit;
     [bntParlour setImage:[UIImage imageNamed:@"parlour"] forState:UIControlStateNormal];
    [bntParlour setBackgroundColor:color];
    [bntParlour addTarget:self action:@selector(cmdParlour:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bntParlour];
    // Boutique
    UIButton *bntBoutique=[[UIButton alloc] initWithFrame:CGRectMake(btnWidth*4, btnYaxis,btnWidth,btnHeight)];
    bntBoutique.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bntBoutique setImage:[UIImage imageNamed:@"boutique"] forState:UIControlStateNormal];
    [bntBoutique setBackgroundColor:color];
    [bntBoutique addTarget:self action:@selector(cmdBoutique:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bntBoutique];
    //Taxi
    UIButton *bntTaxi=[[UIButton alloc] initWithFrame:CGRectMake(btnWidth, btnYaxis,btnWidth,btnHeight)];
    bntTaxi.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bntTaxi setImage:[UIImage imageNamed:@"taxi"] forState:UIControlStateNormal];
    [bntTaxi setBackgroundColor:color];
    [bntTaxi addTarget:self action:@selector(cmdTaxi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bntTaxi];
}

-(void)cmdJewellery:(id)sender{//Jewellery Button
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"1";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdRestaurant:(id)sender{//My Restaurant
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"2";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdParlour:(id)sender{ // Parlour
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"3";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdBoutique:(id)sender{ // Boutique
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"4";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cmdTaxi:(id)sender{//Taxi
    PermotionalListingViewController* controller = [[PermotionalListingViewController alloc] initWithNibName:@"PermotionalListingViewController" bundle:nil];
    controller.pageNumber=@"5";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark keyboardWillShow

- (void)keyboardWillShow:(NSNotification*)notification{
     keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
}
-(CGSize)getKeyBoardSize{
    return keyboardSize;
}
@end
