//
//  kidsViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kidsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblKids;
@property (strong, nonatomic) NSArray *arrMember;
@property (strong, nonatomic) NSMutableArray *arryKidsValue;
@property (strong, nonatomic) NSString *addMember;
@property (strong, nonatomic) NSString *groupId;
@end
