//
//  BillViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 05/05/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "BillViewController.h"

@interface BillViewController (){
    AsyncImageView *engimage;
    UIView *imgview;
    UIScrollView *myScrollView;
    int a;
    IndecatorView *ind;
    UIButton *backtoProfileBtn;
}
@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:strBill];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict= [defaults objectForKey:strBill];
    if(dict){
        [self showData];
        [self getBill];
        [self.btnSubmit setTitle:@"UPDATE" forState:UIControlStateNormal];
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(SCREEN_SIZE.height<568){
        self.scrollview.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+130);
    }else if(SCREEN_SIZE.height>568){
        self.scrollview.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height);
    }else{
        self.scrollview.contentSize = CGSizeMake(SCREEN_SIZE.width,
                                                 SCREEN_SIZE.height+30);
    }
    self.title=@"BILL";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.imgBill.clipsToBounds=YES;
     ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.imgBill addGestureRecognizer:singleFingerTap];
    [self.imgBill setUserInteractionEnabled:YES];
    

    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self enlargeimage:nil];
    //Do stuff here...
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
     //self.imgBill.frame=CGRectMake(SCREEN_SIZE.width/2-100, 32, 200, 200);
}
- (IBAction)cmdUploadBill:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
    
    //[self enlargeimage:nil];
}

- (IBAction)cmdSubmit:(id)sender {
    [self addBill];
}

#pragma mark ---------- Text Feild delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textField==self.txtTotalMember){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -80, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                             }
                         }else if (textField==self.txtTotalCollection){
                             
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -80, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -30, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                             
                         }else if (textField==self.txtAdvancePaid){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -70, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                         }else if (textField==self.txtGames){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                         }else if(textField==self.txtBillAmount || textField==self.txtPreviousBalance || textField==self.txtcarryForward || textField==self.txtBalance){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self viewDown];
    [textField resignFirstResponder];
  
    return YES;
}
-(void)viewDown{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
}

#pragma mark animation

