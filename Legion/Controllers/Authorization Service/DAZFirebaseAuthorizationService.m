//
//  DAZFirebaseAuthorizationService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>
#import "DAZFirebaseAuthorizationService.h"
#import "DAZUserProfile.h"
#import "NSError+Domains.h"

static NSString *const DAZServerBaseURL = @"https://us-central1-legion-svc.cloudfunctions.net/";
static NSString *const DAZFunctionAuthWithUserID = @"authWithUserID";

@implementation DAZFirebaseAuthorizationService


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
    if (authorizationType == DAZAuthorizationAnonymously)
    {
        [self signInAnonymously];
    }
    else
    {
        NSError *error = [[NSError alloc]
            initWithDomain:@"Ошибка авторизации: данный способ авторизации не поддерживается провайдером \"Firebase\"."
                      code:0
                  userInfo:nil];
        [self completedSignInWithProfile:nil error:error];
    }
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


#pragma mark - Public

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
        [self completedSignInWithProfile:nil error:error];
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZServerBaseURL, DAZFunctionAuthWithUserID];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *customTokenTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // Мы получили токен для авторизации на сервере "Firebase", теперь можно осуществить вход.
            [self signInWithCustomToken:token];
        }
        else
        {
            [self completedSignInWithProfile:nil error:error];
        }
    }];
    [customTokenTask resume];
}

- (void)signInAnonymously
{
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *user, NSError *error) {
        if (!error)
        {
            DAZUserProfile *profile = [[DAZUserProfile alloc] init];
            profile.authorizationType = DAZAuthorizationAnonymously;
            profile.userID = user.uid;
            profile.firstName = @"Анонимный";
            profile.lastName = @"пользователь";
            
            [self completedSignInWithProfile:profile error:nil];
        }
        else
        {
            [self completedSignInWithProfile:nil error:error];
        }
    }];
}

- (void)setDisplayName:(NSString *)displayName avatarURL:(NSURL *)url
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


#pragma mark - Private

- (void)signInWithCustomToken:(NSString *)token
{
    [[FIRAuth auth] signInWithCustomToken:token completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (!error)
        {
            [self processSignInWithCustomToken];
        }
        else
        {
            [self completedSignInWithProfile:nil error:error];
        }
    }];
}

/**
 * Обновляем данные пользователя на сервере "Firebase" с помощью данных профиля, так как
 * после последней авторизации они могли претерпеть изменения. На данном этапе авторизация уже завершена.
 */
- (void)processSignInWithCustomToken
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    // "Firebase" не различает способы авторизации: разница состоит лишь количестве получаемых персональных данных.
    profile.authorizationType = DAZAuthorizationAnonymously;
    
    if (profile.fullName)
    {
        [self setDisplayName:profile.fullName avatarURL:profile.photoURL];
    }
    
    [self completedSignInWithProfile:profile error:nil];
    
}


#pragma mark - DAZAuthorizationServiceDelegate

- (void)completedSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:error];
        });
    }
}

- (void)completedSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate authorizationServiceDidFinishSignOut];
        });
    }
}

@end
