//
//  NSError+Domains.h
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString *NSErrorDomain;

extern NSErrorDomain const DAZVkontakteOpenURLErrorDomain;
extern NSErrorDomain const DAZFirebaseAuthorizationErrorDomain;

@interface NSError (Domains)

@end
