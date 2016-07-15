//
//  NewChatViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 24/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "NewChatViewController.h"
#import "MessageStatusStringBuilder.h"
#import "ServicesManager.h"

#import "UIImage+fixOrientation.h"
#import "TTTAttributedLabel.h"
#import "QMMessageNotificationManager.h"

#import "NSString+EMOEmoji.h"
#include "SettingPageViewController.h"
#include "AttendenceViewController.h"

#include "MyProfileViewController.h"
#include "KittyRulesViewController.h"
static const NSUInteger widthPadding = 40.0f;

static const NSUInteger maxCharactersNumber = 1024; // 0 - unlimited

@interface NewChatViewController ()<QMChatServiceDelegate,
UITextViewDelegate,
QMChatConnectionDelegate,
QMChatAttachmentServiceDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
QMChatCellDelegate
>{
    NSData *data;
    NSData *dataimage;
    IndecatorView *indGetinListMember;

}


@property (nonatomic, weak) QBUUser *opponentUser;
@property (nonatomic, strong) MessageStatusStringBuilder *stringBuilder;
@property (nonatomic, strong) NSMapTable *attachmentCells;
@property (nonatomic, readonly) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSTimer *typingTimer;
@property (nonatomic, strong) id observerWillResignActive;



@property (nonatomic, strong) NSArray QB_GENERIC(QBChatMessage *) *unreadMessages;

@property (nonatomic, strong) NSMutableSet *detailedCells;



@end

@implementation NewChatViewController
@synthesize pickerController = _pickerController;



- (UIImagePickerController *)pickerController {
    if (_pickerController == nil) {
        _pickerController = [UIImagePickerController new];
        _pickerController.delegate = self;
    }
    return _pickerController;
}

#pragma mark - Override

- (NSUInteger)senderID {
    return [QBSession currentSession].currentUser.ID;
}

- (NSString *)senderDisplayName {
    return [QBSession currentSession].currentUser.fullName;
}

