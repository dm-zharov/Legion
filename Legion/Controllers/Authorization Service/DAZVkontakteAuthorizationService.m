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

static NSString *const DAZVkontakteResourceScheme = @"https://oauth.vk.com/";
static NSString *const DAZVkontakteApplicationScheme = @"vkauthorize://";

static NSString *const DAZVkontakteRelativeString =
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

- (void)signInWithVkontakteApplication;
- (void)signInWithSafariAuthorizationSession;

@end

@implementation DAZVkontakteAuthorizationService


#pragma mark - Instance Accessors

+ (void)setUserProfileWithUserID:(NSString *)userID completionHandler:(void (^)(DAZUserProfile *profile))handler
{
    NSString *absoluteURL = [NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_ids=%@&access_token=07dfb4b107dfb4b107dfb4b14807bf6ee0007df07dfb4b15db54152fe0c7dda75a0eb23&fields=photo_400_orig&name_case=Nom&v=v5.71", userID];
    
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSURLSession *session = [NSURLSession sharedSession];;
    
    NSURLSessionDataTask *profileDataTsk = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (responseData)
            {
                NSDictionary *userData = responseData[@"response"][0];
                DAZUserProfile *userProfile = [[DAZUserProfile alloc] init];
                userProfile.firstName = userData[@"first_name"];
                userProfile.lastName = userData[@"last_name"];
                
                NSURL *photoURL = [NSURL URLWithString:userData[@"photo_400_orig"]];
                userProfile.photoURL = photoURL;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(userProfile);
                });
            }
        }
    }];
    
    [profileDataTsk resume];
}


#pragma mark - Lifecycle

- (instancetype)init
{
    return [super init];
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
    
    BOOL vkAppAvailable = [self isVkontakeApplicationAvailable];
    
    if (vkAppAvailable)
    {
        [self signInWithVkontakteApplication];
    }
    else
    {
        [self signInWithSafariAuthorizationSession];
    }
}

- (void)signOut
{
    [self completedSignOut];
}


#pragma mark - Public

- (BOOL)processAuthorizationURL:(NSURL *)url
{
    NSError *error = [NSError errorWithDomain:DAZVkontakteOpenURLErrorDomain code:0 userInfo:nil];
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *absoluteURL = [url absoluteString];
        
        // Поиск места, с которого начинаются ключи параметров
        NSRange rangeOfHash = [absoluteURL rangeOfString:@"#"];
        
        if (rangeOfHash.location == NSNotFound)
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        NSString *parametersString = [absoluteURL substringFromIndex:rangeOfHash.location + 1];
        if (parametersString.length == 0)
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        NSDictionary *parametersDictionary = [self explodeParametersString:parametersString];
        
        if (parametersDictionary[@"cancel"] || parametersDictionary[@"error"] || parametersDictionary[@"fail"])
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        if (!parametersDictionary[@"access_token"])
        {
            [self completedSignInWithProfile:nil error:error];
            return NO;
        }
        
        DAZUserProfile *profile = [self setUserProfileByParametersDictionary:parametersDictionary];
        [self completedSignInWithProfile:profile error:nil];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Private

- (void)signInWithVkontakteApplication
{
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZVkontakteResourceScheme, DAZVkontakteRelativeString];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSError *error = [[NSError alloc] initWithDomain:DAZVkontakteOpenURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)])
    {
        NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly: @NO };
        
        [application openURL:url options:options completionHandler:^(BOOL success) {
            if (!success)
            {
                [self completedSignInWithProfile:nil error:error];
            }
        }];
    }
    else
    {
        [self completedSignInWithProfile:nil error:error];
    }
}

- (void)signInWithSafariAuthorizationSession
{
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZVkontakteResourceScheme, DAZVkontakteRelativeString];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    SFAuthenticationSession *session =
        [[SFAuthenticationSession alloc] initWithURL:url
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

- (BOOL)isVkontakeApplicationAvailable
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:DAZVkontakteApplicationScheme]];
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

- (DAZUserProfile *)setUserProfileByParametersDictionary:(NSDictionary *)dictionary
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    
    profile.authorizationType = DAZAuthorizationVkontakte;
    profile.tempAccessToken = dictionary[@"access_token"];
    
    profile.userID = dictionary[@"user_id"];
    profile.email = dictionary[@"email"];
    
    return profile;
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
