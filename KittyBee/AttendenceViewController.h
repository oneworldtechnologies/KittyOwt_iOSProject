//
//  AttendenceViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 27/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendenceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblAttendence;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *kittyId;

@end
