//
//  DAZVkontakteAuthorizationService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "DAZVkontakteAuthorizationService.h"
#import "DAZUserProfile.h"

#import "NSError+Domains.h"

static NSString *const DAZVkontakteServiceRelativeString =
    @"authorize?"
     "revoke=1"
     "&response_type=token"
     "&display=mobile"
     "&scope=friends%2Cemail%2Coffline"
     "&v=5.40"
     "&redirect_uri=vk6347345%3A%2F%2Fauthorize"
     "&client_id=6347345";

@interface DAZVkontakteAuthorizationService ()

@property (nonatomic, strong) SFAuthenticationSession *session;

@end

@implementation DAZVkontakteAuthorizationService

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithMediator:(id)mediator
{
    self = [self init];
    if (self) {
        _delegate = mediator;
    }
    return self;
}

#pragma mark - DAZAuthorizationServiceProtocol

- (void)signInWithAuthorizationType:(DAZAuthorizationType)authorizationType
{
    
    if (authorizationType != DAZAuthorizationVkontakte)
    {
        return;
    }
    
    BOOL vkApp = [self isVkontakeAppInstalled];
    
    NSError *error = [[NSError alloc] initWithDomain:DAZVkontakteOpenURLErrorDomain
                                                code:NSURLErrorUnknown
                                            userInfo:nil];
    
    if (vkApp)
    {
        NSString *baseURL = @"vkauthorize://";
        NSURL *absoluteURL = [NSURL URLWithString:
            [NSString stringWithFormat:@"%@%@", baseURL, DAZVkontakteServiceRelativeString]];
        
        UIApplication *application = [UIApplication sharedApplication];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly: @NO };
            
            [application openURL:absoluteURL options:options completionHandler:^(BOOL success) {
                if (!success)
                {
                    [self completedSignInWithProfile:nil error:error];;
                }
            }];
        }
    }
    else
    {
        NSString *baseURL = @"https://oauth.vk.com/";
        NSURL *absoluteURL = [NSURL URLWithString:
            [NSString stringWithFormat:@"%@%@", baseURL, DAZVkontakteServiceRelativeString]];
        
        SFAuthenticationSession *session = [[SFAuthenticationSession alloc] initWithURL:absoluteURL
                                                                      callbackURLScheme:@"vk6347345://"
                                       completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
            [self.session cancel];
           
            if (!error)
            {
                [self processAuthorizationURL:callbackURL];
            }
            else
            {
                [self completedSignInWithProfile:nil error:error];
            }
        }];
        
        self.session = session;
        [self.session start];
    }
}

- (BOOL)isVkontakeAppInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vkauthorize://authorize"]];
}

- (void)signOut
{
    [self completedSignOut];
}

- (BOOL)processAuthorizationURL:(NSURL *)url
{
    NSError *error = [NSError errorWithDomain:DAZVkontakteOpenURLErrorDomain code:0 userInfo:nil];
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *absoluteString = [url absoluteString];
        NSRange rangeOfHash = [absoluteString rangeOfString:@"#"];
        
        if (rangeOfHash.location == NSNotFound)
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        NSString *parametersString = [absoluteString substringFromIndex:rangeOfHash.location + 1];
        if (parametersString.length == 0)
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        NSDictionary *parametersDict = [self explodeParametersString:parametersString];
        
        if (parametersDict[@"cancel"] || parametersDict[@"error"] || parametersDict[@"fail"])
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        if (!parametersDict[@"access_token"])
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        VKAccessToken *token = [[VKAccessToken alloc] initWithDictionary:parametersDict];
        
        DAZUserProfile *profile = [[DAZUserProfile alloc] init];
        profile.userID = token.userID;
        profile.accessToken = token.token;
        profile.email = token.email;
        
        [self completedSignInWithProfile:profile error:nil];
        
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)explodeParametersString:(NSString *)parametersString
{
    NSArray *keyValuePairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    for (NSString *keyValueString in keyValuePairs)
    {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        parametersDict[keyValueArray[0]] = keyValueArray[1];
    }
    
    return parametersDict;
}

#pragma mark - DAZAuthorizationServiceDelegate

- (void)completedSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
    {
        [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:error];
    }
}

- (void)completedSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        [self.delegate authorizationServiceDidFinishSignOut];
    }
}
@end
