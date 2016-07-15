//
//  NewMembersViewController.h
//  KittyBee
//
//  Created by Arun on 05/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMembersViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblNewMember;
@property (strong, nonatomic) NSString *groupId;

@end
