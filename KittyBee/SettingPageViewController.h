//
//  SettingPageViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 22/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPStackMenu.h"

@interface SettingPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UPStackMenuDelegate>
@property (weak, nonatomic) IBOutlet AsyncImageView *imgGroup;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *is_admin;
@property (weak, nonatomic) IBOutlet UITableView *tblSetting;
@property (strong, nonatomic) NSString *strToHost;
@property (strong, nonatomic) NSArray *host_id;
@property (strong, nonatomic) NSString *kittyId;

@end
