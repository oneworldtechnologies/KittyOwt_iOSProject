//
//  ApiClient.m
//  MyVideoTech
//
//  Created by OSX on 13/01/16.
//  Copyright (c) 2016 OremTech. All rights reserved.
//

#import "ApiClient.h"

@implementation ApiClient
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}
- (AFHTTPRequestOperationManager*) getAFHTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    return manager;
}



- (void)getLogin:(NSString *)userName password:(NSString *)password success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@BASEURl];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}
//get profile
- (void)getProfile:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@PROFILE];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//get other profile
- (void)getOtherProfile:(NSString *)otherProfileID success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *url = [NSString stringWithFormat:@PROFILE];
    url=[NSString stringWithFormat:@"%@%@",url,otherProfileID];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//edit profile
- (void)editProfile:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@EDITPROFILE];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    
   
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Artical
- (void)getArtical:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url=[NSString stringWithFormat:@GETARTICLE];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//mobileNumber

- (void)sendMobleNum:(NSDictionary *)editdic success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@MOBNUM];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//OTP
- (void)checkOTP:(NSDictionary *)editdic success:(void (^)(id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@OTP];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// register
- (void)getRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@REGISTER];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


// FBregister
- (void)getFBRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@FBREGISTER];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}



// Gmailregister
- (void)getGmailRegister:(NSDictionary *)editdic success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@GMAILREGISTER];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// Add Contact
- (void)addContact:(NSDictionary *)editdic success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];

    NSString *url = [NSString stringWithFormat:@ADDCONTACT];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// invite
- (void)invite:(NSDictionary *)editdic success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
  
    NSString *url = [NSString stringWithFormat:@INVITE];
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}
// PERMOTIONAL LISTING
- (void)permotionalListing:(NSString *)ID success:(void (^)(id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@PERMOTIONALLISTING];
    url=[NSString stringWithFormat:@"%@%@",url,ID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// Add Group
- (void)addGroup:(NSDictionary *)editdic success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@ADDGROUP];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// GET Group
- (void)getGroup:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@GETGROUP];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}
//addNote
- (void)addNotes:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    
    NSString *url = [NSString stringWithFormat:@ADDNOTES];
   
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//GetNote
- (void)getNotes:(NSDictionary *)editdic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *url = [NSString stringWithFormat:@GETNOTES];
    
    [manager POST:url parameters:editdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//delete Notes
- (void)deleteNotes:(NSString *)noteId success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSString *url = [NSString stringWithFormat:@DELETENOTES];
    url=[NSString stringWithFormat:@"%@%@",url,noteId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Get Rules
- (void)getRules:(NSString *)noteId success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GETRULES];
    url=[NSString stringWithFormat:@"%@%@",url,noteId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//Get Rules
- (void)updateRules:(NSString *)noteId dict:(NSDictionary *)dict success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@UPDATERULES];
    url=[NSString stringWithFormat:@"%@%@",url,noteId];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//Get Venue
- (void)getVenue:(NSString *)kittyId success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GETVENUE];
    url=[NSString stringWithFormat:@"%@%@",url,kittyId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Set Venue
- (void)setVeneu:(NSDictionary *)venu success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSString *url = [NSString stringWithFormat:@SETVENUE];
    
    [manager POST:url parameters:venu success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


// UPDATE venu
- (void)updateVenue:(NSDictionary *)Venudic success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    NSString *idd=[Venudic objectForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@UPDATEVENUE];
    url=[NSString stringWithFormat:@"%@%@",url,idd];
    [manager POST:url parameters:Venudic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Get DIARIES
- (void)getDiaries:(NSString *)diaries success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@DIARIES];
    url=[NSString stringWithFormat:@"%@%@",url,diaries];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Submit DIARIES
- (void)submitDiaries:(NSDictionary *)diaries success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@SUBMITDIARIES];
   
    [manager POST:url parameters:diaries success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}
// Host List
- (void)hostList:(NSString *)groupId success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@HOSTLIST];
    url=[NSString stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Send Next HOST
- (void)selectHost:(NSString *)groupId dict:(NSDictionary *)hostValue success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@SELECTHOST];
    url =[NSString  stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:hostValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

// GET Calander
- (void)getCalander:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@CALANDER];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//BANNAR
- (void)getBanner:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@BANNAR];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//ADD BILL
- (void)addBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@ADDBILL];
    
    [manager POST:url parameters:diaries success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//EDIT BILL
- (void)editBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@EDITBILL];
    
    [manager POST:url parameters:diaries success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//GET BILL
- (void)getBill:(NSDictionary *)diaries success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GETBILL];
    
    [manager POST:url parameters:diaries success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//SETTING
- (void)getSetting:(NSString *)groupId success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@SETTING];
    url=[NSString stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Update GroupImage
- (void)updateGroupImage:(NSString *)groupId dict:(NSDictionary *)dict success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@UPDATEGROUPIMAGE];
    url=[NSString stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Add QB Data
- (void)addQBdata:(NSDictionary *)QBUser success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [ NSString stringWithFormat:@ADDQBDATA];
    
    [manager POST:url parameters:QBUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


// get NOTIFICATION
- (void)getNotification:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *USERID = [prefs stringForKey:@"USERID"];
    
    NSString *url = [NSString stringWithFormat:@NOTIFICATION];
    url=[NSString stringWithFormat:@"%@%@",url,USERID];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//Delete notification
- (void)deleteNotification:(NSDictionary *)notify success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@DELETENOTIFICATION];
   
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//add attandance
- (void)addAttandance:(NSDictionary *)notify success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *url = [NSString stringWithFormat:@ADDATTANDANCE];
    
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//get Attandance
- (void)getAttandance:(NSDictionary *)notify success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GETATTANDANCE];
    
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//Add members
- (void)addMembers:(NSDictionary *)notify success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@ADDMEMBER];
    
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Add selected Member
- (void)addSelectedMembers:(NSDictionary *)notify success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@ADDSELECTEDMEMBER];
    
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Give Right to edit
- (void)giveRightToEdit:(NSDictionary *)notify success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GIVERIGHTTOEDIT];
    
    [manager POST:url parameters:notify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//Delete Group or refresh Group
- (void)deleteGroup:(NSString *)groupId deleteYesOrNo:(NSDictionary *)deleteYesOrNo success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@DELETEGROUP];
    url=[NSString stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:deleteYesOrNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


//delete member
- (void)deleteMember:(NSDictionary *)memberData success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@DELETEMEMBER];
    
    [manager POST:url parameters:memberData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

//GetNonKittyMember
- (void)getNonKittyMember:(NSString *)groupId success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@GETNONKITTYMEMBER];
    url=[NSString stringWithFormat:@"%@%@",url,groupId];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!([self checkResponce:responseObject])){
            NSDictionary *dict=responseObject;
            failure(nil,[dict objectForKey:@"message"]);
        }else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}


-(BOOL)checkResponce:(id)responceObject{
    
    NSDictionary *dict=responceObject;
    NSString *responce=[NSString stringWithFormat:@"%@",[dict objectForKey:@"response"]];
    if([responce isEqualToString:@"0"]){
        return FALSE;
    }
    return YES;
}
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
