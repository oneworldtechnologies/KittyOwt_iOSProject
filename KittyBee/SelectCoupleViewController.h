//
//  SelectCoupleViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCoupleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblSelectCouple;
@property (strong, nonatomic) NSMutableArray *arrMember;
@property (strong, nonatomic) NSMutableArray *arryCoupleSlelected;
@property (strong, nonatomic) NSString *strInMiddelKitty;
@property (strong, nonatomic) NSArray *totalMember;
@property(strong, nonatomic) NSString *noOfHost;
@property(strong, nonatomic) NSString *addMemeber;
@property (strong, nonatomic) NSMutableArray *totalADDMember;
@property(strong, nonatomic) NSString *groupId;
@property(strong, nonatomic) NSString *strMakingkitty;
@end
