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

@property (nonatomic, readonly) NSString* fullName;

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSURL *photoURL;

+ (void)resetUserProfile;

@end
