//
//  DAZVkontakteAuthorizationService.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"


@interface DAZVkontakteAuthorizationService : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

- (void)signIn;
- (void)signOut;

/* Обрабатывает ответную строку от "ВКонтакте"
 */
- (BOOL)processAuthorizationURL:(NSURL *)url;

@end
