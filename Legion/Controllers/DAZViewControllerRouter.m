//
//  DAZViewControllerRouter.m
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZViewControllerRouter.h"
#import "DAZAuthorizationViewController.h"
#import "DAZPartiesTableViewController.h"

NSString *const DAZAuthorizationTokenReceivedNotification = @"DAZAuthorizationTokenReceivedNotification";
NSString *const DAZAuthorizationTokenExpiredNotification = @"DAZAuthorizationTokenExpiredNotification";


@interface DAZViewControllerRouter ()

//@property (nonatomic, weak) UIWindow *window;
// Методы, вызываемые при получении уведомления о изменении статуса авторизации.
- (void)authorizationTokenReceived;
- (void)authorizationTokenExpired;

@end

@implementation DAZViewControllerRouter

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenExpiredNotification object:nil];
}

#pragma mark - Public

- (UIViewController *)rootViewController
{
    // Вызывается при открытии приложения и последующих изменениях статуса авторизации.
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(authorizationTokenReceived)
                                                     name:DAZAuthorizationTokenReceivedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(authorizationTokenExpired)
                                                     name:DAZAuthorizationTokenExpiredNotification
                                                   object:nil];
    });
    
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    
    if (!loggedIn)
    {
        // Показать экран авторизации.
        return [[DAZAuthorizationViewController alloc] init];
    }
    else
    {
        // Показать экран приложения.
        return self.tabBarController;
    }
}

#pragma mark - Private

- (UITabBarController *)tabBarController
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[self.firstViewController];
    
    return tabBarController;
}

- (UIViewController *)firstViewController
{
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:[[DAZPartiesTableViewController alloc] init]];
    
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    navigationController.navigationBar.layer.shadowOpacity = 0.25;
    navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    navigationController.navigationBar.layer.shadowRadius = 2.0;
    
    navigationController.navigationBar.prefersLargeTitles = YES;
    navigationController.tabBarItem.title = @"Тусовки";
    
    return navigationController;
}

- (UIViewController *)secondViewController
{
    return nil;
}

- (UIViewController *)thirdViewController
{
    return nil;
}

#pragma mark - Authorization State Changed

- (void)authorizationTokenReceived
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIViewController *rootViewController = self.rootViewController;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionWithView:window
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        window.rootViewController = rootViewController;
                    } completion:nil];
}

- (void)authorizationTokenExpired
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedIn"];
    [NSUserDefaults resetStandardUserDefaults];
    
    UIViewController *rootViewController = self.rootViewController;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionWithView:window
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        window.rootViewController = rootViewController;
                    } completion:nil];
}

@end
