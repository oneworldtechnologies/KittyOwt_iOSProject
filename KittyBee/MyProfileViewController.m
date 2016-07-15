//
//  MyProfileViewController.m
//  KittyBee
//
//  Created by ONE WORLD TECHNOLOGIES on 26/04/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController (){
    int imageType;
    UIActivityIndicatorView *indicator;
    NSDictionary *dictData;
    IndecatorView *ind;
    
}

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HideProfile:)
                                                 name:@"ReturnViewToBottom"
                                               object:nil];
    
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
     [self adjustProfileImages];
    if(self.strOtherPersonProfile){
        [self getOtherProfile];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict= [defaults objectForKey:@"StoreProfileData"];
        if(dict){
            [self showProfileData];
        }else{
            [self getProfileData];
        }
    }
}

- (void)HideProfile:(NSNotification *) notification {//ReloadMenuTable
    [self viewDown];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!(self.strOtherPersonProfile)){
        self.btnCall.hidden=YES;
        self.btnMsg.hidden=YES;
        self.btnSubmit.hidden=YES;
         self.title=@"My Profile";
    }else{
        self.btnSubmit.hidden=YES;
        self.title=self.strOtherPersonName;
    }
   
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0];
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    btnEdit.frame = CGRectMake(0, 0, 32, 32);
    
    [btnEdit addTarget:self action:@selector(cmdEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSearchBar = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    [arrRightBarItems addObject:btnSearchBar];
    if(!(self.strOtherPersonProfile)){
        self.navigationItem.rightBarButtonItems=arrRightBarItems;
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPhone.inputAccessoryView = numberToolbar;
    
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.color = [UIColor lightGrayColor];
    indicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    
}


-(void)cmdEdit:(id)Sender{
    [self elableUserIntraction];
}
-(void)adjustProfileImages{
    self.txtViewAddress.textColor = [UIColor lightGrayColor];
    self.txtViewAddress.text = @"Please enter your Address";
    self.myProfileImg.activityIndicatorStyle=UIActivityIndicatorViewStyleWhite;
    self.myProfileImg.showActivityIndicator=YES;
    self.husbandImg.activityIndicatorStyle=UIActivityIndicatorViewStyleWhite;
    self.husbandImg.showActivityIndicator=YES;
    self.familyImg.activityIndicatorStyle=UIActivityIndicatorViewStyleWhite;
    self.familyImg.showActivityIndicator=YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight>665 && screenHeight<730){
        self.myProfileView.frame=CGRectMake(self.myProfileView.frame.origin.x-10, self.myProfileView.frame.origin.y-10, 130, 130);
        self.myProfileImg.frame=CGRectMake(0, 0, 130, 130);
        
        self.husbandView.frame=CGRectMake(self.husbandView.frame.origin.x-10, self.husbandView.frame.origin.y-10, 110, 110);
        self.husbandImg.frame=CGRectMake(0, 0, 110, 110);
        
        self.familyView.frame=CGRectMake(self.familyView.frame.origin.x-10, self.familyView.frame.origin.y-10, 90, 90);
        self.familyImg.frame=CGRectMake(0, 0, 90, 90);
    }else if (screenHeight>730){
        self.myProfileView.frame=CGRectMake(self.myProfileView.frame.origin.x-20, self.myProfileView.frame.origin.y-25, 150, 150);
        self.myProfileImg.frame=CGRectMake(0, 0, 150, 150);
        
        self.husbandView.frame=CGRectMake(self.husbandView.frame.origin.x-20, self.husbandView.frame.origin.y-25, 130, 130);
        self.husbandImg.frame=CGRectMake(0, 0, 130, 130);
        
        self.familyView.frame=CGRectMake(self.familyView.frame.origin.x-20, self.familyView.frame.origin.y-25, 110, 110);
        self.familyImg.frame=CGRectMake(0, 0, 110, 110);
        
    }
    [self.myProfileView.layer setCornerRadius:55];
    if(screenHeight>665 && screenHeight<730){
        [self.myProfileView.layer setCornerRadius:65];
    }else if (screenHeight>730){
        [self.myProfileView.layer setCornerRadius:75];
    }
    [self.myProfileView.layer setBorderColor:[UIColor colorWithRed:141/255.0 green:217/255.0 blue:182/255.0 alpha:1].CGColor];
    [self.myProfileView.layer setBorderWidth:5];
    [self.myProfileView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.myProfileView.layer setShadowOpacity:0.3];
    [self.myProfileView.layer setShadowRadius:3.0];
    [self.myProfileView.layer setShadowOffset:CGSizeMake(1, 1)];
    self.myProfileImg.layer.cornerRadius=55;
    if(screenHeight>665 && screenHeight<730){
        self.myProfileImg.layer.cornerRadius=65;
    }else if (screenHeight>730){
        self.myProfileImg.layer.cornerRadius=75;
    }
    self.myProfileImg.clipsToBounds=YES;
    
    [self.husbandView.layer setCornerRadius:45];
    if(screenHeight>665 && screenHeight<730){
        [self.husbandView.layer setCornerRadius:55];
    }else if (screenHeight>730){
        [self.husbandView.layer setCornerRadius:65];
    }
    [self.husbandView.layer setBorderColor:[UIColor colorWithRed:141/255.0 green:217/255.0 blue:182/255.0 alpha:1].CGColor];
    [self.husbandView.layer setBorderWidth:5];
    [self.husbandView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.husbandView.layer setShadowOpacity:0.3];
    [self.husbandView.layer setShadowRadius:3.0];
    [self.husbandView.layer setShadowOffset:CGSizeMake(1, 1)];
    self.husbandImg.layer.cornerRadius=45;
    if(screenHeight>665 && screenHeight<730){
        self.husbandImg.layer.cornerRadius=55;
    }else if (screenHeight>730){
        self.husbandImg.layer.cornerRadius=65;
    }
    self.husbandImg.clipsToBounds=YES;
    
    [self.familyView.layer setCornerRadius:35];
    if(screenHeight>665 && screenHeight<730){
        [self.familyView.layer setCornerRadius:45];
    }else if (screenHeight>730){
        [self.familyView.layer setCornerRadius:55];
    }
    [self.familyView.layer setBorderColor:[UIColor colorWithRed:141/255.0 green:217/255.0 blue:182/255.0 alpha:1].CGColor];
    [self.familyView.layer setBorderWidth:5];
    [self.familyView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.familyView.layer setShadowOpacity:0.3];
    [self.familyView.layer setShadowRadius:3.0];
    [self.familyView.layer setShadowOffset:CGSizeMake(1, 1)];
    self.familyImg.layer.cornerRadius=35;
    if(screenHeight>665  && screenHeight<730){
        self.familyImg.layer.cornerRadius=45;
    }else if (screenHeight>730){
        self.familyImg.layer.cornerRadius=55;
    }
    self.familyImg.clipsToBounds=YES;
    
    
    if(screenHeight<568){
        self.scrollview.contentSize = CGSizeMake(screenWidth,
                                                 320);
    }
    
    UITapGestureRecognizer *ProfilePicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProfileTap:)];
    [ProfilePicTap setNumberOfTapsRequired:1];
    [self.myProfileView setUserInteractionEnabled:NO];
    [self.myProfileView addGestureRecognizer:ProfilePicTap];
    
    UITapGestureRecognizer *husbandPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(husbandPicTapTap:)];
    [husbandPicTap setNumberOfTapsRequired:1];
    [self.husbandView setUserInteractionEnabled:NO];
    [self.husbandView addGestureRecognizer:husbandPicTap];
    
    UITapGestureRecognizer *famliyPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FamilyPicTapTap:)];
    [famliyPicTap setNumberOfTapsRequired:1];
    [self.familyView setUserInteractionEnabled:NO];
    [self.familyView addGestureRecognizer:famliyPicTap];
    
    
    UITapGestureRecognizer *lblNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblNameTap:)];
    [lblNameTap setNumberOfTapsRequired:1];
    [self.lblName setUserInteractionEnabled:NO];
    [self.lblName addGestureRecognizer:lblNameTap];
}

