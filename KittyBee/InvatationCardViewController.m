//
//  InvatationCardViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 29/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "InvatationCardViewController.h"

@interface InvatationCardViewController (){
    IndecatorView *ind;

}

@end

@implementation InvatationCardViewController

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
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.btnYes.layer.cornerRadius=15;
    self.btnNo.layer.cornerRadius=15;
    self.btnMaybe.layer.cornerRadius=15;
    [self getVanue];
}

-(void)getVanue{
    [self.view addSubview:ind];
   
    NSString *kitty=[self.dict objectForKey:@"kitty_id"];
    [[ApiClient sharedInstance] getVenue:kitty success:^(id responseObject) {
         [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        NSArray *arry=[dict objectForKey:@"data"];
        NSDictionary *respoDict=[arry objectAtIndex:0];
        
        NSString *strcontent=[NSString stringWithFormat:@"Date -    %@\nTime -  %@\nVenue - %@,%@",[respoDict objectForKey:@"kitty_date"],[respoDict objectForKey:@"venueTime"],[respoDict objectForKey:@"vanue"],[respoDict objectForKey:@"address"]];
        self.lblLabel.text=strcontent;
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
        
    }];
}



- (IBAction)cmdYes:(id)sender {
    NSDictionary *dataDict=self.dict;
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dataDict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"1" forKey:@"yes"];
    [DictData setObject:@"0" forKey:@"no"];
    [DictData setObject:@"0" forKey:@"maybe"];
    [DictData setObject:[dataDict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];
}

- (IBAction)cmdNo:(id)sender {
    NSDictionary *dataDict=self.dict;
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dataDict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"0" forKey:@"yes"];
    [DictData setObject:@"1" forKey:@"no"];
    [DictData setObject:@"0" forKey:@"maybe"];
    [DictData setObject:[dataDict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];
}

- (IBAction)cmdMaybe:(id)sender {
    
    NSDictionary *dataDict=self.dict;
    NSMutableDictionary *DictData=[[NSMutableDictionary alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    [DictData setObject:[dataDict objectForKey:@"group_id"] forKey:@"groupId"];
    [DictData setObject:@"0" forKey:@"yes"];
    [DictData setObject:@"0" forKey:@"no"];
    [DictData setObject:@"1" forKey:@"maybe"];
    [DictData setObject:[dataDict objectForKey:@"kitty_id"] forKey:@"kittyId"];
    [DictData setObject:USERID forKey:@"userId"];
    [self addAttandance:DictData];
    
}

-(void)addAttandance:(NSDictionary *)dict{
    
    [self.view addSubview:ind];
    [[ApiClient sharedInstance]addAttandance:dict success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        [AlertView showAlertWithMessage:[dict objectForKey:@"message"]];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
    }];
    
}



@end
