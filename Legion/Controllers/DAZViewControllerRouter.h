//
//  DAZViewControllerRouter.h
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSString *const DAZAuthorizationTokenExpiredNotification;
extern NSString *const DAZAuthorizationTokenReceivedNotification;


@interface DAZViewControllerRouter : NSObject

- (UIViewController *)rootViewController;

@end
