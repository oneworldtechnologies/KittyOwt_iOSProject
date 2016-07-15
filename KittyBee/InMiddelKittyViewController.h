//
//  InMiddelKittyViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 27/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InMiddelKittyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblHost;
@property (strong,nonatomic) NSArray *arryGroupMember;
@property (strong,nonatomic) UIImage *imgGroup;
@property (strong,nonatomic) NSString *strGroupName;
@property (strong,nonatomic) NSString *strKittyType;
@end