- (void)lblNameTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self viewDown];
    [self.view endEditing:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter your new name." delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)FamilyPicTapTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self viewDown];
    [self.view endEditing:YES];
    
    imageType=3;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
}

- (void)husbandPicTapTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self viewDown];
    [self.view endEditing:YES];
    
    imageType=2;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
}

- (void)ProfileTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self viewDown];
    [self.view endEditing:YES];
    
    
    imageType=1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Select Photo", nil];
    [actionSheet showInView:self.view];
}
#pragma mark ---------- Text Feild delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textField==self.txtPhone){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -80, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                             }
                         }else if (textField==self.txtStatus){
                             
                             if(SCREEN_SIZE.height<568){
                                  self.view.frame=CGRectMake(self.view.frame.origin.x, -80, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                  self.view.frame=CGRectMake(self.view.frame.origin.x, -30, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                            
                         }else if (textField==self.txtEmail){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -70, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                         }else if (textField==self.txtCity){
                             if(SCREEN_SIZE.height<568){
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
                             }else{
                                 self.view.frame=CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             
                         }else if(textField==self.txtAddress){
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

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView== self.txtViewAddress){
        self.txtViewAddress.text = @"";
        self.txtViewAddress.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    }
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(textView==self.txtViewAddress){
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self viewDown];
    [textField resignFirstResponder];
    NSString *strTag;
    if (textField==self.txtStatus){
        strTag=@"2";
    }else if (textField==self.txtEmail){
        strTag=@"3";
    }else if (textField==self.txtCity){
        strTag=@"4";
    }
   // [self performSelector:@selector(showPopUp:) withObject:strTag afterDelay:0.5];
    return YES;
}



-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView== self.txtViewAddress){
        if(self.txtViewAddress.text.length == 0){
            NSString *strAddressValue=[dictData objectForKey:@"address"];
            if([strAddressValue isEqualToString:@""]){
                self.txtViewAddress.textColor = [UIColor lightGrayColor];
                self.txtViewAddress.text = @"Please enter your Address";
                [self.txtViewAddress resignFirstResponder];
            }else{
                self.txtViewAddress.text=strAddressValue;
            }
            
        }
        
    }
    
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self viewDown];
        if(self.txtViewAddress.text.length == 0){
            NSString *strAddressValue=[dictData objectForKey:@"address"];
            if([strAddressValue isEqualToString:@""]){
                self.txtViewAddress.textColor = [UIColor lightGrayColor];
                self.txtViewAddress.text = @"Please enter your Address";
            }else{
                self.txtViewAddress.text=strAddressValue;
            }
            
        }else{
           // [self performSelector:@selector(showPopUp:) withObject:@"5" afterDelay:0.5];
            
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



-(void)showPopUp:(NSString *)tagVal{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Sure You Want To save Your Changes ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=[tagVal intValue];
    [alert show];
}
#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSMutableDictionary* dict=[self Makedict];
    if(buttonIndex==1){
        
        if(alertView.tag==1){
            [dict setObject:self.txtPhone.text forKey:@"phone"];
        }else if(alertView.tag==2){
            [dict setObject:self.txtStatus.text forKey:@"status"];
        }else if(alertView.tag==3){
            [dict setObject:self.txtEmail.text forKey:@"email"];
        }else if(alertView.tag==4){
            [dict setObject:self.txtCity.text forKey:@"city"];
        }else if(alertView.tag==5){
            [dict setObject:self.txtViewAddress.text forKey:@"address"];
            
        }else if(alertView.tag==6){
        
            NSData *myProfileImageData = [NSData dataWithData:UIImageJPEGRepresentation(self.myProfileImg.image, 0.5)];//[NSData dataWithData:UIImagePNGRepresentation(self.myProfileImg.image)];
            NSString *myProfileBase64String = [myProfileImageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [dict setObject:myProfileBase64String forKey:@"profile"];
            
        }else if(alertView.tag==7){
            
            NSData *husbandImgImageData = [NSData dataWithData:UIImageJPEGRepresentation(self.husbandImg.image, 0.5)];//[NSData dataWithData:UIImagePNGRepresentation(self.husbandImg.image)];
            NSString *husbandImgImageDataBase64String = [husbandImgImageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [dict setObject:husbandImgImageDataBase64String forKey:@"couple"];
            
        }else if(alertView.tag==8){
            NSData *familyImgImageData = [NSData dataWithData:UIImageJPEGRepresentation(self.familyImg.image, 0.5)];//[NSData dataWithData:UIImagePNGRepresentation(self.familyImg.image)];
            NSString *familyImgImageDataBase64String = [familyImgImageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [dict setObject:familyImgImageDataBase64String forKey:@"family"];
            
            
        }else if(alertView.tag==9){
            [dict setObject:self.lblName.text forKey:@"name"];
            
        }else{
            
            NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            NSString *StrName=[[[alertView textFieldAtIndex:0] text] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([StrName isEqualToString:@""]){
                
            }else{
                 self.lblName.text=[[alertView textFieldAtIndex:0] text];
            }
           
           // [self showPopUp:@"9"];
            
            
            return;
        }
        
        [self.view addSubview:ind];
        [[ApiClient sharedInstance]editProfile:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            // Store the data
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"data"] forKey:@"StoreProfileData"];
            
            NSDictionary *dictData1=[dict objectForKey:@"data"];
            NSString *strProfiePic=[dictData1 objectForKey:@"profilePic"];
            strProfiePic=[strProfiePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            
    
            
            [defaults setObject:strProfiePic forKey:@"profilePic"];
            [defaults setObject:[dictData1 objectForKey:@"name"] forKey:@"UserName"];
            
            
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ReloadMenuTable"
             object:self];
            [AlertView showAlertWithMessage:[dict objectForKey:@"message"]];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
        
        //name,city,email,address,phone,status profile family couple
        
    }
}
-(NSMutableDictionary *)Makedict{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"" forKey:@"name"];
    [dict setObject:@"" forKey:@"city"];
    [dict setObject:@"" forKey:@"email"];
    [dict setObject:@"" forKey:@"address"];
    [dict setObject:@"" forKey:@"status"];
    [dict setObject:@"" forKey:@"profile"];
    [dict setObject:@"" forKey:@"family"];
    [dict setObject:@"" forKey:@"couple"];
    return dict;
}
-(void)elableUserIntraction{
    self.txtAddress.userInteractionEnabled=YES;
    self.txtCity.userInteractionEnabled=YES;
    self.txtStatus.userInteractionEnabled=YES;
    self.txtPhone.userInteractionEnabled=NO;
    self.txtEmail.userInteractionEnabled=YES;
    self.txtViewAddress.userInteractionEnabled=YES;
    [self.myProfileView setUserInteractionEnabled:YES];
    [self.husbandView setUserInteractionEnabled:YES];
    [self.familyView setUserInteractionEnabled:YES];
    [self.lblName setUserInteractionEnabled:YES];
    [self.btnSubmit setUserInteractionEnabled:YES];
    [self.txtStatus becomeFirstResponder];
    self.btnSubmit.hidden=NO;
}
-(void)cancelNumberPad{
    self.txtPhone.text=[dictData objectForKey:@"phone"];
    [self resignKeyBoard];
}
-(void)doneWithNumberPad{
    [self resignKeyBoard];
    [self viewDown];
    [self performSelector:@selector(showPopUp:) withObject:@"1" afterDelay:0.5];
}
-(void)resignKeyBoard{
    [self.txtPhone resignFirstResponder];
    [self viewDown];
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
    
    if(imageType==1){
        self.myProfileImg.image=newImage;
        [self showPopUp:@"6"];
    }else if(imageType==2){
        self.husbandImg.image=newImage;
        [self showPopUp:@"7"];
        
    }else if(imageType==3){
        self.familyImg.image=newImage;
        [self showPopUp:@"8"];
        
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)addView{
    
    
}
-(void)getOtherProfile{
     [self.view addSubview:ind];
   [[ApiClient sharedInstance]getOtherProfile:self.strOtherPersonProfile success:^(id responseObject) {
        [ind removeFromSuperview];
        NSDictionary *dict1=responseObject;
       NSDictionary *dict=[dict1 objectForKey:@"data"];
       NSString *strProfiePic=[dict objectForKey:@"profilePic"];
       strProfiePic=[strProfiePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
       
       NSString *strhusbandImg=[dict objectForKey:@"coupleIMG"];
       strhusbandImg=[strhusbandImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
       
       NSString *strfamilyImg=[dict objectForKey:@"familyIMG"];
       strfamilyImg=[strfamilyImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
       
       self.myProfileImg.imageURL=[NSURL URLWithString:strProfiePic];
       
       self.husbandImg.imageURL=[NSURL URLWithString:strhusbandImg];
       
       self.familyImg.imageURL=[NSURL URLWithString:strfamilyImg];
       
       self.txtViewAddress.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
       
       self.lblName.text=[dict objectForKey:@"name"];
       self.txtPhone.text=[dict objectForKey:@"phone"];
       self.txtStatus.text=[dict objectForKey:@"status"];
       self.txtEmail.text=[dict objectForKey:@"email"];
       self.txtCity.text=[dict objectForKey:@"city"];
       self.txtAddress.text=[dict objectForKey:@"address"];
       self.txtViewAddress.text=[dict objectForKey:@"address"];
       
       
       
   } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
       [ind removeFromSuperview];
       [AlertView showAlertWithMessage:errorString];
   }];
    
}

-(void)getProfileData{
    
    [self.view addSubview:ind];
    [[ApiClient sharedInstance] getProfile:^(id responseObject) {
        
        [ind removeFromSuperview];
        NSDictionary *dict=responseObject;
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dict objectForKey:@"data"] forKey:@"StoreProfileData"];
        
        NSDictionary *dictData1=[dict objectForKey:@"data"];
        NSString *strProfiePic=[dictData1 objectForKey:@"profilePic"];
        strProfiePic=[strProfiePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        
        [defaults setObject:strProfiePic forKey:@"profilePic"];
        [defaults setObject:[dictData1 objectForKey:@"name"] forKey:@"UserName"];
          [defaults synchronize];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ReloadMenuTable"
         object:self];
        
      
        [self showProfileData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        [ind removeFromSuperview];
        [AlertView showAlertWithMessage:errorString];
        
    }];
}
-(void)showProfileData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict= [defaults objectForKey:@"StoreProfileData"];
    dictData=dict;
    NSString *strProfiePic=[dict objectForKey:@"profilePic"];
    strProfiePic=[strProfiePic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *strhusbandImg=[dict objectForKey:@"coupleIMG"];
    strhusbandImg=[strhusbandImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *strfamilyImg=[dict objectForKey:@"familyIMG"];
    strfamilyImg=[strfamilyImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    self.myProfileImg.imageURL=[NSURL URLWithString:strProfiePic];
    
    self.husbandImg.imageURL=[NSURL URLWithString:strhusbandImg];
    
    self.familyImg.imageURL=[NSURL URLWithString:strfamilyImg];
    
    self.txtViewAddress.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    
    self.lblName.text=[dict objectForKey:@"name"];
    self.txtPhone.text=[dict objectForKey:@"phone"];
    self.txtStatus.text=[dict objectForKey:@"status"];
    self.txtEmail.text=[dict objectForKey:@"email"];
    self.txtCity.text=[dict objectForKey:@"city"];
    self.txtAddress.text=[dict objectForKey:@"address"];
    self.txtViewAddress.text=[dict objectForKey:@"address"];

}
- (IBAction)cmdCall:(id)sender {
    NSString *strNum=[NSString stringWithFormat:@"telprompt://%@",self.txtPhone.text];
    strNum=[strNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNum]];
}

- (IBAction)cmdText:(id)sender {
    NSString *strNum=[NSString stringWithFormat:@"sms:%@",self.txtPhone.text];
    strNum=[strNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNum]];
}
- (IBAction)cmdSubmit:(id)sender {
    [self viewDown];
   NSString *strName=[self.lblName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *strStatus=[self.txtStatus.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *strcity=[self.txtCity.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   NSString *strAddress=[self.txtViewAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strName.length==0 || strStatus.length==0 || strcity.length==0 || strAddress.length==0){
        
        [AlertView showAlertWithMessage:@"Feilds can't be empty."];
    }else if(!([self NSStringIsValidEmail:self.txtEmail.text])){
        [AlertView showAlertWithMessage:@"Please enter Valid email."];
    }else{
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:self.lblName.text forKey:@"name"];
        [dict setObject:self.txtCity.text forKey:@"city"];
        [dict setObject:self.txtEmail.text forKey:@"email"];
        [dict setObject:self.txtViewAddress.text forKey:@"address"];
        [dict setObject:self.txtStatus.text forKey:@"status"];
        [dict setObject:@"" forKey:@"profile"];
        [dict setObject:@"" forKey:@"family"];
        [dict setObject:@"" forKey:@"couple"];
        [self.view addSubview:ind];
        [[ApiClient sharedInstance]editProfile:dict success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dictdata=responseObject;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dictdata objectForKey:@"data"] forKey:@"StoreProfileData"];

            [AlertView showAlertWithMessage:[dictdata objectForKey:@"message"]];
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
    }
    
    
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
