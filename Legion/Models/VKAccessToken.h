//
//  VKAccessToken.h
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject

@property(nonatomic, readonly, copy) NSString *accessToken;
@property(nonatomic, readonly, copy) NSString *userId;
@property(nonatomic, readonly, copy) NSString *email;
@property(nonatomic, readonly, assign) NSInteger expiresIn;
@property(nonatomic, readonly, assign) NSTimeInterval created;

+ (instancetype)tokenFromDictionary:(NSDictionary *)parametersDict;

- (instancetype)initTokenWithDictionary:(NSDictionary *)parametersDict;
- (BOOL)isExpired;
- (void)removeToken;

@end
