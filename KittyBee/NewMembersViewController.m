//
//  NewMembersViewController.m
//  KittyBee
//
//  Created by Arun on 05/07/16.
//  Copyright © 2016 ONE WORLD TECHNOLOGIES. All rights reserved.
//

#import "NewMembersViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "SelectCoupleViewController.h"
#import "kidsViewController.h"
#import "PaidOrNotViewController.h"
@interface NewMembersViewController (){
     NSMutableArray *arryContact;
    IndecatorView *ind;
    NSMutableIndexSet *selectedData;
    BOOL showSearch;
    UISearchBar *searchBar;
    NSMutableArray *searchResults;
    NSMutableArray *arryRowValue;
    NSMutableArray *arrySelectedValue;
    NSArray *dictContact;
    NSString *strCatagory;
    NSMutableArray *unPaired;
}

@end

@implementation NewMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arryRowValue=[[NSMutableArray alloc]init];
    arrySelectedValue=[[NSMutableArray alloc]init];
    ind=[[IndecatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self getAllContacts];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"ADD MEMBER";
}

#pragma mark contactFetch

-(void)askPermissionContact{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [Alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getAllContacts];
    }
    else {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Need Access to Addressbook" message:@"KittyBee requires an access to addressbook in order to be usable Goto Setting >> KittyBee >> allow access to contact " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [Alert show];
        
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
}
- (void)getAllContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    NSMutableDictionary * details=[[NSMutableDictionary alloc]init];
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            //contacts.firstNames = [(__bridge NSString*)firstName copy];
            NSString *FirstName=[(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            //contacts.lastNames = [(__bridge NSString*)lastName copy];
            NSString *LastName=[(__bridge NSString*)lastName copy];
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            if (!FirstName) {
                FirstName = @"";
            }
            if (!LastName) {
                LastName = @"";
            }
            
            //contacts.contactId = ABRecordGetRecordID(person);
            
            //append first name and last name
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", FirstName, LastName];
            
            // get contacts picture, if pic doesn't exists, show standart one
            //            CFDataRef imgData = ABPersonCopyImageData(person);
            //            NSData *imageData = (__bridge NSData *)imgData;
            //            contacts.image = [UIImage imageWithData:imageData];
            //
            //            if (imgData != NULL) {
            //                CFRelease(imgData);
            //            }
            //
            //            if (!contacts.image) {
            //                contacts.image = [UIImage imageNamed:@"avatar.png"];
            //            }
            
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            //            [details setObject:strFullName forKey:@"ContactName"];
            //            [details setObject:phoneNumbers forKey:@"phoneNumbers"];
            NSMutableArray *countryCode=[[NSMutableArray alloc]init];
            //NSMutableArray *MobNo=[[NSMutableArray alloc]init];
            for(int i=0; i<phoneNumbers.count; i++){
                
                NSString *strOrignalNumber=[phoneNumbers objectAtIndex:i];
                NSString *strRealNumber = [[strOrignalNumber componentsSeparatedByCharactersInSet:
                                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                           componentsJoinedByString:@""];
                if(strRealNumber.length<10){
                    continue;
                }
                NSString *strNumberwithOutCountryCOde = [strRealNumber substringFromIndex: [strRealNumber length] - 10];
                NSString *strContryCode=[strRealNumber stringByReplacingOccurrencesOfString:strNumberwithOutCountryCOde withString:@""];
                [countryCode addObject:strContryCode];
                [details setObject:strFullName forKey:strNumberwithOutCountryCOde];
                //[MobNo addObject:strNumberwithOutCountryCOde];
            }
            

            //[details setObject:countryCode forKey:@"CountryCode"];
            //[details setObject:MobNo forKey:@"ContactNumber"];
            
            //          //  get Contact email
            //                        NSMutableArray *contactEmails = [NSMutableArray new];
            //                        ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            //
            //                        for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
            //                            @autoreleasepool {
            //                                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
            //                                NSString *contactEmail = CFBridgingRelease(contactEmailRef);
            //                                if (contactEmail != nil)[contactEmails addObject:contactEmail];
            //                                // NSLog(@"All emails are:%@", contactEmails);
            //                            }
            //                        }
            //
            //                        if (multiPhones != NULL) {
            //                            CFRelease(multiEmails);
            //                        }
            //
            //                        [contacts setEmails:contactEmails];


#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);//phone
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone= [defaults objectForKey:@"phone"];
    [details setObject:phone forKey:@"number"];
    
    [items addObject:details];
    arryContact=items;
    [self addMemberContact];
    NSLog(@"%@",items);
}

-(void)addMemberContact{
    
    if(arryContact.count>0){
        [self.view addSubview:ind];
        NSMutableDictionary *contact=[arryContact objectAtIndex:0];
        [contact setObject:self.groupId forKey:@"group_id"];
        [[ApiClient sharedInstance]addMembers:contact success:^(id responseObject) {
            [ind removeFromSuperview];
            NSDictionary *dict=responseObject;
            strCatagory=[dict objectForKey:@"category"];
            dictContact=[dict objectForKey:@"data"];
            searchResults  =[dictContact mutableCopy];
            for (int i=0; i<searchResults.count; i++) {
                [arryRowValue addObject:[NSString stringWithFormat:@"%d",i]];
            }
            if([strCatagory isEqualToString:@"Couple Kitty"]){
                unPaired=[dict objectForKey:@"upaired"];
            }
            
            [self.tblNewMember reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
            
            [ind removeFromSuperview];
            [AlertView showAlertWithMessage:errorString];
        }];
    }else{
        [AlertView showAlertWithMessage:@"Please give permission to fetch contact."];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchResults.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = nil;
    UITableViewCell * cell  = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:
            cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    NSDictionary *dict=[searchResults objectAtIndex:indexPath.row];
    AsyncImageView *banner=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10,40,40)];
    banner.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
    banner.showActivityIndicator=YES;
    NSString *strURL=[dict objectForKey:@"image"];
    strURL=[strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    banner.imageURL=[NSURL URLWithString:strURL];
    banner.clipsToBounds=YES;
    [banner setContentMode:UIViewContentModeScaleAspectFill];
    banner.layer.cornerRadius=20;
    [cell.contentView addSubview:banner];
    
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 160, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=2;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font = [UIFont fontWithName:@"GothamMedium" size:14];
    lblName.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblName.text=[dict objectForKey:@"name"];
    lblName.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblName];
    
    UILabel *lblList=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 200, 25)];
    lblList.backgroundColor=[UIColor clearColor];
    lblList.numberOfLines=2;
    lblList.lineBreakMode=NSLineBreakByWordWrapping;
    lblList.font = [UIFont fontWithName:@"GothamBook" size:11];
    lblList.textColor= [UIColor colorWithRed:0/255.0 green:42/255.0 blue:65/255.0 alpha:1.0];
    lblList.text=[dict objectForKey:@"phone"];
    lblList.alpha=0.5;
    lblList.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblList];
    
    if([[dict objectForKey:@"in_group"] isEqualToString:@"0"]){
        AsyncImageView *checkImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-37, 20,19,19)];
        checkImage.activityIndicatorStyle=UIActivityIndicatorViewStyleGray;
        //    if ([selectedData containsIndex:indexPath.row]){
        //
        //        checkImage.image=[UIImage imageNamed:@"check"];
        //    }else{
        //         checkImage.image=[UIImage imageNamed:@"uncheck"];
        //    }
        [checkImage setContentMode:UIViewContentModeScaleAspectFill];
        
        if([searchBar.text isEqualToString:@""]){
            
            
            if ([arrySelectedValue containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
                checkImage.image=[UIImage imageNamed:@"check"];
            }else {
                checkImage.image=[UIImage imageNamed:@"uncheck"];
                
                
            }
        }else{
            if(!(arrySelectedValue.count>0)){
                checkImage.image=[UIImage imageNamed:@"uncheck"];
            }
            for(int i=0; i<arrySelectedValue.count;i++){
                
                if ([arryRowValue containsObject:[arrySelectedValue objectAtIndex:i]]) {
                    NSInteger indexVal=[arryRowValue indexOfObject:[arrySelectedValue objectAtIndex:i]];
                    NSLog(@"%ld",(long)indexPath.row);
                    if(indexPath.row==indexVal){
                        checkImage.image=[UIImage imageNamed:@"check"];
                        break;
                    }else{
                        checkImage.image=[UIImage imageNamed:@"uncheck"];
                    }
                }else{
                    checkImage.image=[UIImage imageNamed:@"uncheck"];
                }
            }
        }
        
        [cell.contentView addSubview:checkImage];
    }else{
        cell.userInteractionEnabled=NO;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    if([self.txtGroupName isFirstResponder])
//    {
//        [self.view endEditing:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([arrySelectedValue containsObject:[arryRowValue objectAtIndex:indexPath.row]]) {
        
        [arrySelectedValue removeObject:[arryRowValue objectAtIndex:indexPath.row]];
        
        
        
        // [selectedData removeIndex:indexPath.row];
        
    }else{
        
        [arrySelectedValue addObject:[arryRowValue objectAtIndex:indexPath.row]];
        // [selectedData addIndex:indexPath.row];
    }
    [self.tblNewMember reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fotterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIButton *btnnext = [[UIButton alloc]initWithFrame:fotterView.frame];
    [btnnext addTarget:self
                action:@selector(cmdNext:)
      forControlEvents:UIControlEventTouchUpInside];
    btnnext.titleLabel.font = [UIFont fontWithName:@"GothamMedium" size:14];
    [btnnext setBackgroundColor:[UIColor colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1.0]];
    if(!([strCatagory isEqualToString:@"Normal Kitty"])){
        [btnnext setTitle:@"NEXT" forState:UIControlStateNormal];
    }else{
        [btnnext setTitle:@"DONE" forState:UIControlStateNormal];
    }
    
    [fotterView addSubview:btnnext];
    return fotterView;
    
}

