//
//  DAZFirebaseAuthService.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"


@interface DAZFirebaseAuthorizationService : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, getter=isLoggedIn, readonly) BOOL loggedIn;
@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

// Instance Accesors
+ (void)setDisplayName:(NSString *)displayName avatarURL:(NSURL *)url;

// Init
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMediator:(id)mediator;

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signInWithUserID:(NSString *)userID;

- (void)signOut;

@end