- (CGFloat)heightForSectionHeader {
    return 40.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    indGetinListMember=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    indGetinListMember.Loading.text=@"Geting Members...";
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *profilePic = [prefs stringForKey:@"profilePic"];
        
        profilePic=[profilePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:profilePic];
    data = [NSData dataWithContentsOfURL:url];
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
    if([self.groupChat isEqualToString:@"0"]){
        if(self.chatImage.length>10){
             self.chatImage=[self.chatImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
           dataimage= [NSData dataWithContentsOfURL:[NSURL URLWithString:self.chatImage]];
        }else{
            dataimage=UIImagePNGRepresentation([UIImage imageNamed:@"DefualtImg.png"]);
        }
    }
   // dataimage
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.inputToolbar.contentView.backgroundColor = [UIColor whiteColor];
    self.inputToolbar.contentView.textView.placeHolder = NSLocalizedString(@"Enter Message Here...", nil);
   // autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputToolbar.contentView.textView.autocorrectionType=UITextAutocorrectionTypeNo;
    self.attachmentCells = [NSMapTable strongToWeakObjectsMapTable];
    self.stringBuilder = [MessageStatusStringBuilder new];
    self.detailedCells = [NSMutableSet set];
    
    [self updateTitle];
    
    if (self.dialog.type == QBChatDialogTypePrivate) {
        
        // Handling 'typing' status.
        __weak typeof(self)weakSelf = self;
        [self.dialog setOnUserIsTyping:^(NSUInteger userID) {
            
            __typeof(weakSelf)strongSelf = weakSelf;
            if ([QBSession currentSession].currentUser.ID == userID) {
                return;
            }
            strongSelf.title = NSLocalizedString(@"SA_STR_TYPING", nil);
        }];
        
        // Handling user stopped typing.
        [self.dialog setOnUserStoppedTyping:^(NSUInteger userID) {
            
            __typeof(weakSelf)strongSelf = weakSelf;
            if ([QBSession currentSession].currentUser.ID == userID) {
                return;
            }
            [strongSelf updateTitle];
        }];
    }
    
    [[ServicesManager instance].chatService addDelegate:self];
    [ServicesManager instance].chatService.chatAttachmentService.delegate = self;
    
    if ([[self storedMessages] count] > 0 && self.chatSectionManager.totalMessagesCount == 0) {
        // inserting all messages from memory storage
        [self.chatSectionManager addMessages:[self storedMessages]];
    }
    
    [self refreshMessagesShowingProgress:NO];
    if(self.groupId){
        NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
        UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSetting.frame = CGRectMake(0, 0, 32, 32);
        [btnSetting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [btnSetting addTarget:self action:@selector(cmdSetting:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
        [arrRightBarItems addObject:btnGroupBar];
        if([self.set_rule isEqualToString:@"1"]){
            UIButton *btnAttandance = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnAttandance setImage:[UIImage imageNamed:@"note@1x"] forState:UIControlStateNormal];
            btnAttandance.frame = CGRectMake(0, 0, 32, 32);
            
            [btnAttandance addTarget:self action:@selector(cmdAttandance:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnAttandance];
            [arrRightBarItems addObject:btnSearchBar];
            self.navigationItem.rightBarButtonItems=arrRightBarItems;
        }else{
            if([self.is_admin isEqualToString:@"1"]){
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                [reachability startNotifier];
                
                NetworkStatus status = [reachability currentReachabilityStatus];
                if(!(status == NotReachable)){
                    UIButton *btnAttandance = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnAttandance setImage:[UIImage imageNamed:@"note@1x"] forState:UIControlStateNormal];
                    btnAttandance.frame = CGRectMake(0, 0, 32, 32);
                    
                    [btnAttandance addTarget:self action:@selector(cmdAddKittyToGroup:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnAttandance];
                    [arrRightBarItems addObject:btnSearchBar];
                    self.navigationItem.rightBarButtonItems=arrRightBarItems;
                }else{
                    [AlertView showAlertWithMessage:@"Not connected to internet."];
                }
            }
        }
    }else{
        NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
        UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSetting.frame = CGRectMake(0, 0, 32, 32);
        [btnSetting setImage:[UIImage imageNamed:@"DefualtImg.png"] forState:UIControlStateNormal];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL *url = [NSURL URLWithString:self.chatImage];
            NSData *dataa = [NSData dataWithContentsOfURL:url];
            dispatch_async( dispatch_get_main_queue(), ^{
                [btnSetting setImage:[[UIImage alloc] initWithData:dataa] forState:UIControlStateNormal];
            });
        });
        [btnSetting addTarget:self action:@selector(cmdSetting:) forControlEvents:UIControlEventTouchUpInside];
        
        btnSetting.layer.cornerRadius=16;
        btnSetting.clipsToBounds=YES;
        UIBarButtonItem *btnGroupBar = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
        [arrRightBarItems addObject:btnGroupBar];
        self.navigationItem.rightBarButtonItems=arrRightBarItems;
    }
}

//cmdAddKittyToGroup
-(void)cmdAddKittyToGroup:(id)sender{
    
    [self.view addSubview:indGetinListMember];
    [[ApiClient sharedInstance]getNonKittyMember:self.groupId success:^(id responseObject) {
        [indGetinListMember removeFromSuperview];
        NSDictionary *dict=responseObject;
        NSMutableArray *arry=[[dict objectForKey:@"data"] mutableCopy];
        KittyRulesViewController* controller = [[KittyRulesViewController alloc] initWithNibName:@"KittyRulesViewController" bundle:nil];
        controller.arryGroupMember=arry;
        controller.strInMiddelKitty=@"No";
        controller.strKittyType=self.category;
        controller.strMakingkitty=@"yes";
        controller.groupId=self.groupId;
        [self.navigationController pushViewController:controller animated:YES];
     
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [indGetinListMember removeFromSuperview];
    }];
    
}
-(void)cmdSetting:(id)sender{
    
    if(self.groupId){
        SettingPageViewController* controller = [[SettingPageViewController alloc] initWithNibName:@"SettingPageViewController" bundle:nil];
        controller.groupId=self.groupId;
        controller.is_admin=self.is_admin;
        controller.host_id=self.host_id;
        controller.strToHost=self.strToHost;
        controller.kittyId=self.kittyId;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        MyProfileViewController* controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        controller.strOtherPersonProfile=self.userId;
        controller.strOtherPersonName=self.name;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
   
}

-(void)cmdAttandance:(id)sender{
    AttendenceViewController* controller = [[AttendenceViewController alloc] initWithNibName:@"AttendenceViewController" bundle:nil];
    controller.groupId=self.groupId;
    controller.kittyId=self.kittyId;
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshMessagesShowingProgress:(BOOL)showingProgress {
    
    if (showingProgress) {
        //[SVProgressHUD showWithStatus:NSLocalizedString(@"SA_STR_LOADING_MESSAGES", nil) maskType:SVProgressHUDMaskTypeClear];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    // Retrieving messages from Quickblox REST history and cache.
    [[ServicesManager instance].chatService messagesWithChatDialogID:self.dialog.ID completion:^(QBResponse *response, NSArray *messages) {
        if (response.success) {
            
            if ([messages count] > 0) {
                [weakSelf.chatSectionManager addMessages:messages];
            }
           // [SVProgressHUD dismiss];
            
        } else {
           // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SA_STR_ERROR", nil)];
            NSLog(@"can not refresh messages: %@", response.error.error);
        }
    }];
}

- (NSArray *)storedMessages {
    return [[ServicesManager instance].chatService.messagesMemoryStorage messagesWithDialogID:self.dialog.ID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Saving currently opened dialog.
    [ServicesManager instance].currentDialogID = self.dialog.ID;
    
    __weak __typeof(self)weakSelf = self;
    self.observerWillResignActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                                                      object:nil
                                                                                       queue:nil
                                                                                  usingBlock:^(NSNotification *note) {
                                                                                      [weakSelf fireStopTypingIfNecessary];
                                                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerWillResignActive];
    
    // Deletes typing blocks.
    [self.dialog clearTypingStatusBlocks];
    
    // Resetting currently opened dialog.
    [ServicesManager instance].currentDialogID = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"kShowDialogInfoViewController"]) {
//        DialogInfoTableViewController *viewController = segue.destinationViewController;
//        viewController.dialog = self.dialog;
//    }
}

- (void)updateTitle {
    
    if (self.dialog.type == QBChatDialogTypePrivate) {
        
        NSMutableArray *mutableOccupants = [self.dialog.occupantIDs mutableCopy];
        [mutableOccupants removeObject:@([self senderID])];
        NSNumber *opponentID = [mutableOccupants firstObject];
        //
      
        
        [QBRequest userWithID:[opponentID integerValue]successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
            NSLog(@"Users %@",user);
            self.title=user.fullName;
            NSUInteger userProfilePictureID = user.blobID;
       // [QBRequest downloadFileWithUID:userProfilePictureID successBlock:nil statusBlock:nil errorBlock:nil];
           [QBRequest downloadFileWithID:userProfilePictureID successBlock:^(QBResponse * _Nonnull response, NSData * _Nonnull fileData) {
               //dataimage   =fileData;
           } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
               
           } errorBlock:^(QBResponse * _Nonnull response) {
               NSLog(@"eerror find in Image %@",[response.error description]);
           }];
           
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSString *str=[response.error description];
            NSLog(@"Users name error %@",str);
        }];
//        QBUUser *opponentUser = [[ServicesManager instance].usersService.usersMemoryStorage userWithID:[opponentID unsignedIntegerValue]];
//        if (!opponentUser) {
//            self.title = [opponentID stringValue];
//            return;
//        }
//        self.opponentUser = opponentUser;
//        self.title = self.opponentUser.fullName;
    }
    else {
        
        self.title = self.dialog.name;
    }
}

#pragma mark - Utilities

- (void)sendReadStatusForMessage:(QBChatMessage *)message {
    
    if (message.senderID != self.senderID && ![message.readIDs containsObject:@(self.senderID)]) {
        [[ServicesManager instance].chatService readMessage:message completion:^(NSError *error) {
            
            if (error != nil) {
                NSLog(@"Problems while marking message as read! Error: %@", error);
                return;
            }
            if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
                [UIApplication sharedApplication].applicationIconBadgeNumber--;
            }
        }];
    }
}

- (void)readMessages:(NSArray *)messages {
    
    if ([ServicesManager instance].isAuthorized) {
        
        [[ServicesManager instance].chatService readMessages:messages forDialogID:self.dialog.ID completion:nil];
    }
    else {
        
        self.unreadMessages = messages;
    }
}

- (void)fireStopTypingIfNecessary {
    
    [self.typingTimer invalidate];
    self.typingTimer = nil;
    [self.dialog sendUserStoppedTyping];
}

#pragma mark Tool bar Actions

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    BOOL shouldJoin = (self.dialog.type == QBChatDialogTypeGroup ? !self.dialog.isJoined : NO);
    
    if (![[QBChat instance] isConnected] || shouldJoin) {
        return;
    }
    
    if (self.typingTimer != nil) {
        [self fireStopTypingIfNecessary];
    }
    
    QBChatMessage *message = [QBChatMessage message];
    message.text = text;
    message.senderID = senderId;
    message.markable = YES;
    message.deliveredIDs = @[@(self.senderID)];
    message.readIDs = @[@(self.senderID)];
    message.dialogID = self.dialog.ID;
    message.dateSent = date;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *UserName= [prefs stringForKey:@"UserName"];
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    [dictdata setObject:UserName forKey:@"username"];
    message.customParameters=dictdata;
    
    // Sending message.
    [[ServicesManager instance].chatService sendMessage:message toDialogID:self.dialog.ID saveToHistory:YES saveToStorage:YES completion:^(NSError *error) {
        
        if (error != nil) {
            
            NSLog(@"Failed to send message with error: %@", error);
            NSString * title  = NSLocalizedString(@"SA_STR_ERROR", nil);
            NSString * subtitle = error.localizedDescription;
            UIImage *iconImage = [UIImage imageNamed:@"icon-error"];
            UIColor *backgroundColor = [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0];
            
            [QMMessageNotificationManager showNotificationWithTitle:title
                                                           subtitle:subtitle
                                                              color:backgroundColor
                                                          iconImage:iconImage];
        }
    }];
    
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - Cell classes

- (Class)viewClassForItem:(QBChatMessage *)item {
    if (item.isNotificatonMessage) {
        
        return [QMChatNotificationCell class];
    }
    
    if (item.senderID != self.senderID) {
        if (item.isMediaMessage && item.attachmentStatus != QMMessageAttachmentStatusError) {
            return [QMChatAttachmentIncomingCell class];
        }
        else {
            return [QMChatIncomingCell class];
        }
    }
    else {
        if (item.isMediaMessage && item.attachmentStatus != QMMessageAttachmentStatusError) {
            return [QMChatAttachmentOutgoingCell class];
        }
        else {
            return [QMChatOutgoingCell class];
        }
    }
}

#pragma mark - Strings builder

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor;
    
    if (messageItem.isNotificatonMessage) {
        textColor =  [UIColor blackColor];
    }
    else {
        textColor = [messageItem senderID] == self.senderID ? [UIColor whiteColor] : [UIColor blackColor];
    }
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f] ;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor, NSFontAttributeName:font};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:messageItem.text ? messageItem.text : @"" attributes:attributes];
    
    return attrStr;
}

