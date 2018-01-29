//
//  DAZFirebaseAuthService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>

#import "DAZFirebaseAuthorizationService.h"

@implementation DAZFirebaseAuthorizationService

+ (void)configureService {
    [FIRApp configure];
}

- (instancetype)initWithMediator:(id)mediator
{
    if (self = [super init])
    {
        _delegate = mediator;
    }
    
    return self;
}

- (void)signInWithUserID:(NSString *)uid
{
    NSDictionary *jsonData = @{@"uid" : uid};
    
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://us-central1-legion-svc.cloudfunctions.net/authWithUserID"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [self signInWithCustomToken:token];
        }
        
    }];
    [postDataTask resume];
}

- (void)signInWithCustomToken:(NSString *)token {
    [[FIRAuth auth] signInWithCustomToken:token completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            [self.delegate authorizationDidFinishWithResult:user];
        }
    }];
}

- (void)signInAnonymously {
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        if (!error) {
            [self.delegate authorizationDidFinishWithResult:user];
        }
    }];
}

@end
