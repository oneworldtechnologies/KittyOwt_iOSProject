//
//  DiaryViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPStackMenu.h"

@interface DiaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UPStackMenuDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblDiary;
@property (strong, nonatomic) NSString *is_admin;
@property (strong, nonatomic) NSString *is_host;
@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) NSString *kittyNo;
@property (strong, nonatomic)NSString *punctuality;
@property (strong, nonatomic)NSString *strCategory;
@end
