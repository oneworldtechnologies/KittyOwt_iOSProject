//
//  CalanderViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 04/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "CalanderViewController.h"
#import "CLWeeklyCalendarView.h"
@interface CalanderViewController ()<CLWeeklyCalendarViewDelegate>{
    NSArray *arrData;
    NSMutableArray *arryTable;
    IndecatorView *ind;

}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end
static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation CalanderViewController

- (void)viewDidLoad {
    [super viewDidLoad];//31,199,221
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"GothamMedium" size:14.0f],
      NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];

     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:31/255.0 green:199/255.0 blue:221/255.0 alpha:1.0];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.calendarView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"MY KITTY";
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dict= [defaults objectForKey:@"MyKitty"];
    if(dict){
        arrData=dict;
         [self showData];
        [self inBackGround];
    }else{
        [self getClanderApi];
    }
    
}
//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
                          CLCalendarDayTitleTextColor : [UIColor whiteColor],
                          CLCalendarSelectedDatePrintColor : [UIColor whiteColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    [arryTable removeAllObjects];
    for (int i=0; i<arrData.count; i++) {
        NSDictionary *Dict=[arrData objectAtIndex:i];
        NSString *dictDate=[Dict objectForKey:@"kitty_date"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *dateFromStrong=[dateFormatter dateFromString:dictDate];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents *date1Components = [calendar components:comps
                                                        fromDate: date];
        NSDateComponents *date2Components = [calendar components:comps
                                                        fromDate: dateFromStrong];
        
        date = [calendar dateFromComponents:date1Components];
        dateFromStrong = [calendar dateFromComponents:date2Components];
        
        
        
        if([date compare:dateFromStrong]==NSOrderedSame){
            if(!(arryTable)){
                arryTable=[[NSMutableArray alloc]init];
            }
            [arryTable addObject:Dict];
        }
    
    }
    if(arryTable.count>0){
        self.lblNoKitty.hidden=YES;
    }else{
        self.lblNoKitty.hidden=NO;
    }
    [self.tblDates reloadData];
}

#pragma mark CalanderApi
-(void)getClanderApi{
    
    [self.view addSubview:ind];
    
    
    [[ApiClient sharedInstance]getCalander:^(id responseObject) {
        [ind removeFromSuperview];
        NSLog(@"%@",responseObject);
        NSDictionary *dict=responseObject;
        arrData=[dict objectForKey:@"data"];
        for (int i=0; i<arrData.count; i++) {
            NSDictionary *Dict=[arrData objectAtIndex:i];
            
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:arrData forKey:@"MyKitty"];
            [defaults synchronize];
            
            
            NSString *dictDate=[Dict objectForKey:@"kitty_date"];
            NSDate *now = [NSDate date];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd-MMM-yyyy";
            NSDate *dateFromStrong=[dateFormatter dateFromString:dictDate];
            
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
            
            NSDateComponents *date1Components = [calendar components:comps
                                                            fromDate: now];
            NSDateComponents *date2Components = [calendar components:comps
                                                            fromDate: dateFromStrong];
            
            now = [calendar dateFromComponents:date1Components];
            dateFromStrong = [calendar dateFromComponents:date2Components];
            
            
            
            if([now compare:dateFromStrong]==NSOrderedSame){
                if(!(arryTable)){
                    arryTable=[[NSMutableArray alloc]init];
                }
                [arryTable addObject:Dict];
            }
        }
        [self.tblDates reloadData];
        if(arryTable.count>0){
            self.lblNoKitty.hidden=YES;
        }else{
             self.lblNoKitty.hidden=NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
        NSLog(@"%@",errorString);
    }];
}



-(void)inBackGround{
    
    [[ApiClient sharedInstance]getCalander:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict=responseObject;
        arrData=[dict objectForKey:@"data"];
        [self showData];
        
           } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [AlertView showAlertWithMessage:errorString];
        NSLog(@"%@",errorString);
    }];

}
-(void)showData{
    
    for (int i=0; i<arrData.count; i++) {
        NSDictionary *Dict=[arrData objectAtIndex:i];
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:arrData forKey:@"MyKitty"];
        [defaults synchronize];
        
        
        NSString *dictDate=[Dict objectForKey:@"kitty_date"];
        NSDate *now = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *dateFromStrong=[dateFormatter dateFromString:dictDate];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents *date1Components = [calendar components:comps
                                                        fromDate: now];
        NSDateComponents *date2Components = [calendar components:comps
                                                        fromDate: dateFromStrong];
        
        now = [calendar dateFromComponents:date1Components];
        dateFromStrong = [calendar dateFromComponents:date2Components];
        
        
        
        if([now compare:dateFromStrong]==NSOrderedSame){
            if(!(arryTable)){
                arryTable=[[NSMutableArray alloc]init];
            }
            [arryTable addObject:Dict];
        }
    }
    [self.tblDates reloadData];
    if(arryTable.count>0){
        self.lblNoKitty.hidden=YES;
    }else{
        self.lblNoKitty.hidden=NO;
    }

    
}

#pragma  mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 140;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arryTable.count;
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
        
    }//41,169,229
    NSDictionary *dict=[arryTable objectAtIndex:indexPath.row];
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_SIZE.width, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=1;
    lblName.lineBreakMode=NSLineBreakByTruncatingTail;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:20];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=[dict objectForKey:@"group_name"];
    lblName.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lblName];
    
    UILabel *lblOn=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_SIZE.width, 30)];
    lblOn.backgroundColor=[UIColor clearColor];
    lblOn.numberOfLines=1;
    lblOn.lineBreakMode=NSLineBreakByTruncatingTail;
    lblOn.font = [UIFont fontWithName:@"GothamMedium" size:18];
    lblOn.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblOn.text=@"On";
    lblOn.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lblOn];
    
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_SIZE.width, 20)];
    lblDate.backgroundColor=[UIColor clearColor];
    lblDate.numberOfLines=1;
    lblDate.lineBreakMode=NSLineBreakByTruncatingTail;
    lblDate.font = [UIFont fontWithName:@"GothamMedium" size:20];
    lblDate.textColor= [UIColor colorWithRed:41/255.0 green:169/255.0 blue:229/255.0 alpha:1.0];
    lblDate.text=[dict objectForKey:@"kitty_date"];;
    lblDate.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lblDate];
    
    UILabel *lblAt=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, SCREEN_SIZE.width, 30)];
    lblAt.backgroundColor=[UIColor clearColor];
    lblAt.numberOfLines=1;
    lblAt.lineBreakMode=NSLineBreakByTruncatingTail;
    lblAt.font = [UIFont fontWithName:@"GothamMedium" size:18];
    lblAt.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblAt.text=@"At";
    lblAt.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lblAt];
    
    UILabel *lblTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREEN_SIZE.width, 20)];
    lblTime.backgroundColor=[UIColor clearColor];
    lblTime.numberOfLines=1;
    lblTime.lineBreakMode=NSLineBreakByTruncatingTail;
    lblTime.font = [UIFont fontWithName:@"GothamMedium" size:20];
    lblTime.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblTime.text=[dict objectForKey:@"kitty_time"];
    lblTime.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lblTime];
    
    
    return cell;
    
}

@end
