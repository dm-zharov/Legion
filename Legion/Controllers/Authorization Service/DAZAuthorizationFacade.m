//
//  DAZAuthorizationFacade.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZAuthorizationFacade.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"

#import "DAZUserProfile.h"


@interface DAZAuthorizationFacade () <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end


@implementation DAZAuthorizationFacade

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
    }
}

- (void)signOut
{
    [self.firebaseAuthorizationService signOut];
}


#pragma mark - Public

- (BOOL)processAuthorizationURL:(NSURL *)url
{
    if (!url)
    {
        return NO;
    }
    
    return [self.vkontakteAuthorizationService processAuthorizationURL:(NSURL *)url];
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
    else if (profile.authorizationType == DAZAuthorizationAnonymously)
    {
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:nil];
        }
    };
}

- (void)authorizationServiceDidFinishSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        [self.delegate authorizationServiceDidFinishSignOut];
    }
}

@end
