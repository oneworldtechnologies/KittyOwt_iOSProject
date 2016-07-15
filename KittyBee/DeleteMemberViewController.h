//
//  DeleteMemberViewController.h
//  KittyBee
//
//  Created by Arun on 13/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteMemberViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblDeleteMember;
@property (strong, nonatomic)NSArray *arryMemberList;
@end
