//
//  IndecatorView.m
//  you-teach
//
//  Created by AthenaSoft on 28/09/15.
//  Copyright (c) 2015 AthenaSoft. All rights reserved.
//

#import "IndecatorView.h"

@implementation IndecatorView{
    int checkTimer;
    NSTimer *timer;
    UIActivityIndicatorView *Indicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
//        UIVisualEffect *blurEffect;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        
//        UIVisualEffectView *visualEffectView;
//        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        
//        visualEffectView.frame = self.bounds;
//        [self addSubview:visualEffectView];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;

        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        self.LoaderView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-70, screenHeight/2-50, 140, 50)];
        //[self.LoaderView setCenter:self.center];
        self.LoaderView.layer.cornerRadius=10;
        self.LoaderView.backgroundColor=[UIColor clearColor];//[UIColor colorWithRed:128/255.0 green:222/255.0 blue:234/255.0 alpha:1.0];
        Indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        UIView *indecatorview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        indecatorview.backgroundColor=[UIColor clearColor];
        Indicator.center=indecatorview.center;
        [Indicator startAnimating];
        self.Loading=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 90, 30)];
        self.Loading.text=@"Loading...";
        self.Loading.textColor=[UIColor whiteColor];
        [self.LoaderView addSubview:self.Loading];
        [self addSubview:Indicator];
        [indecatorview addSubview:Indicator];
        [self.LoaderView addSubview:indecatorview];
        [self addSubview:self.LoaderView];
        self.LoaderView.layer.masksToBounds = NO;
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.LoaderView.bounds];
//        self.LoaderView.layer.masksToBounds = NO;
//        self.LoaderView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.LoaderView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//        self.LoaderView.layer.shadowOpacity = 0.5f;
//        self.LoaderView.layer.shadowPath = shadowPath.CGPath;
        checkTimer=1;
    }
    return self;
}
- (void)didMoveToSuperview{
    NSLog(@"checktimer %d",checkTimer);
    if(checkTimer==1){
        checkTimer=2;
        timer= [NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(changeLabel)
                                              userInfo:nil
                                               repeats:YES];
    }else{
        [timer invalidate];
        timer=nil;
    }
    
}
-(void)willRemoveSubview:(UIView *)subview{
    
}

-(void)changeLabel{
    if([self.Loading.text isEqualToString:@"Loading..."]){
        self.Loading.text=@"Loading";
    }else if ([self.Loading.text isEqualToString:@"Loading."]){
        self.Loading.text=@"Loading..";
    }else if([self.Loading.text isEqualToString:@"Loading.."]){
        self.Loading.text=@"Loading...";
    }else if([self.Loading.text isEqualToString:@"Loading"]){
        self.Loading.text=@"Loading.";
    }
}

@end
