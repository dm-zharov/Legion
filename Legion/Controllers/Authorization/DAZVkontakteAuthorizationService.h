//
//  DAZVkontakteAuthorizationService.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"
#import "DAZMediatorAuthorizationService.h"
#import "VKAccessToken.h"

@interface DAZVkontakteAuthorizationService : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;


+ (void)setAccessToken:(VKAccessToken *)token;
+ (VKAccessToken *)accessToken;

- (instancetype)initWithMediator:(id)mediator;

- (BOOL)processURL:(NSURL *)url;

- (void)signIn;
+ (BOOL)isLoggedIn;
- (void)signOut;

@end
