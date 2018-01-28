//
//  DAZAuthorizationServiceProtocol.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#ifndef DAZAuthorizationServiceProtocol_h
#define DAZAuthorizationServiceProtocol_h

@protocol DAZAuthorizationServiceProtocol <NSObject>
@optional

- (void)signIn;
- (BOOL)isLoggedIn;
- (void)signOut;

@end

@protocol DAZAuthorizationServiceDelegate <NSObject>
@optional

- (void)authorizationDidFinishWithResult:(id)result;
- (void)authorizationDidFinishWithError:(NSError *)error;
- (void)authorizationDidFinishSignOutProcess;

@end
#endif /* DAZAuthorizationServiceProtocol_h */
