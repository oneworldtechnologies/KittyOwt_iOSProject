//
//  PermotionalDetailsViewController.h
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 25/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermotionalDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSDictionary *dictDetails;
@end
