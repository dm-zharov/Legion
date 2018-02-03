//
//  VKAccessToken.h
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, assign) NSTimeInterval expiresIn;
@property (nonatomic, assign) NSTimeInterval created;

@property (nonatomic, getter=isExpired, readonly) BOOL expired;

// Creation
+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary;
   
// Instance Accessors
+ (VKAccessToken *)accessToken;
+ (void)setAccessToken:(VKAccessToken *)accessToken;
+ (void)deleteAccessToken;

// Init
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
