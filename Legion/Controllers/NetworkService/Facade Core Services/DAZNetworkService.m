//
//  DAZNetworkService.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>

#import "DAZNetworkService.h"
//#import "DAZCoreDataManager.h"

#import "PartyMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"

typedef void (^URLSessionCompletionBlock)(NSData * _Nullable data,
                                         NSURLResponse * _Nullable response,
                                         NSError * _Nullable error);

static NSString *const baseURL = @"https://us-central1-legion-svc.cloudfunctions.net/";

static NSString *const downloadParties = @"getParties";
static NSString *const uploadParty = @"addParty";
static NSString *const deleteParty = @"deleteParty";
static NSString *const downloadClaims = @"getClaims";

@interface DAZNetworkService ()

//@property (strong, readonly) DAZCoreDataManager* coreDataManager;
@property (nonatomic, strong) id<NSObject> firebaseAuthorizationStateDidChangeHandler;

@end

@implementation DAZNetworkService

#pragma mark - Lifecycle

//- (instancetype)initWithCoreDataManager:(DAZCoreDataManager *)manager
//{
//    self = [super init];
//    if (self) {
//        _coreDataManager = manager;
//    }
//    return self;
//}

#pragma - Firebase Network Service

- (void)downloadParties {
#warning TODO - Implement latest party date check
    NSTimeInterval lastUpdate = 0;
    NSDictionary *parameters = @{@"lastUpdate" : @(lastUpdate).stringValue};
    
    [self dataTaskWithFunction:downloadParties
                    parameters:parameters
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
                  if (!error) {
                      NSDictionary *responseDictionary = [NSJSONSerialization
                                                          JSONObjectWithData:data
                                                          options:0
                                                          error:&error];
                      NSLog(@"Error occured during parsing - %@", error);
                      #warning TODO - Add to Core Data method for extract Array from NSData
                      [self.delegate networkServiceDidFinishDownloadParties:nil];
                  }
              }];
}

- (void)uploadParty:(PartyMO *)party {
    NSDictionary *parameters = @{};
    
    [self dataTaskWithFunction:uploadParty
                    parameters:parameters
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
                  if (!error) {
                      NSDictionary *responseDictionary = [NSJSONSerialization
                                                          JSONObjectWithData:data
                                                          options:0
                                                          error:&error];
                      NSLog(@"Error occured during parsing - %@", error);
#warning TODO - Add to Core Data method for extract Array from NSData
                      [self.delegate networkServiceDidFinishDownloadParties:nil];
                  }
              }];
}

- (void)deleteParty:(PartyMO *)party {
    
}

- (void)downloadClaims {
#warning TODO - Implement latest party date check
    NSTimeInterval lastUpdate = 0;
    NSDictionary *parameters = @{@"lastUpdate" : @(lastUpdate).stringValue};
    
    [self dataTaskWithFunction:downloadClaims
                    parameters:parameters
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
                  if (!error) {
                      NSDictionary *responseDictionary = [NSJSONSerialization
                                                          JSONObjectWithData:data
                                                          options:0
                                                          error:&error];
                      NSLog(@"Error occured during parsing - %@", error);
#warning TODO - Add to Core Data method for extract Array from NSData
                      [self.delegate networkServiceDidFinishDownloadClaims:nil];
                  }
              }];
}

- (void)dataTaskWithFunction:(NSString *)function
                     parameters:(NSDictionary *)parameters
               completionHanler:(URLSessionCompletionBlock)completionHandler
{
    [[FIRAuth auth].currentUser getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            NSError *dictionaryError;
            NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&dictionaryError];
    
            NSURLSession *session = [NSURLSession sharedSession];
    
            NSString *absoluteURL =
                [NSString stringWithFormat:@"%@%@", baseURL, function];
    
            NSURL *url = [NSURL URLWithString:absoluteURL];
    
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPBody = body;
            request.HTTPMethod = @"POST";
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:completionHandler];
            [postDataTask resume];
    }];
}

@end
