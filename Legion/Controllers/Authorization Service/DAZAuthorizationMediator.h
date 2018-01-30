//
//  DAZAuthorizationMediator.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"

@interface DAZAuthorizationMediator : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, getter=isLoggedIn, readonly) BOOL loggedIn;
@property (nonatomic, strong) id <DAZAuthorizationServiceDelegate> delegate;

+ (void)configureService;

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signOut;

- (BOOL)openURL:(NSURL *)url;

@end
