//
//  DAZAuthorizationMediator.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZAuthorizationMediator.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"

#import "VKAccessToken.h"
#import <Firebase.h>

@interface DAZAuthorizationMediator () <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@implementation DAZAuthorizationMediator

- (void)openURL:(NSURL *)url {
    [self.vkontakteAuthorizationService processURL:(NSURL *)url];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _vkontakteAuthorizationService = [[DAZVkontakteAuthorizationService alloc] initWithMediator:self];
        _firebaseAuthorizationService = [[DAZFirebaseAuthorizationService alloc] initWithMediator:self];
    }
    
    return self;
}

- (BOOL)isLoggedIn
{
    return [self.firebaseAuthorizationService isLoggedIn];
    
    return YES;
}

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType
{
    switch (authorizationType)
    {
        case DAZAuthorizationVkontakte:
            [self.vkontakteAuthorizationService signInWithAuthorizationType:DAZAuthorizationVkontakte];
            break;
        case DAZAuthorizationAnonymously:
            [self.firebaseAuthorizationService signInWithAuthorizationType:DAZAuthorizationAnonymously];
            break;
        default:
        {
            NSError *error = [[NSError alloc]
                initWithDomain:@"Ошибка авторизации: неверный тип авторизации." code:0 userInfo:nil];
            [self authorizationServiceDidFinishSignInWithResult:nil error:error];
            break;
        }
    }
    
}

- (void)signOut
{
    [self.firebaseAuthorizationService signOut];
}

#pragma mark - DAZAuthorizationServiceDelegate

- (void)authorizationServiceDidFinishSignInWithResult:(id)result error:(NSError *)error
{
    if ([result isKindOfClass:[VKAccessToken class]])
    {
        VKAccessToken *accessToken = (VKAccessToken *)result;
        [self.firebaseAuthorizationService signInWithUserID:accessToken.userId];
    }
    else if ([result isKindOfClass:[FIRUser class]]) {
        [self.delegate authorizationServiceDidFinishSignInWithResult:result error:error];
    }
}

- (void)authorizationServiceDidFinishSignOutProcess
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        [self.delegate authorizationServiceDidFinishSignOut];
    }
}

@end
