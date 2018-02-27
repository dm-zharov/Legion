//
//  DAZNetworkService+Debug.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#ifdef DEBUG

#import <Firebase.h>
#import "DAZNetworkService+Debug.h"


typedef void (^DAZURLSessionCompletionHandler)(NSData * data, NSURLResponse *response, NSError *error);


@interface DAZNetworkService ()

- (void)dataTaskWithFunction:(NSString *)function
                  dictionary:(NSDictionary *)parameters
            completionHanler:(DAZURLSessionCompletionHandler)completionHandler;

@end

@implementation DAZNetworkService (Debug)

- (void)setTestData
{
    [self dataTaskWithFunction:@"setTestData"
                    dictionary:nil
              completionHanler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  NSLog(@"Тестовые данные установлены!");
              }];
}

@end


#endif
