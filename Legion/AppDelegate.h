//
//  AppDelegate.h
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


extern NSString *const DAZAuthorizationTokenExpiredNotification;
extern NSString *const DAZAuthorizationTokenReceivedNotification;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

