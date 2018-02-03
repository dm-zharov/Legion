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
@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

- (void)openURL:(NSURL *)url;

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signOut;

@end