-(void)enlargeimage:(id)sender{
    
    imgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    imgview.contentMode = UIViewContentModeScaleAspectFill;
    imgview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"2.png"]];
    
    //imgview.alpha = 0.8;
    
    imgview.transform = CGAffineTransformMakeScale(0.45, 0.45);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        imgview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                    (10, 10, self.view.frame.size.width-20,self.view.frame.size.height-20)];
    myScrollView.scrollEnabled = YES;
    myScrollView.bouncesZoom = YES;
    myScrollView.delegate = self;
    myScrollView.clipsToBounds = YES;
    [self centerScrollViewContents];
    
    engimage=[[AsyncImageView alloc]initWithFrame:CGRectMake(myScrollView.frame.origin.x-10, myScrollView.frame.origin.y,  myScrollView.frame.size.width, myScrollView.frame.size.height)];
    
    engimage.contentMode = UIViewContentModeScaleAspectFit
    ;
    if (engimage.image != nil){
        engimage.image=self.imgBill.image;

    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
        NSDictionary *dict= [defaults objectForKey:strBill];
        NSString *StrUrl=[dict objectForKey:@"image"];
        StrUrl=[StrUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        engimage.imageURL=[NSURL URLWithString:StrUrl];
    }
        
    
           

        engimage.userInteractionEnabled=YES;
    [myScrollView addSubview:engimage];
    [imgview addSubview:myScrollView];
    [self.view addSubview:imgview];
    [self.view bringSubviewToFront:imgview];
    
    myScrollView.contentSize = CGSizeMake(engimage.bounds.size.width, engimage.bounds.size.height);
    myScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [engimage addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [engimage addGestureRecognizer:twoFingerTapRecognizer];
    float minimumScale = 1.0;//This is the minimum scale, set it to whatever you want. 1.0 = default
    myScrollView.maximumZoomScale = 4.0;
    myScrollView.minimumZoomScale = minimumScale;
    myScrollView.zoomScale = minimumScale;
    [myScrollView setContentMode:UIViewContentModeScaleAspectFit];
    //[fullImage sizeToFit];
    [myScrollView setContentSize:CGSizeMake(engimage.frame.size.width, engimage.frame.size.height)];
    
    backtoProfileBtn =[[UIButton alloc]init];
    backtoProfileBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backtoProfileBtn.frame = CGRectMake(SCREEN_SIZE.width-50,12,30,30);
    backtoProfileBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    [backtoProfileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[backtoProfileBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [backtoProfileBtn setBackgroundImage:[UIImage imageNamed:@"cross@1x"] forState:UIControlStateNormal];
    [backtoProfileBtn addTarget:self  action:@selector(backToprofile:) forControlEvents:UIControlEventTouchUpInside];
    [imgview addSubview:backtoProfileBtn];
}



-(void)backToprofile:(UIButton*)sender
{
    [imgview removeFromSuperview];
    
    
}
- (void)centerScrollViewContents {
    CGSize boundsSize = myScrollView.bounds.size;
    CGRect contentsFrame = engimage.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    engimage.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:engimage];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = myScrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, myScrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = myScrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    // [imgview removeFromSuperview];
    [myScrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = myScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, myScrollView.minimumZoomScale);
    [myScrollView setZoomScale:newZoomScale animated:YES];
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return engimage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
#pragma mark ---------- Action sheet delegate ------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(buttonIndex==0){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if(buttonIndex==1){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark ---------- imagePickerController delegate ------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerEditedImage];
    
    CGSize destinationSize = CGSizeMake(400, 400);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imgBill.image=newImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)addBill{
    [self viewDown];
    [self.view addSubview:ind];
    

    NSString *strTotalMember=self.txtTotalMember.text;
    NSString *strTotalCollection=self.txtTotalCollection.text;
    NSString *strAdavncePaid=self.txtAdvancePaid.text;
    NSString *strGames=self.txtGames.text;
    NSString *strBillAmmount=self.txtBillAmount.text;
    NSString *strPreviousBal=self.txtPreviousBalance.text;
    NSString *strCarryForward=self.txtcarryForward.text;
    NSString *strBalanceWith=self.txtBalance.text;
    
    UIImage *imgBill = self.imgBill.image;
    
    NSData *dataCheck=UIImageJPEGRepresentation(imgBill, 0.6);
    NSString *imgString = [dataCheck base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

   // group_id&kitty_id&member_present&collection&advanced_paid&gift_game&amount&previous_balance&carry_forword&balance_with&image
    NSMutableDictionary *dict=[[NSMutableDictionary  alloc]init];
    [dict setObject:self.group_id forKey:@"group_id"];
    [dict setObject:self.kitty_id forKey:@"kitty_id"];
    [dict setObject:strTotalMember forKey:@"member_present"];
    [dict setObject:strTotalCollection forKey:@"collection"];
    [dict setObject:strAdavncePaid forKey:@"advanced_paid"];
    [dict setObject:strGames forKey:@"gift_game"];
    [dict setObject:strBillAmmount forKey:@"amount"];
    [dict setObject:strPreviousBal forKey:@"previous_balance"];
    [dict setObject:strCarryForward forKey:@"carry_forword"];
     [dict setObject:strBalanceWith forKey:@"balance_with"];
    [dict setObject:imgString forKey:@"imageBill"];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
    NSDictionary *dictCheck= [defaults objectForKey:strBill];
    if(dictCheck){
        [dict setObject:[dictCheck objectForKey:@"id"] forKey:@"id"];
        [[ApiClient sharedInstance]editBill:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
            NSDictionary *dataDit=[dict objectForKey:@"data"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dataDit forKey:strBill];
            [defaults synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
        
    }else{
        [[ApiClient sharedInstance]addBill:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
            NSDictionary *dataDit=[dict objectForKey:@"data"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dataDit forKey:strBill];
            [defaults synchronize];
            
            [AlertView showAlertWithMessage:@"Bill Updated successfully"];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
    }
    
    
}
-(void)getBill{
    NSMutableDictionary *dict=[[NSMutableDictionary  alloc]init];
    [dict setObject:self.group_id forKey:@"group_id"];
    [dict setObject:self.kitty_id forKey:@"kitty_id"];
    
    [[ApiClient sharedInstance]getBill:dict success:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
        NSDictionary *dataDit=[dict objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataDit forKey:strBill];
        [defaults synchronize];
        [self showData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
         [self showData];
    }];
}

-(void)showData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strBill=[NSString stringWithFormat:@"BILL%@%@",self.group_id,self.kitty_id];
    NSDictionary *dict= [defaults objectForKey:strBill];

    self.txtTotalMember.text=[dict objectForKey:@"member_present"];
    self.txtTotalCollection.text=[dict objectForKey:@"collection"];
    self.txtAdvancePaid.text=[dict objectForKey:@"advanced_paid"];
    self.txtGames.text=[dict objectForKey:@"gift_game"];
    self.txtBillAmount.text=[dict objectForKey:@"amount"];
    self.txtPreviousBalance.text=[dict objectForKey:@"previous_balance"];
    self.txtcarryForward.text=[dict objectForKey:@"carry_forword"];
    self.txtBalance.text=[dict objectForKey:@"balance_with"];
    NSString *StrUrl=[dict objectForKey:@"image"];
    StrUrl=[StrUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    self.imgBill.imageURL=[NSURL URLWithString:StrUrl];
//
}
@end
