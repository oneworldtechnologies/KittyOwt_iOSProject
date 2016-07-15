//
//  PermotionalListingViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 18/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermotionalListingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblListing;
@property (strong, nonatomic) NSString *pageNumber;
@end
