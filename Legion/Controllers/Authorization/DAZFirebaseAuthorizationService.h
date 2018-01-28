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

@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

+ (void)configureService;

- (instancetype)initWithMediator:(id)mediator;

// Will be introduced in future releases
- (void)signIn NS_UNAVAILABLE;

- (void)signInWithUserID:(NSString *)uid;
- (void)signInWithCustomToken:(NSString *)token;
- (void)signInAnonymously;

@end
