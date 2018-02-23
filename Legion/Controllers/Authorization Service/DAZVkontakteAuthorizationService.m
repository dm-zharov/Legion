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
#import "DAZUserProfile.h"


static NSString *const DAZVkontakteResourceScheme = @"https://oauth.vk.com/";
static NSString *const DAZVkontakteApplicationScheme = @"vkauthorize://";

static NSString *const DAZVkontakteRelativeString =
    @"authorize?"
     "revoke=1"
     "&response_type=token" // Ожидаемый формат callback'а
     "&display=mobile"
     "&scope=friends%2Cemail%2Coffline" // Параметры запрашиваемых данных
     "&v=5.40"
     "&redirect_uri=vk6347345%3A%2F%2Fauthorize" // Схема приложения для обратного редиректа
     "&client_id=6347345"; // ID приложения

static NSString *const DAZVkontakteProfileBaseURL = @"https://api.vk.com/method/users.get?"
    "access_token=07dfb4b107dfb4b107dfb4b14807bf6ee0007df07dfb4b15db54152fe0c7dda75a0eb23" // Сервисный токен приложения
    "&fields=photo_200" // Разрешение запрашиваемой аватарки
    "&name_case=Nom" // Форматирование имени и фамилии
    "&v=v5.71" // Версия используемого API
    "&user_ids="; // Идентификатор пользователя (%@)



@interface DAZVkontakteAuthorizationService ()

@property (nonatomic, strong) SFAuthenticationSession *session;

@end


@implementation DAZVkontakteAuthorizationService


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
    if (authorizationType == DAZAuthorizationVkontakte)
    {
        [self signIn];
    }
    else
    {
        NSError *error = [[NSError alloc]
            initWithDomain:@"Ошибка авторизации: данный способ авторизации не поддерживается провайдером \"ВКонтакте\"."
                      code:0
                  userInfo:nil];
        [self completedSignInWithProfile:nil error:error];
    }
}

- (void)signOut
{
    [DAZUserProfile resetUserProfile];
    
    [self completedSignOut];
}


#pragma mark - Public

- (void)signIn
{
    BOOL vkAppAvailable = [self isVkontakteApplicationAvailable];
    
    if (vkAppAvailable)
    {
        [self signInWithVkontakteApplication];
    }
    else
    {
        [self signInWithSafariAuthorizationSession];
    }
}

- (BOOL)processAuthorizationURL:(NSURL *)url
{
    if (!url)
    {
        return NO;
    }
    
    NSError *error = [NSError errorWithDomain:DAZVkontakteOpenURLErrorDomain code:0 userInfo:nil];
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *absoluteURL = [url absoluteString];
    
        /**
         * Поиск позиции в строке, с которой начинаются ключи параметров. Для данной задачи свойство URL.query
         * не может быть использовано по причине несоответствия RFC 1808.
         */
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
        
        NSDictionary *parametersDictionary = [self processParametersString:parametersString];
        
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
        
        [self processSignInWithParametersDictionary:parametersDictionary];
        
        return YES;
    }
    
    return NO;
}


#pragma mark - Private

- (void)signInWithVkontakteApplication
{
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZVkontakteApplicationScheme, DAZVkontakteRelativeString];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSError *error = [[NSError alloc] initWithDomain:DAZVkontakteOpenURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)])
    {
        NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly : @NO };
        
        [application openURL:url options:options completionHandler:^(BOOL success) {
            if (!success)
            {
                [self completedSignInWithProfile:nil error:error];
            }
        }];
    }
}

- (void)signInWithSafariAuthorizationSession
{
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZVkontakteResourceScheme, DAZVkontakteRelativeString];
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    SFAuthenticationSession *session =
        [[SFAuthenticationSession alloc] initWithURL:url
                                   callbackURLScheme:@"vk6347345://"
                                   completionHandler:^(NSURL *callbackURL, NSError *error) {
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

- (NSDictionary *)processParametersString:(NSString *)parametersString
{
    NSArray *keyValuePairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parametersDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *keyValueString in keyValuePairs)
    {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        if (keyValueArray[0] && keyValueArray[1])
        {
            parametersDictionary[keyValueArray[0]] = keyValueArray[1];
        }
    }
    
    return parametersDictionary;
}

- (void)processSignInWithParametersDictionary:(NSDictionary *)dictionary
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    profile.authorizationType = DAZAuthorizationVkontakte;
    profile.userID = dictionary[@"user_id"];
    profile.email = dictionary[@"email"];
    
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZVkontakteProfileBaseURL, profile.userID];
    
    NSURL *url = [NSURL URLWithString:absoluteURL];
    
    NSURLSession *session = [NSURLSession sharedSession];;
    
    NSURLSessionDataTask *profileDataTask = [session dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (responseData)
            {
                NSDictionary *userData = responseData[@"response"][0];
                profile.firstName = userData[@"first_name"];
                profile.lastName = userData[@"last_name"];
                
                NSURL *photoURL = [NSURL URLWithString:userData[@"photo_200"]];
                profile.photoURL = photoURL;
            
                [self completedSignInWithProfile:profile error:nil];
            }
            else
            {
                [self completedSignInWithProfile:nil error:error];
            }
        }
        else
        {
            [self completedSignInWithProfile:nil error:error];
        }
    }];
    
    [profileDataTask resume];
}


#pragma mark - Custom Accessors

- (BOOL)isVkontakteApplicationAvailable
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:DAZVkontakteApplicationScheme]];
}


#pragma mark - DAZAuthorizationServiceDelegate

- (void)completedSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignInWithProfile:error:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate authorizationServiceDidFinishSignInWithProfile:profile error:error];
        });
    }
}

- (void)completedSignOut
{
    if ([self.delegate respondsToSelector:@selector(authorizationServiceDidFinishSignOut)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate authorizationServiceDidFinishSignOut];
        });
    }
}
@end
