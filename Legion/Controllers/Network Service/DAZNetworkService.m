//
//  DAZNetworkService.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>
#import "DAZRootViewControllerRouter.h"
#import "DAZNetworkService.h"


typedef void (^DAZURLSessionCompletionHandler)(NSData * data, NSURLResponse *response, NSError *error);

static NSString *const DAZServerBaseURL = @"https://us-central1-legion-svc.cloudfunctions.net/";

static NSString *const DAZServerIsReachable = @"isReachable";

static NSString *const DAZFunctionGetParties = @"getParties";
static NSString *const DAZFunctionAddParty = @"addParty";
static NSString *const DAZFunctionUpdateParty = @"updateParty";
static NSString *const DAZFunctionDeleteParty = @"deleteParty";

static NSString *const DAZFunctionGetClaims = @"getClaims";
static NSString *const DAZFunctionSendClaim = @"sendClaim";
static NSString *const DAZFunctionUpdateClaim = @"updateClaim";
static NSString *const DAZFunctionDeleteClaim = @"deleteClaim";


@interface DAZNetworkService ()

@property (nonatomic, weak) UIApplication *application;

- (void)dataTaskWithFunction:(NSString *)function
                  dictionary:(NSDictionary *)parameters
            completionHanler:(DAZURLSessionCompletionHandler)completionHandler;

@end

@implementation DAZNetworkService


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _application = [UIApplication sharedApplication];
    }
    return self;
}


#pragma mark - Reachability Testing

- (BOOL)isServerReachable
{
    NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZServerBaseURL, DAZServerIsReachable];
    
    // Тестирование активного соединения, в ответ приходит сырая строка 'YES'
    NSURL *serverURL = [NSURL URLWithString:absoluteURL];
    NSData *data = [NSData dataWithContentsOfURL:serverURL];
    
    return data ? YES : NO;
}

#ifdef DEBUG
- (void)setTestData
{
    [self dataTaskWithFunction:@"setTestData"
                    dictionary:nil
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  NSLog(@"Тестовые данные установлены!");
              }];
}
#endif


#pragma mark - Private

- (void)dataTaskWithFunction:(NSString *)function
                     dictionary:(NSDictionary *)parameters
               completionHanler:(DAZURLSessionCompletionHandler)completionHandler
{
    // Проверка на состояние авторизации
    [[FIRAuth auth].currentUser getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error)
    {
         
        if (!token)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
            return;
        }

        NSURLSession *session = [NSURLSession sharedSession];

        NSString *absoluteURL = [NSString stringWithFormat:@"%@%@", DAZServerBaseURL, function];
        NSURL *url = [NSURL URLWithString:absoluteURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // Добавление токена авторизации в запрос для идентификации пользователя
        NSString* bearer = [NSString stringWithFormat:@"Bearer %@", token];
        [request setValue:bearer forHTTPHeaderField:@"Authorization"];
        
        // Если на вход приходит словарь, добавление его в тело запроса
        if (parameters)
        {
            NSError *serializationError;
            NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&serializationError];
            if (!serializationError)
            {
                request.HTTPBody = body;
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            }
            else
            {
                NSLog(@"Ошибка добавления JSON в запрос %@", serializationError);
            }
        }
        
        request.HTTPMethod = @"POST";

        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:completionHandler];
        [postDataTask resume];
    }];
}

@end

@implementation DAZNetworkService (Parties)


#pragma mark - Parties Accessors

- (void)downloadParties
{
    [self dataTaskWithFunction:DAZFunctionGetParties
                    dictionary:nil
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error)
                  {
                      NSArray *parties = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                      if (!error)
                      {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if ([self.partiesDelegate respondsToSelector:@selector(networkServiceDidFinishDownloadParties:)])
                              {
                                  [self.partiesDelegate networkServiceDidFinishDownloadParties:parties];
                              }
                          });
                      }
                      else
                      {
                          NSLog(@"Error occured during downloadParties response serialization - %@", error);
                      }
                  }
                  else
                  {
                      NSLog(@"Error occured during downloadParties request - %@", error);
                  }
              }];
}

