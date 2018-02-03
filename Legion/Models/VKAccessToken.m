//
//  VKAccessToken.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "AppDelegate.h"
#import "VKAccessToken.h"

@interface VKAccessToken ()

@end

@implementation VKAccessToken

+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (nullable VKAccessToken *)accessToken {
    return nil;
    
}

+ (void)setAccessToken:(nonnull VKAccessToken *)accessToken {
    
}

+ (void)deleteAccessToken {
    //[[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _token = dictionary[@"access_token"];
        _email = dictionary[@"email"];
        _expiresIn = [dictionary[@"expires_in"] floatValue];
        _userId = dictionary[@"user_id"];
        _created = [[NSDate new] timeIntervalSince1970];
    }
    return self;
}

- (BOOL)isExpired {
    return self.expiresIn > 0 && self.expiresIn + self.created < [[NSDate new] timeIntervalSince1970];
}

- (void)deleteAccessToken
{
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
}

@end
