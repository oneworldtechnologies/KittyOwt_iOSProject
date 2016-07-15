//
//  AlertView.m
//  MyVideoTech
//
//  Created by OSX on 14/01/16.
//  Copyright (c) 2016 OremTech. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
+ (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2.0];
}
+(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
