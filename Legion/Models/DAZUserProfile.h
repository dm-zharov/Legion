//
//  DAZUserProfile.h
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZAuthorizationServiceProtocol.h"


@interface DAZUserProfile : NSObject

@property (nonatomic, assign) DAZAuthorizationType authorizationType;

@property (nonatomic, getter=isLoggedIn, assign) BOOL loggedIn;

@property (nonatomic, readwrite) NSString *userID;
@property (nonatomic, readonly) NSString* fullName;
@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSURL *photoURL;

+ (void)resetUserProfile;

@end
