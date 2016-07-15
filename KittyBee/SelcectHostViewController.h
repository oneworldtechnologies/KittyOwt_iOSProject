//
//  SelcectHostViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelcectHostViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblSelectHost;
@property (strong,nonatomic)NSString *groupId;
@property (strong,nonatomic)NSString *noOfHost;
@property (strong,nonatomic)NSString *kitty_date;
@property (strong,nonatomic)NSString *summery;
@property (strong,nonatomic)NSString *strCategory;
@property (strong,nonatomic)NSString *strKittyId;
@property (strong, nonatomic) IBOutlet UIView *popUp;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cmdDone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblHostName;

@end
