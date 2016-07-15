//
//  InvatationCardViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 29/06/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvatationCardViewController : UIViewController

@property(strong, nonatomic) NSString *strKittyId;
@property(strong, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnMaybe;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
- (IBAction)cmdYes:(id)sender;
- (IBAction)cmdNo:(id)sender;
- (IBAction)cmdMaybe:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLabel;

@end
