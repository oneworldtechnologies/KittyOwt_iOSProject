//
//  MakeGroupViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 26/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeGroupViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)cmdgroupPic:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnGroupPic;

@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (weak, nonatomic) IBOutlet UIView *viewGroup;

@property (strong,nonatomic) NSString *kittyName;
@property (strong,nonatomic) NSArray *dictContact;
@end