- (NSAttributedString *)topLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    
    if ([messageItem senderID] == self.senderID || self.dialog.type == QBChatDialogTypePrivate) {
        return nil;
    }
    
  __block  NSString *topLabelText = self.opponentUser.fullName != nil ? self.opponentUser.fullName : self.opponentUser.login;
    
    if (self.dialog.type != QBChatDialogTypePrivate) {
        QBUUser *messageSender = [[ServicesManager instance].usersService.usersMemoryStorage userWithID:messageItem.senderID];
        
        if (messageSender) {
            
            topLabelText = messageSender.fullName;
        }
        else {
           NSDictionary *Dict=messageItem.customParameters;
            if(Dict){
                NSString *strName=[Dict objectForKey:@"username"];
                if(strName){
                    topLabelText = [Dict objectForKey:@"username"];
                   // messageSender.blobID
                  
                }else{
                    topLabelText = [NSString stringWithFormat:@"%lu",(unsigned long)messageItem.senderID];
                }
            }else{
                topLabelText = [NSString stringWithFormat:@"%lu",(unsigned long)messageItem.senderID];
            }
        
            
        }
    }
    
    // setting the paragraph style lineBreakMode to NSLineBreakByTruncatingTail in order to TTTAttributedLabel cut the line in a correct way
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:122.0f / 255.0f blue:1.0f alpha:1.000],
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:topLabelText attributes:attributes];
    
    return attrStr;
}

