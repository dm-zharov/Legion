//
//  DAZAuthorizationMediator.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"

typedef NS_ENUM(NSUInteger, DAZAuthorizationType) {
    /// Authorize with "Vkontakte"
    DAZAuthorizationVkontakte,
    /// Authorize anonymously with "Firebase"
    DAZAuthorizationAnonymously
};

@interface DAZAuthorizationMediator : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, strong) id <DAZAuthorizationServiceDelegate> delegate;

+ (void)configureService;

- (BOOL)processURL:(NSURL *)url;

- (void)signIn NS_UNAVAILABLE;
- (void)signInWithAuthType:(DAZAuthorizationType)authType;
- (BOOL)isLoggedIn;
- (void)signOut;

- (void)authorizationDidFinishWithResult:(id)result;
- (void)authorizationDidFinishWithError:(NSError *)error;
- (void)authorizationDidFinishSignOutProcess;

@end
