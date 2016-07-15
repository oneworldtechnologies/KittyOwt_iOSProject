//
//  ApiClient.h
// Kitty App
//
//  
//  Copyright (c) 2016 Arun Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndecatorView.h"
@interface ApiClient : NSObject
+ (instancetype)sharedInstance;
- (void)getLogin:(NSString *)userName password:(NSString *)password success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;


//check Connection
- (BOOL)connected;
//GetProfile
- (void)getProfile:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//get other profile
- (void)getOtherProfile:(NSString *)otherProfileID success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//edit Profile
- (void)editProfile:(NSDictionary *)editdic success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Artical
- (void)getArtical:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//mobileNumber
- (void)sendMobleNum:(NSDictionary *)editdic success:(void (^)(id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//OTP
- (void)checkOTP:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// register
- (void)getRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

// FBregister
- (void)getFBRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

// Gmailregister
- (void)getGmailRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// Add Contact
- (void)addContact:(NSDictionary *)editdic success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// invite
- (void)invite:(NSDictionary *)editdic success:(void (^)(id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// PERMOTIONAL LISTING
- (void)permotionalListing:(NSString *)ID success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Add Group
- (void)addGroup:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// GET Group
- (void)getGroup:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//addNote
- (void)addNotes:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//getNote
- (void)getNotes:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//delete Notes
- (void)deleteNotes:(NSString *)noteId success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Get Rules
- (void)getRules:(NSString *)noteId success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Get Rules
- (void)updateRules:(NSString *)noteId dict:(NSDictionary *)dict success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Get Venue
- (void)getVenue:(NSString *)kittyId success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Set Venue
- (void)setVeneu:(NSDictionary *)venu success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

// UPDATE venu
- (void)updateVenue:(NSDictionary *)Venudic success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Get DIARIES
- (void)getDiaries:(NSString *)diaries success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Submit DIARIES
- (void)submitDiaries:(NSDictionary *)diaries success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

// Host List
- (void)hostList:(NSString *)groupId success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Send Next HOST
- (void)selectHost:(NSString *)groupId dict:(NSDictionary *)hostValue success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// GET Calander
- (void)getCalander:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//BANNAR
- (void)getBanner:(void (^)(id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//ADD BILL
- (void)addBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//EDIT BILL
- (void)editBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//GET BILL
- (void)getBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//SETTING
- (void)getSetting:(NSString *)groupId success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Update GroupImage
- (void)updateGroupImage:(NSString *)groupId dict:(NSDictionary *)dict success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Add QB Data
- (void)addQBdata:(NSDictionary *)QBUser success:(void (^)(id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
// get NOTIFICATION
- (void)getNotification:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Delete notification
- (void)deleteNotification:(NSDictionary *)notify success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//add attandance
- (void)addAttandance:(NSDictionary *)notify success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//get Attandance
- (void)getAttandance:(NSDictionary *)notify success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Add members
- (void)addMembers:(NSDictionary *)notify success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Add selected Member
- (void)addSelectedMembers:(NSDictionary *)notify success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//Give Right to edit
- (void)giveRightToEdit:(NSDictionary *)notify success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

//Delete Group or refresh Group
- (void)deleteGroup:(NSString *)groupId deleteYesOrNo:(NSDictionary *)deleteYesOrNo success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;


//delete member
- (void)deleteMember:(NSDictionary *)memberData success:(void (^)(id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
//GetNonKittyMember
- (void)getNonKittyMember:(NSString *)groupId success:(void (^)(id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
@end