- (NSAttributedString *)bottomLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor = [messageItem senderID] == self.senderID ? [UIColor colorWithWhite:1 alpha:0.7f] : [UIColor colorWithWhite:0.000 alpha:0.7f];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor,
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName: paragraphStyle};
    
    NSString *text = messageItem.dateSent ? [self timeStampWithDate:messageItem.dateSent] : @"";
    if ([messageItem senderID] == self.senderID) {
       // text = [NSString stringWithFormat:@"%@\n%@", text, [self.stringBuilder statusFromMessage:messageItem]];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text
                                                                                attributes:attributes];
    
    return attrStr;
}

#pragma mark - Collection View Datasource

- (CGSize)collectionView:(QMChatCollectionView *)collectionView dynamicSizeAtIndexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class viewClass = [self viewClassForItem:item];
    CGSize size = CGSizeZero;
    
    if (viewClass == [QMChatAttachmentIncomingCell class]) {
        
        size = CGSizeMake(MIN(200, maxWidth), 200);
        
    }
    else if (viewClass == [QMChatAttachmentOutgoingCell class]) {
        
        NSAttributedString *attributedString = [self bottomLabelAttributedStringForItem:item];
        
        CGSize bottomLabelSize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                                  withConstraints:CGSizeMake(MIN(200, maxWidth), CGFLOAT_MAX)
                                                           limitedToNumberOfLines:0];
        size = CGSizeMake(MIN(200, maxWidth), 200 + ceilf(bottomLabelSize.height));
        
    }
    else if (viewClass == [QMChatNotificationCell class]) {
        
        NSAttributedString *attributedString = [self attributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    else {
        
        NSAttributedString *attributedString = [self attributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    
    return size;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView minWidthAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    
    CGSize size = CGSizeZero;
    if ([self.detailedCells containsObject:item.ID]) {
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:[self bottomLabelAttributedStringForItem:item]
                                                withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    
    if (self.dialog.type != QBChatDialogTypePrivate) {
        
        CGSize topLabelSize = [TTTAttributedLabel sizeThatFitsAttributedString:[self topLabelAttributedStringForItem:item]
                                                               withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                                        limitedToNumberOfLines:0];
        
        if (topLabelSize.width > size.width) {
            size = topLabelSize;
        }
    }
    
    return size.width;
}

/**
 * Allows to perform copy action for QMChatIncomingCell and QMChatOutgoingCell
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class viewClass = [self viewClassForItem:item];
    
    if (viewClass == [QMChatAttachmentIncomingCell class]
        || viewClass == [QMChatAttachmentOutgoingCell class]
        || viewClass == [QMChatNotificationCell class]
        || viewClass == [QMChatContactRequestCell class]){
        
        return NO;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

/**
 * Allows to perform copy action for QMChatIncomingCell and QMChatOutgoingCell
 */
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    Class viewClass = [self viewClassForItem:message];
    
    if (viewClass == [QMChatAttachmentIncomingCell class] || viewClass == [QMChatAttachmentOutgoingCell class]) return;
    [UIPasteboard generalPasteboard].string = message.text;
}

#pragma mark - Utility

- (NSString *)timeStampWithDate:(NSDate *)date {
    
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
    });
    
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    
    return timeStamp;
}

#pragma mark - QMChatCollectionViewDelegateFlowLayout

- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView *)collectionView layoutModelAtIndexPath:(NSIndexPath *)indexPath {
    QMChatCellLayoutModel layoutModel = [super collectionView:collectionView layoutModelAtIndexPath:indexPath];
    if([self.groupChat isEqualToString:@"0"]){
         layoutModel.avatarSize = (CGSize){30.0, 30.0};
    }else{
        layoutModel.avatarSize = (CGSize){0.0, 0.0};
    }
    
    layoutModel.topLabelHeight = 0.0f;
    layoutModel.maxWidthMarginSpace = 20.0f;
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class class = [self viewClassForItem:item];
    
    if (class == [QMChatAttachmentIncomingCell class] ||
        class == [QMChatIncomingCell class]) {
        
        if (self.dialog.type != QBChatDialogTypePrivate) {
            
            NSAttributedString *topLabelString = [self topLabelAttributedStringForItem:item];
            CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:topLabelString
                                                           withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                                    limitedToNumberOfLines:1];
            layoutModel.topLabelHeight = size.height;
        }
        
        layoutModel.spaceBetweenTopLabelAndTextView = 5.0f;
    }
    else if (class == [QMChatNotificationCell class]) {
        
        layoutModel.spaceBetweenTopLabelAndTextView = 5.0f;
    }
    
    CGSize size = CGSizeZero;
    if ([self.detailedCells containsObject:item.ID]) {
        NSAttributedString *bottomAttributedString = [self bottomLabelAttributedStringForItem:item];
        size = [TTTAttributedLabel sizeThatFitsAttributedString:bottomAttributedString
                                                withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame) - widthPadding, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0];
    }
    layoutModel.bottomLabelHeight = ceilf(size.height);
    
    layoutModel.spaceBetweenTextViewAndBottomLabel = 5.0f;
    
    return layoutModel;
}

