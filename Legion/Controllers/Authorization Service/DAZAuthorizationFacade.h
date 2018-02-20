//
//  DAZAuthorizationFacade.h
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"


/**
 * Сервер "Firebase" не поддерживает авторизацию с использованием "ВКонтакте", однако имеет возможность регистрации
 * посредством уникального идентификатора. Идентификатор пользователя "ВКонтакте" отлично подходит для этих нужд.
 *
 * Для анонимного входа используется "Firebase".
 *
 * Данный посредник обеспечивает взаимодействие между обоими сервисами.
 */
@interface DAZAuthorizationFacade : NSObject <DAZAuthorizationServiceProtocol>

@property (nonatomic, weak) id <DAZAuthorizationServiceDelegate> delegate;

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType;
- (void)signOut;

- (BOOL)processAuthorizationURL:(NSURL *)url;

@end
