//
//  FMenuViewController.h
//  FootballApp
//
//  Created by Ambika on 22/07/14.
//  Copyright (c) 2014 Manpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
@interface FMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UITableView *menuTbleVw;

@end