- (void)collectionView:(QMChatCollectionView *)collectionView configureCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView configureCell:cell forIndexPath:indexPath];
    
    QMChatCell *chatCell = (QMChatCell *)cell;
    
    // subscribing to cell delegate
    [chatCell setDelegate:self];
    
    [chatCell containerView].highlightColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    if ([cell isKindOfClass:[QMChatOutgoingCell class]] || [cell isKindOfClass:[QMChatAttachmentOutgoingCell class]]) {
      
        if([self.groupChat isEqualToString:@"0"]){
            chatCell.avatarView.image=[[UIImage alloc] initWithData:data];
            chatCell.avatarView.layer.cornerRadius=15;
            chatCell.avatarView.clipsToBounds=YES;
        }
        [chatCell containerView].bgColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:207/255.0 alpha:1.0];//[UIColor colorWithRed:0 green:121.0f/255.0f blue:1 alpha:1.0f];
    }
    else if ([cell isKindOfClass:[QMChatIncomingCell class]] || [cell isKindOfClass:[QMChatAttachmentIncomingCell class]]) {
        [chatCell containerView].bgColor = [UIColor whiteColor];//[UIColor colorWithRed:231.0f / 255.0f green:231.0f / 255.0f blue:231.0f / 255.0f alpha:1.0f];
        if([self.groupChat isEqualToString:@"0"]){
            chatCell.avatarView.image=[[UIImage alloc] initWithData:dataimage];
            chatCell.avatarView.layer.cornerRadius=15;
            chatCell.avatarView.clipsToBounds=YES;
        }
       

    }
    else if ([cell isKindOfClass:[QMChatNotificationCell class]]) {
        [chatCell containerView].bgColor = self.collectionView.backgroundColor;
        // avoid tapping for Notification Cell
        cell.userInteractionEnabled = NO;
    }
    
    if (![cell conformsToProtocol:@protocol(QMChatAttachmentCell)]) {
        return;
    }
    
    QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    if (message.attachments == nil) {
        return;
    }
    QBChatAttachment *attachment = message.attachments.firstObject;
    
    NSMutableArray *keysToRemove = [NSMutableArray array];
    
    NSEnumerator *enumerator = [self.attachmentCells keyEnumerator];
    NSString *existingAttachmentID = nil;
    while (existingAttachmentID = [enumerator nextObject]) {
        UICollectionViewCell *cachedCell = [self.attachmentCells objectForKey:existingAttachmentID];
        if ([cachedCell isEqual:cell]) {
            [keysToRemove addObject:existingAttachmentID];
        }
    }
    
    for (NSString *key in keysToRemove) {
        [self.attachmentCells removeObjectForKey:key];
    }
    
    [self.attachmentCells setObject:cell forKey:attachment.ID];
    [(id<QMChatAttachmentCell>)cell setAttachmentID:attachment.ID];
    
    __weak typeof(self)weakSelf = self;
    // Getting image from chat attachment service.
    [[ServicesManager instance].chatService.chatAttachmentService getImageForAttachmentMessage:message completion:^(NSError *error, UIImage *image) {
        //
        
        if ([(id<QMChatAttachmentCell>)cell attachmentID] != attachment.ID) return;
        
        [weakSelf.attachmentCells removeObjectForKey:attachment.ID];
        
        if (error != nil) {
           // [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            if (image != nil) {
                [(id<QMChatAttachmentCell>)cell setAttachmentImage:image];
                [cell updateConstraints];
            }
        }
    }];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger lastSection = [self.collectionView numberOfSections] - 1;
    if (indexPath.section == lastSection && indexPath.item == [self.collectionView numberOfItemsInSection:lastSection] - 1) {
        // the very first message
        // load more if exists
        __weak typeof(self)weakSelf = self;
        // Getting earlier messages for chat dialog identifier.
        [[[ServicesManager instance].chatService loadEarlierMessagesWithChatDialogID:self.dialog.ID] continueWithBlock:^id(BFTask *task) {
            
            if ([task.result count] > 0) {
                [weakSelf.chatSectionManager addMessages:task.result];
            }
            
            return nil;
        }];
    }
    
    // marking message as read if needed
    QBChatMessage *itemMessage = [self.chatSectionManager messageForIndexPath:indexPath];
    [self sendReadStatusForMessage:itemMessage];
    
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - QMChatCellDelegate

