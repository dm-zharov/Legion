//
//  DAZAuthorizationServiceProtocol.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#ifndef DAZAuthorizationServiceProtocol_h
#define DAZAuthorizationServiceProtocol_h

@class DAZUserProfile;


typedef NS_ENUM(NSUInteger, DAZAuthorizationType) {
    /// Авторизация с помощью "ВКонтакте"
    DAZAuthorizationVkontakte = 1,
    /// Авторизация с помощью "Firebase" (анонимная)
    DAZAuthorizationAnonymously
};


@protocol DAZAuthorizationServiceProtocol <NSObject>

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signOut;

@end


@protocol DAZAuthorizationServiceDelegate <NSObject>

@optional

- (void)authorizationServiceDidFinishSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error;
- (void)authorizationServiceDidFinishSignOut;

@end
#endif /* DAZAuthorizationServiceProtocol_h */
