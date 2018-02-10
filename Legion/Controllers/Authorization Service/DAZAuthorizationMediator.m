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
#import "VKAccessToken.h"

@interface DAZAuthorizationMediator () <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@implementation DAZAuthorizationMediator

- (void)processAuthorizationURL:(NSURL *)url {
    [self.vkontakteAuthorizationService processAuthorizationURL:(NSURL *)url];
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

#pragma mark - DAZAuthorizationServiceDelegate

- (void)authorizationServiceDidFinishSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error
{
    if (!profile) {
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:nil error:error];
        }
    }
    
    if (profile.authorizationType == DAZAuthorizationVkontakte)
    {
        [self.firebaseAuthorizationService signInWithUserID:profile.userID];
    }
    else if (profile.authorizationType == DAZAuthorizationAnonymously)
    {
        FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
        changeRequest.displayName = @"Дмитрий Жаров";
        //changeRequest.displayName = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
        //changeRequest.photoURL = profile.photoURL;
        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
            NSLog(@"Updated data");
        }];
        
        if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
        {
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:error];
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
