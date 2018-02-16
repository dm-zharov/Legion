//
//  DAZAuthorizationMediator.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>
#import "DAZAuthorizationMediator.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"
#import "DAZUserProfile.h"

@interface DAZAuthorizationMediator () <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@implementation DAZAuthorizationMediator


#pragma mark - Lifecycle

- (instancetype)init
{
    if (self = [super init])
    {
        _vkontakteAuthorizationService = [[DAZVkontakteAuthorizationService alloc] initWithMediator:self];
        _firebaseAuthorizationService = [[DAZFirebaseAuthorizationService alloc] initWithMediator:self];
    }
    return self;
}


#pragma mark - DAZAuthorizationServiceProtocol

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType
{
    switch (authorizationType)
    {
        case DAZAuthorizationVkontakte:
            [self.vkontakteAuthorizationService signIn];
            break;
        case DAZAuthorizationAnonymously:
            [self.firebaseAuthorizationService signInAnonymously];
            break;
        default:
        {
            NSError *error = [[NSError alloc]
                initWithDomain:@"Ошибка авторизации: отсутствующий способ авторизации." code:0 userInfo:nil];
            [self authorizationServiceDidFinishSignInWithProfile:nil error:error];
            break;
        }
    }
}

- (void)signOut
{
    [self.firebaseAuthorizationService signOut];
}


#pragma mark - Public

- (void)processAuthorizationURL:(NSURL *)url
{
    [self.vkontakteAuthorizationService processAuthorizationURL:(NSURL *)url];
}


#pragma mark - DAZAuthorizationServiceDelegate

- (void)authorizationServiceDidFinishSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error
{
    if (!profile) {
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:nil error:error];
        }
        return;
    }
    
    if (profile.authorizationType == DAZAuthorizationVkontakte)
    {
        /**
         * Перехватываем завершенную авторизацию через "ВКонтакте" и используем полученный по токену идентификатор
         * пользователя "ВКонтакте" в качестве ключа авторизации на сервере "Firebase".
         */
        [self.firebaseAuthorizationService signInWithUserID:profile.userID];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:nil];
        }
    }
}

- (void)authorizationServiceDidFinishSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        [self.delegate authorizationServiceDidFinishSignOut];
    }
}

@end
