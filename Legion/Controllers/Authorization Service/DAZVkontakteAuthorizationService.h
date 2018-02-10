//
//  DAZVkontakteAuthorizationService.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"
#import "VKAccessToken.h"


@interface DAZVkontakteAuthorizationService : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMediator:(id)mediator;

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signOut;

- (BOOL)processAuthorizationURL:(NSURL *)url;

@end
