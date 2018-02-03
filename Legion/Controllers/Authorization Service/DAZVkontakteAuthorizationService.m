//
//  DAZVkontakteAuthorizationService.m
//  Legion
//
//  Created by Дмитрий Жаров on 28.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "DAZVkontakteAuthorizationService.h"

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

- (BOOL)processURL:(NSURL *)url
{
//    NSError *error = [[NSError alloc] initWithDomain:DAZVkontakteOpenURLErrorDomain
//                                                code:NSURLErrorUnknown
//                                            userInfo:nil];
    
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *absoluteString = [url absoluteString];
        NSRange rangeOfHash = [absoluteString rangeOfString:@"#"];
        
        if (rangeOfHash.location == NSNotFound)
        {
            //[self completedSignInWithResult:nil error:error];
            return NO;
        }
        
        NSString *parametersString = [absoluteString substringFromIndex:rangeOfHash.location + 1];
        if (parametersString.length == 0)
        {
            //[self completedSignInWithResult:nil error:error];
            return NO;
        }
        
        NSDictionary *parametersDict = [self explodeParametersString:parametersString];
        
        if (parametersDict[@"cancel"] || parametersDict[@"error"] || parametersDict[@"fail"])
        {
            //[self completedSignInWithResult:nil error:error];
            return NO;
        }
        
        if (!parametersDict[@"access_token"])
        {
            //[self completedSignInWithResult:nil error:error];
            return NO;
        }
        
        VKAccessToken *token = [[VKAccessToken alloc] initWithDictionary:parametersDict];
        [VKAccessToken setAccessToken:token];
        [self completedSignInWithResult:token error:nil];
        
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)explodeParametersString:(NSString *)parametersString
{
    NSArray *keyValuePairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    for (NSString *keyValueString in keyValuePairs) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        parametersDict[keyValueArray[0]] = keyValueArray[1];
    }
    
    return parametersDict;
}

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

+ (void)setAccessToken:(VKAccessToken *)token
{
    [VKAccessToken setAccessToken:token];
}

+ (VKAccessToken *)accessToken
{
    [VKAccessToken accessToken];
    return nil;
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
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly: @NO };
            
            [application openURL:absoluteURL options:options completionHandler:^(BOOL success) {
            
                if (!success)
                {
                    [self completedSignInWithResult:nil error:error];;
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
                [self processURL:callbackURL];
            }
            else
            {
                [self completedSignInWithResult:nil error:error];
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

- (BOOL)isLoggedIn
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedIn"];
}

- (void)signOut
{
    [self completedSignOut];
}

#pragma mark - Optional messages for DAZAuthorizationServiceDelegate

- (void)completedSignInWithResult:(VKAccessToken *)result error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithResult:error:)])
    {
        [self.delegate authorizationServiceDidFinishSignInWithResult:result error:error];
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
