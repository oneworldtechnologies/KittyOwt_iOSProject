//
//  ChatViewController.h
//  FoneFun
//
//  Created by OSX on 15/07/15.
//  Copyright (c) 2015 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"

#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"

@class ChatViewController;


@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(ChatViewController *)vc;


@end

@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) DemoModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSString *chatingID;
@property (strong, nonatomic) NSString *groupId;
@end

//@interface ChatViewController : UIViewController<>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//- (IBAction)Cmdsend:(id)sender;
//@property (weak, nonatomic) IBOutlet UIView *postview;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indcator;
//@property (weak, nonatomic) IBOutlet UIButton *btnsend;
//@property (weak, nonatomic) IBOutlet UITextField *txtmsg;

//@end