-(void)cmdNext:(id)sender{
    
    NSMutableArray * mutableArr = [[NSMutableArray alloc]init];
    for (int i=0; i<arrySelectedValue.count; i++) {
        NSDictionary *dataDict=[dictContact objectAtIndex:[[arrySelectedValue objectAtIndex:i] integerValue]];
        [mutableArr addObject:dataDict];
    }
    PaidOrNotViewController *controller = [[PaidOrNotViewController alloc] initWithNibName:@"PaidOrNotViewController" bundle:nil];
    if([strCatagory isEqualToString:@"Normal Kitty"]){
        controller.arryGroupMember=mutableArr;
        controller.groupId=self.groupId;
        controller.catagory= strCatagory;
    }else if([strCatagory isEqualToString:@"Kitty with Kids"]){
        controller.arryGroupMember=mutableArr;
        controller.groupId=self.groupId;
        controller.catagory= strCatagory;
        
    }else  if([strCatagory isEqualToString:@"Couple Kitty"]){

        controller.arryGroupMember=mutableArr;
        if(unPaired.count>0){
            controller.unpairedMember=unPaired;
        }
        controller.groupId=self.groupId;
         controller.catagory= strCatagory;
       
    }
     [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)AddSelectedMember{
//   // [self.view addSubview:ind];
//    NSMutableArray * mutableArr = [[NSMutableArray alloc]init];
//    for (int i=0; i<arrySelectedValue.count; i++) {
//        NSDictionary *dataDict=[dictContact objectAtIndex:[[arrySelectedValue objectAtIndex:i] integerValue]];
//        [mutableArr addObject:dataDict];
//    }
//    
//    PaidOrNotViewController *controller = [[PaidOrNotViewController alloc] initWithNibName:@"PaidOrNotViewController" bundle:nil];
//    controller.arryGroupMember=mutableArr;
//    controller.groupId=self.groupId;
//     controller.catagory= strCatagory;
//    [self.navigationController pushViewController:controller animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(showSearch)
        return 50;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    if(showSearch)
        headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 0);
    if(!(searchBar)){
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.delegate=self;
        searchBar.returnKeyType=UIReturnKeyDone;
        searchBar.placeholder=@"Search Contacts";
        [searchBar setShowsCancelButton:NO];
    }
    [searchBar becomeFirstResponder];
    [headerView addSubview:searchBar];
    return headerView;
    
}

