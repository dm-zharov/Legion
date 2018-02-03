//
//  NSErrorDomain+Domains.m
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "NSError+Domains.h"

NSErrorDomain const DAZVkontakteOpenURLErrorDomain =
    @"Ошибка авторизации с помощью \"ВКонтакте\": не удалось обработать полученную URL строку.";

NSErrorDomain const DAZFirebaseAuthorizationErrorDomain =
    @"Ошибка авторизации с помощью \"Firebase\": ошибка сети.";

@implementation NSError (Domains)

@end