- (void)addParty:(NSDictionary *)partyDictionary
{
    if (!partyDictionary)
    {
        return;
    }
    
    [self dataTaskWithFunction:DAZFunctionAddParty
                    dictionary:partyDictionary
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.partiesDelegate respondsToSelector:@selector(networkServiceDidFinishAddParty)])
                          {
                              [self.partiesDelegate networkServiceDidFinishAddParty];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during addParty - %@", error);
                  }
              }];
}

- (void)updateParty:(NSDictionary *)partyDictionary
{
    if (!partyDictionary)
    {
        return;
    }
    
    [self dataTaskWithFunction:DAZFunctionUpdateParty
                    dictionary:partyDictionary
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.partiesDelegate respondsToSelector:@selector(networkServiceDidFinishUpdateParty)])
                          {
                              [self.partiesDelegate networkServiceDidFinishUpdateParty];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during updateParty - %@", error);
                  }
              }];
}

- (void)deleteParty:(NSDictionary *)partyDictionary
{
    if (!partyDictionary)
    {
        return;
    }
    
    NSDictionary *parameters = @{ @"partyID" : partyDictionary[@"partyID"] };
    
    [self dataTaskWithFunction:DAZFunctionDeleteParty
                    dictionary:parameters
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.partiesDelegate respondsToSelector:@selector(networkServiceDidFinishDeleteParty)])
                          {
                              [self.partiesDelegate networkServiceDidFinishDeleteParty];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during deleteParty - %@", error);
                  }
              }];
}

@end

@implementation DAZNetworkService (Claims)


#pragma mark - Claims Accessors

- (void)downloadClaims
{
    [self dataTaskWithFunction:DAZFunctionGetClaims
                    dictionary:nil
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error)
                  {
                      NSArray *claims = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                      if (!error)
                      {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if ([self.claimsDelegate respondsToSelector:@selector(networkServiceDidFinishDownloadClaims:)])
                              {
                                  [self.claimsDelegate networkServiceDidFinishDownloadClaims:claims];
                              }
                          });
                      }
                      else
                      {
                          NSLog(@"Error occured during downloadClaims response serialization - %@", error);
                      }
                  }
                  else
                  {
                      NSLog(@"Error occured during downloadClaims request - %@", error);
                  }
              }];
}

- (void)sendClaimForPartyID:(NSString *)partyID
{
    if (!partyID)
    {
        return;
    }
    
    NSDictionary *claimDictionary = @{ @"partyID" : partyID };
    
    [self dataTaskWithFunction:DAZFunctionSendClaim
                    dictionary:claimDictionary
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.claimsDelegate respondsToSelector:@selector(networkServiceDidFinishSendClaim)])
                          {
                              [self.claimsDelegate networkServiceDidFinishSendClaim];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during sendClaim - %@", error);
                  }
              }];
}

- (void)updateClaim:(NSDictionary *)claimDictionary
{
    if (!claimDictionary)
    {
        return;
    }
    
    [self dataTaskWithFunction:DAZFunctionUpdateClaim
                    dictionary:claimDictionary
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.claimsDelegate respondsToSelector:@selector(networkServiceDidFinishUpdateClaim)])
                          {
                              [self.claimsDelegate networkServiceDidFinishUpdateClaim];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during updateClaim - %@", error);
                  }
              }];
}

- (void)deleteClaim:(NSDictionary *)claimDictionary
{
    if (!claimDictionary)
    {
        return;
    }
    
    [self dataTaskWithFunction:DAZFunctionDeleteClaim
                    dictionary:claimDictionary
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (!error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([self.claimsDelegate respondsToSelector:@selector(networkServiceDidFinishDeleteClaim)])
                          {
                              [self.claimsDelegate networkServiceDidFinishDeleteClaim];
                          }
                      });
                  }
                  else
                  {
                      NSLog(@"Error occured during deleteClaim - %@", error);
                  }
              }];
}

@end
