//
//  VKAccessToken.h
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject

@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *email;

@property (nonatomic, readonly) NSTimeInterval expiresIn;
@property (nonatomic, readonly) NSTimeInterval created;

@property (nonatomic, getter=isExpired, readonly) BOOL expired;

// Creation
+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary;
   
//// Instance Accessors
//+ (VKAccessToken *)accessToken;
//+ (void)setAccessToken:(VKAccessToken *)accessToken;
//+ (void)deleteAccessToken;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