- (void)chatCellDidTapContainer:(QMChatCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QBChatMessage *currentMessage = [self.chatSectionManager messageForIndexPath:indexPath];
    
    if ([self.detailedCells containsObject:currentMessage.ID]) {
        [self.detailedCells removeObject:currentMessage.ID];
    } else {
        [self.detailedCells addObject:currentMessage.ID];
    }
    
    [self.collectionView.collectionViewLayout removeSizeFromCacheForItemID:currentMessage.ID];
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)chatCell:(QMChatCell *)cell didPerformAction:(SEL)action withSender:(id)sender {
    
}

- (void)chatCellDidTapAvatar:(QMChatCell *)cell {
    
}

- (void)chatCell:(QMChatCell *)cell didTapAtPosition:(CGPoint)position {
    
}

#pragma mark - QMChatServiceDelegate

- (void)chatService:(QMChatService *)chatService didLoadMessagesFromCache:(NSArray *)messages forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        
        [self.chatSectionManager addMessages:messages];
    }
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        // Inserting message received from XMPP or self sent
        [self.chatSectionManager addMessage:message];
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    
    if (self.dialog.type != QBChatDialogTypePrivate && [self.dialog.ID isEqualToString:chatDialog.ID]) {
        self.dialog  = chatDialog;
        self.title = self.dialog.name;
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateMessage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID] && message.senderID == self.senderID) {
        
        [self.chatSectionManager updateMessage:message];
    }
}

