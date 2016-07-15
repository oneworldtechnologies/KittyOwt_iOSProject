//
//  NewChatViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 24/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMChatViewController.h"

@interface NewChatViewController : QMChatViewController

@property (nonatomic, strong) QBChatDialog *dialog;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSArray *arryImage;
@property (strong, nonatomic) NSString *groupChat;
@property (strong, nonatomic) NSString *chatImage;
@property (strong, nonatomic) NSString *kittyId;
@property (strong, nonatomic) NSString *is_admin;
@property (strong, nonatomic) NSString *strToHost;
@property (strong, nonatomic) NSArray *host_id;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *set_rule;
@property (strong,nonatomic) NSString *category;
@end
