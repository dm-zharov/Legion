//
//  DAZFirebaseAuthService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>

#import "DAZFirebaseAuthorizationService.h"

static NSErrorDomain const DAZFirebaseServiceErrorDomain =
    @"Ошибка авторизации с помощью \"Firebase\": ошибка сети.";

@implementation DAZFirebaseAuthorizationService

+ (void)configureService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FIRApp configure];
    });
}


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithMediator:(id)mediator
{
    if (self = [self init])
    {
        _delegate = mediator;
    }
    
    return self;
}

#pragma mark - DAZAuthorizationServiceProtocol

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType
{
    if (authorizationType != DAZAuthorizationAnonymously) {
        return;
    } else if (authorizationType == DAZAuthorizationAnonymously) {
        [self signInAnonymously];
    }
}

- (void)signInWithUserID:(NSString *)uid
{
    NSDictionary *jsonData = @{@"uid" : uid};

    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    
    if (!bodyData)
    {
        [self completedSignInWithResult:nil error:error];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://us-central1-legion-svc.cloudfunctions.net/authWithUserID"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            [self signInWithCustomToken:token];
        }
        else
        {
            [self completedSignInWithResult:nil error:error];
        }
        
    }];
    [postDataTask resume];
}

- (void)signInWithCustomToken:(NSString *)token
{
    [[FIRAuth auth] signInWithCustomToken:token completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            [self completedSignInWithResult:user error:nil];
        } else {
            [self completedSignInWithResult:nil error:error];
        }
    }];
}

- (void)signInAnonymously
{
    [[FIRAuth auth] signOut:nil]; // Debug only.
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        if (!error) {
            [self completedSignInWithResult:user error:nil];
        } else {
            [self completedSignInWithResult:nil error:error];
        }
    }];
}

- (BOOL)isLoggedIn
{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedIn"];
    return !![FIRAuth auth].currentUser;
}

- (void)signOut
{
    NSError *error;
    if ([[FIRAuth auth] signOut:&error]) {
        [self completedSignOut];
    } else {
        NSLog(@"%@", error.domain);
    }
}

#pragma mark - Optional messages for DAZAuthorizationServiceDelegate

- (void)completedSignInWithResult:(FIRUser *)user error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithResult:error:)])
    {
        [self.delegate authorizationServiceDidFinishSignInWithResult:user error:error];
    }
}

- (void)completedSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        [self.delegate authorizationServiceDidFinishSignOut];
    }
}

@end