#pragma mark searchbar
-(void)searchBar:(UISearchBar*)searchbar textDidChange:(NSString*)text
{
    if ([text length] == 0)
    {
        searchResults=[dictContact mutableCopy];
        [self.tblNewMember reloadData];
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
        [self viewDown];
    }else{
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.frame=CGRectMake(self.view.frame.origin.x, -65, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
    }
    [arryRowValue removeAllObjects];
    arryRowValue=nil;
    [searchResults removeAllObjects];
    searchResults=nil;
    searchResults=[[NSMutableArray alloc]init];
    arryRowValue=[[NSMutableArray alloc]init];
    for (int i=0; i<dictContact.count; i++) {
        NSDictionary *Dict=[dictContact objectAtIndex:i];
        NSString *strName=[Dict objectForKey:@"name"];
        NSRange nameRange = [strName rangeOfString:text options:NSCaseInsensitiveSearch];
        NSRange descriptionRange = [strName rangeOfString:text options:NSCaseInsensitiveSearch];
        
        NSRange textrange=[searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
        NSRange descriptionRangetxt = [searchBar.text rangeOfString:text options:NSCaseInsensitiveSearch];
        
        if(nameRange.location == textrange.location || descriptionRange.location == descriptionRangetxt.location)
        {
            [arryRowValue addObject:[NSString stringWithFormat:@"%d",i]];
            [searchResults addObject:Dict];
            
        }
    }
    
    [self.tblNewMember  reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
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



@end
