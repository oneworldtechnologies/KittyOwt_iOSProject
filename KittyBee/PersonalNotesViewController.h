//
//  PersonalNotesViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 28/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalNotesViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblNotes;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)cmdAdd:(id)sender;

//PopUpView
@property (weak, nonatomic) IBOutlet UITextField *txtPopupTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPopUpContent;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)cmdCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)cmdSave:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *popUPView;
@property (weak, nonatomic) IBOutlet UILabel *lblBack;


//Aditional Data to differenciate
@property (strong, nonatomic) NSString *strPersonalNoteORKittyNotes;
@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) NSString *kittyNo;
@property (strong, nonatomic) NSString *strFromMenu;
@end
