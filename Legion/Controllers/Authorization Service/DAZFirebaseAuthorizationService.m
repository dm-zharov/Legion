//
//  DAZFirebaseAuthService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>

#import "DAZFirebaseAuthorizationService.h"
#import "NSError+Domains.h"

#import "DAZUserProfile.h"


static NSString *const DAZServerBaseURL = @"https://us-central1-legion-svc.cloudfunctions.net/";
static NSString *const DAZFunctionAuthWithUserID = @"authWithUserID";

@implementation DAZFirebaseAuthorizationService

#pragma mark - Instance Accessors

+ (void)setDisplayName:(NSString *)displayName avatarURL:(NSURL *)url
{
    if (!displayName)
    {
        return;
    }
    
    FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
    changeRequest.displayName = displayName;
    
    if (url)
    {
        changeRequest.photoURL = url;
    }
    
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error)
        {
            NSLog(@"Ошибка обновления данных пользователя %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
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

- (void)signInWithUserID:(NSString *)userID
{
    if (!userID)
    {
        return;
    }
    
    NSError *error;
    NSDictionary *json = @{ @"userID" : userID };
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    
    if (!bodyData)
    {
        [self completedSignInWithResult:nil error:error];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZServerBaseURL, DAZFunctionAuthWithUserID];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self signInWithCustomToken:token];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self completedSignInWithResult:nil error:error];
            });
        }
    }];
    [postDataTask resume];
}

- (void)signInWithCustomToken:(NSString *)token
{
    [[FIRAuth auth] signInWithCustomToken:token completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (!error)
        {
            [self completedSignInWithResult:user error:nil];
        }
        else
        {
            [self completedSignInWithResult:nil error:error];
        }
    }];
}

- (void)signInAnonymously
{
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

#pragma mark - DAZAuthorizationServiceDelegate

- (void)completedSignInWithResult:(FIRUser *)user error:(NSError *)error
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    profile.authorizationType = DAZAuthorizationAnonymously;
    
    if (!error)
    {
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:error];
        }
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