- (void)chatService:(QMChatService *)chatService didUpdateMessages:(NSArray *)messages forDialogID:(NSString *)dialogID {
    
    if ([self.dialog.ID isEqualToString:dialogID]) {
        
        [self.chatSectionManager updateMessages:messages];
    }
}

#pragma mark - QMChatConnectionDelegate

- (void)refreshAndReadMessages; {
    
    [self refreshMessagesShowingProgress:YES];
    
    if (self.unreadMessages.count > 0) {
        [self readMessages:self.unreadMessages];
    }
    
    self.unreadMessages = nil;
}

- (void)chatServiceChatDidConnect:(QMChatService *)chatService {
    
    [self refreshAndReadMessages];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService {
    
    [self refreshAndReadMessages];
}

#pragma mark - QMChatAttachmentServiceDelegate

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeAttachmentStatus:(QMMessageAttachmentStatus)status forMessage:(QBChatMessage *)message {
    
    if (status != QMMessageAttachmentStatusNotLoaded) {
        
        if ([message.dialogID isEqualToString:self.dialog.ID]) {
            
            [self.chatSectionManager updateMessage:message];
        }
    }
}

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeLoadingProgress:(CGFloat)progress forChatAttachment:(QBChatAttachment *)attachment {
    
    id<QMChatAttachmentCell> cell = [self.attachmentCells objectForKey:attachment.ID];
    if (cell != nil) {
        
        [cell updateLoadingProgress:progress];
    }
}

- (void)chatAttachmentService:(QMChatAttachmentService *)chatAttachmentService didChangeUploadingProgress:(CGFloat)progress forMessage:(QBChatMessage *)message {
    
    id<QMChatAttachmentCell> cell = [self.attachmentCells objectForKey:message.ID];
    
    if (cell == nil && progress < 1.0f) {
        
        NSIndexPath *indexPath = [self.chatSectionManager indexPathForMessage:message];
        cell = (UICollectionViewCell <QMChatAttachmentCell> *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self.attachmentCells setObject:cell forKey:message.ID];
    }
    
    if (cell != nil) {
        
        [cell updateLoadingProgress:progress];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    [super textViewDidChange:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    if (![ServicesManager instance].isAuthorized) {
        
        return YES;
    }
    
    if (self.typingTimer) {
        
        [self.typingTimer invalidate];
        self.typingTimer = nil;
    } else {
        
        [self.dialog sendUserIsTyping];
    }
    
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(fireStopTypingIfNecessary) userInfo:nil repeats:NO];
    
    if (maxCharactersNumber > 0) {
        
        if (textView.text.length >= maxCharactersNumber && text.length > 0) {
            [self showCharactersNumberError];
            return NO;
        }
        
        NSString * newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        if ([newText length] <= maxCharactersNumber || text.length == 0) {
            return YES;
        }
        NSInteger symbolsToCut = maxCharactersNumber - textView.text.length;
        
        NSRange stringRange = {0, MIN([text length], symbolsToCut)};
        
        // adjust the range to include dependent chars
        stringRange = [text rangeOfComposedCharacterSequencesForRange:stringRange];
        
        // Now you can create the short string
        NSString *shortString = [text substringWithRange:stringRange];
        
        NSMutableString * newtext = textView.text.mutableCopy;
        [newtext insertString:shortString atIndex:range.location];
        
        textView.text = newtext.copy;
        
        [self showCharactersNumberError];
        
        [self textViewDidChange:textView];
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [super textViewDidEndEditing:textView];
    
    [self fireStopTypingIfNecessary];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)didPickAttachmentImage:(UIImage *)image {
    
    QBChatMessage *message = [QBChatMessage new];
    message.senderID = self.senderID;
    message.dialogID = self.dialog.ID;
    message.dateSent = [NSDate date];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *UserName= [prefs stringForKey:@"UserName"];
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    [dictdata setObject:UserName forKey:@"username"];
    message.customParameters=dictdata;
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __typeof(weakSelf)strongSelf = weakSelf;
        UIImage *newImage = image;
        if (strongSelf.pickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            newImage = [newImage fixOrientation];
        }
        
        UIImage *resizedImage = [strongSelf resizedImageFromImage:newImage];
        
        // Sending attachment to the dialog.
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ServicesManager instance].chatService sendAttachmentMessage:message
                                                                 toDialog:strongSelf.dialog
                                                      withAttachmentImage:resizedImage
                                                               completion:^(NSError *error) {
                                                                   
                                                                   [strongSelf.attachmentCells removeObjectForKey:message.ID];
                                                                   
                                                                   if (error != nil) {
                                                                     //  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                                       
                                                                       // perform local attachment deleting
                                                                       [[ServicesManager instance].chatService deleteMessageLocally:message];
                                                                       [strongSelf.chatSectionManager deleteMessage:message];
                                                                   }
                                                               }];
        });
    });
}

- (void)showCharactersNumberError {
    NSString * title  = NSLocalizedString(@"SA_STR_ERROR", nil);
    NSString * subtitle = [NSString stringWithFormat:@"The character limit is %lu. ", (unsigned long)maxCharactersNumber];
    
    [QMMessageNotificationManager showNotificationWithTitle:title
                                                   subtitle:subtitle
                                                       type:QMMessageNotificationTypeWarning];
}

- (UIImage *)resizedImageFromImage:(UIImage *)image {
    
    CGFloat largestSide = image.size.width > image.size.height ? image.size.width : image.size.height;
    CGFloat scaleCoefficient = largestSide / 560.0f;
    CGSize newSize = CGSizeMake(image.size.width / scaleCoefficient, image.size.height / scaleCoefficient);
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:(CGRect){0, 0, newSize.width, newSize.height}];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
