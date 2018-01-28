//
//  DAZMediatorAuthorizationService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZMediatorAuthorizationService.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"

@interface DAZMediatorAuthorizationService ()

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@implementation DAZMediatorAuthorizationService

+ (void)configureService {
    [DAZFirebaseAuthorizationService configureService];
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

- (BOOL)processURL:(NSURL *)url {
    [self.vkontakteAuthorizationService processURL:url];
    
    return YES;
}

- (void)signInWithAuthType:(DAZAuthorizationType)authType {
    if (authType == DAZAuthorizationVkontakte) {
        [self signInWithVkontakte];
    }
    
    if (authType == DAZAuthorizationAnonymously) {
        [self signInAnonymously];
    }
    
}

- (void)signInWithVkontakte {
    [self.vkontakteAuthorizationService signIn];
}

- (void)signInAnonymously {
    [self.firebaseAuthorizationService signInAnonymously];
}

- (BOOL)isLoggedIn {
 
    return YES;
}

- (void)signOut {
    
}

- (void)authorizationDidFinishWithResult:(id)result {
    
}

- (void)authorizationDidFinishWithError:(NSError *)error {
    
}

- (void)authorizationDidFinishSignOutProcess {
    
}

@end
