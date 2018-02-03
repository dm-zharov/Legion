//
//  DAZNetworkService.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>
#import "AppDelegate.h"
#import "DAZNetworkService.h"
#import "DAZCoreDataManager.h"


typedef void (^URLSessionCompletionBlock)(NSData * data, NSURLResponse *response, NSError *error);


static NSString *const baseURL = @"https://us-central1-legion-svc.cloudfunctions.net/";
static NSString *const downloadParties = @"getParties";
static NSString *const uploadParty = @"addParty";
static NSString *const deleteParty = @"deleteParty";
static NSString *const downloadClaims = @"getClaims";


@interface DAZNetworkService ()

@end

@implementation DAZNetworkService

#pragma mark - Firebase Network Service

- (void)downloadParties
{
    [self dataTaskWithFunction:downloadParties
                    dictionary:nil
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (!error) {
          NSArray *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate networkServiceDidFinishDownloadParties:responseDictionary];
            });
        }
    }];
}

- (void)uploadParty:(PartyMO *)party
{
    NSDictionary *parameters = @{};
    
    [self dataTaskWithFunction:uploadParty
                    dictionary:parameters
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
                  if (!error) {
//                      NSDictionary *responseDictionary = [NSJSONSerialization
//                                                          JSONObjectWithData:data
//                                                          options:0
//                                                          error:&error];
                      NSLog(@"Error occured during parsing - %@", error);
                      [self.delegate networkServiceDidFinishDownloadParties:nil];
                  }
              }];
}

- (void)deleteParty:(PartyMO *)party
{
    
}

- (void)downloadClaims
{
    NSTimeInterval lastUpdate = 0;
    NSDictionary *parameters = @{@"lastUpdate" : @(lastUpdate).stringValue};
    
    [self dataTaskWithFunction:downloadClaims
                    dictionary:parameters
              completionHanler:^(NSData * data, NSURLResponse * response, NSError * error) {
                  if (!error) {
//                      NSDictionary *responseDictionary = [NSJSONSerialization
//                                                          JSONObjectWithData:data
//                                                          options:0
//                                                          error:&error];
                      NSLog(@"Error occured during parsing - %@", error);
                      [self.delegate networkServiceDidFinishDownloadClaims:nil];
                  }
              }];
}

- (void)uploadClaim:(NSDictionary *)claimDictionary {
    
}

- (void)deleteClaim:(ClaimMO *)party
{
    
}

- (void)dataTaskWithFunction:(NSString *)function
                     dictionary:(NSDictionary *)parameters
               completionHanler:(URLSessionCompletionBlock)completionHandler
{
    [[FIRAuth auth].currentUser getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        
        if (!token) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
        }

        NSURLSession *session = [NSURLSession sharedSession];

        NSString *absoluteURL =
            [NSString stringWithFormat:@"%@%@", baseURL, function];

        NSURL *url = [NSURL URLWithString:absoluteURL];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString* bearer = [NSString stringWithFormat:@"Bearer %@", token];
        [request setValue:bearer forHTTPHeaderField:@"Authorization"];
        
        if (parameters)
        {
            NSError *dictionaryError;
            NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&dictionaryError];
            request.HTTPBody = body;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        request.HTTPMethod = @"POST";

        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:completionHandler];
        [postDataTask resume];
    }];
}

- (void)networkServiceDidFinishDownloadParties:(NSDictionary *)partiesDictionary {
    
}

- (void)networkServiceDidFinishDownloadClaims:(NSDictionary *)claimsDictionary {
    
}

@end
