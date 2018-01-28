//
//  DAZVkontakteAuthorizationService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <SafariServices/SafariServices.h>

#import "DAZVkontakteAuthorizationService.h"

static NSString *relativeString = @"authorize?"
                                    "revoke=1"
                                    "&response_type=token"
                                    "&display=mobile"
                                    "&scope=friends%2Cemail%2Coffline"
                                    "&v=5.40"
                                    "&redirect_uri=vk6347345%3A%2F%2Fauthorize"
                                    "&sdk_version=1.4.6&client_id=6347345";

@interface DAZVkontakteAuthorizationService ()

@property (nonatomic, strong) SFAuthenticationSession *session;

@end

@implementation DAZVkontakteAuthorizationService

- (instancetype)initWithMediator:(id)mediator
{
    self = [super init];
    if (self) {
        _delegate = mediator;
    }
    return self;
}

- (BOOL)processURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *absoluteString = [url absoluteString];
        NSRange rangeOfHash = [absoluteString rangeOfString:@"#"];
        
        if (rangeOfHash.location == NSNotFound) {
            return NO;
        }
        
        NSString *parametersString = [absoluteString substringFromIndex:rangeOfHash.location + 1];
        if (parametersString.length == 0) {
            return NO;
        }
        
        NSDictionary *parametersDict = [self explodeParametersString:parametersString];
        
        if (parametersDict[@"cancel"] || parametersDict[@"error"] || parametersDict[@"fail"]) {
            return NO;
        }
        
        if (parametersDict[@"access_token"])
        {
            VKAccessToken *token = [[VKAccessToken alloc] initTokenWithDictionary:parametersDict];
            [self.delegate authorizationDidFinishWithResult:token];
        } else {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)explodeParametersString:(NSString *)parametersString {
    NSArray *keyValuePairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    for (NSString *keyValueString in keyValuePairs) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        parametersDict[keyValueArray[0]] = keyValueArray[1];
    }
    
    return parametersDict;
}

#warning TODO
+ (BOOL)isLoggedIn {
    //if (vkSdkInstance.accessToken && ![vkSdkInstance.accessToken isExpired]) return true;
    //return false;
    return nil;
}
#warning TODO
+ (void)setAccessToken:(VKAccessToken *)token {
//    VKAccessToken *old = _accessToken;
//    _accessToken = accessToken;
//
//    for (VKWeakDelegate *del in [self.sdkDelegates copy]) {
//        if ([del respondsToSelector:@selector(vkSdkAccessTokenUpdated:oldToken:)]) {
//            [del performSelector:@selector(vkSdkAccessTokenUpdated:oldToken:) withObject:self.accessToken withObject:old];
//        }
//    }
}

#warning TODO
+ (VKAccessToken *)accessToken {
    
    return nil;
}

- (void)signIn {
    
    BOOL vkAppExist = [self vkAppMayExists];
    
    if (vkAppExist) {
        NSString *baseURL = @"vkauthorize://";
        NSURL *absoluteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, relativeString]];
        
        UIApplication *application = [UIApplication sharedApplication];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly: @NO };
            
            [application openURL:absoluteURL options:options completionHandler:^(BOOL success) {
                
                if (!success) {
                    NSError *error = [NSError errorWithDomain:@"Ошибка" code:0 userInfo:nil];
                    [self.delegate authorizationDidFinishWithError:error];
                }
            }];
        }
    } else {
        NSString *baseURL = @"https://oauth.vk.com/";
        NSURL *absoluteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, relativeString]];
        
        SFAuthenticationSession *session =
            [[SFAuthenticationSession alloc] initWithURL:absoluteURL
                                       callbackURLScheme:@"vk6347345://"
                                       completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
            if (!error) {
                [self processURL:callbackURL];
            }
            
            [self.session cancel];
        }];
        
        self.session = session;
        [self.session start];
    }
}

- (void)signOut {
    
}

- (BOOL)vkAppMayExists {
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vkauthorize://authorize"]];
}

@end
