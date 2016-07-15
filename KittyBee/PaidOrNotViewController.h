//
//  PaidOrNotViewController.h
//  KittyBee
//
//  Created by Arun on 07/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaidOrNotViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblPaid;
@property (strong,nonatomic) NSArray *arryGroupMember;
@property (strong, nonatomic) NSString *groupId;
@property(strong,nonatomic) NSString *catagory;
@property (strong,nonatomic) NSArray *unpairedMember;

@end
