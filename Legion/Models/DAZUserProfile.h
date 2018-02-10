//
//  VKUserProfile.h
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"


@interface DAZUserProfile : NSObject

@property (nonatomic, assign) DAZAuthorizationType authorizationType;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, getter=isAnonymous, readonly) BOOL anonymous;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSURL *photoURL;

@end
