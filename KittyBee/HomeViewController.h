//
//  HomeViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 01/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/QBASession.h>
#import "ServicesManager.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UISearchBarDelegate, UISearchDisplayDelegate,UIAlertViewDelegate,QMChatServiceDelegate,QMAuthServiceDelegate,QMChatConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblChats;
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (weak, nonatomic) IBOutlet UITableView *tblArtical;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnContacts;
@property (weak, nonatomic) IBOutlet UIButton *btnArtical;
- (IBAction)cmdChat:(id)sender;
- (IBAction)cmdContact:(id)sender;
- (IBAction)cmdArticle:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *SelectedTabanimation;
@property (weak, nonatomic) IBOutlet UIImageView *imgStartChat;


@property (nonatomic, strong) id <NSObject> observerDidBecomeActive;
@property (nonatomic, readonly) NSArray *dialogs;
@property (nonatomic, strong)NSMutableArray *groupChat;
@property (nonatomic, strong)NSMutableArray *OneToOneChat;
@end
