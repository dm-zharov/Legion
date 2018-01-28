//
//  VKAccessToken.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "VKAccessToken.h"

@implementation VKAccessToken

+ (instancetype)tokenFromDictionary:(NSDictionary *)parametersDict
{
    return [[self alloc] initTokenWithDictionary:parametersDict];
}

- (instancetype)initTokenWithDictionary:(NSDictionary *)parametersDict
{
    self = [super init];
    if (self) {
        _accessToken = parametersDict[@"access_token"];
        _email = parametersDict[@"email"];
        _expiresIn = [parametersDict[@"expires_in"] integerValue];
        _userId = parametersDict[@"user_id"];
        _created = [[NSDate new] timeIntervalSince1970];
    }
    return self;
}

- (BOOL)isExpired {
    return self.expiresIn > 0 && self.expiresIn + self.created < [[NSDate new] timeIntervalSince1970];
}

- (void)removeToken
{
    //[someone deletefromcoredata];
}

@end
