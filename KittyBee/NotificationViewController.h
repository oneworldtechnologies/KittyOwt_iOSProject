//
//  NotificationViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 25/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblNotification;

@end
