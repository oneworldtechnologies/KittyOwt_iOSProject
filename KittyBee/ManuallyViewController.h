//
//  ManuallyViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManuallyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblHostManually;
@property (strong,nonatomic)NSString *noOfHost;
@property (strong,nonatomic)NSArray *arryHostValue;
@property (strong,nonatomic)NSString *nextKittyDateValue;
@property (strong,nonatomic)NSString *groupId;
@property (strong,nonatomic)NSString *kitty_date;
@property (strong, nonatomic) IBOutlet UIView *popUp;
@property (strong,nonatomic)NSString *strCategory;
@property (strong,nonatomic)NSString *strKittyId;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cmdDone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblHostName;

@end
