//
//  DAZRootViewControllerRouter.m
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZRootViewControllerRouter.h"
#import "UINavigationBar+Shadow.h"
#import "DAZAuthorizationViewController.h"
#import "DAZPartiesTableViewController.h"
#import "DAZClaimsTableViewController.h"
#import "DAZProfileViewController.h"

NSString *const DAZAuthorizationTokenReceivedNotification = @"DAZAuthorizationTokenReceivedNotification";
NSString *const DAZAuthorizationTokenExpiredNotification = @"DAZAuthorizationTokenExpiredNotification";


@interface DAZRootViewControllerRouter ()

// Приватные методы, обрабатывающие уведомления о изменении состояния авторизации
- (void)authorizationTokenReceived:(NSNotification *)notification;
- (void)authorizationTokenExpired:(NSNotification *)notification;

@end

@implementation DAZRootViewControllerRouter


#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenExpiredNotification object:nil];
}


#pragma mark - Accessors

- (UIViewController *)rootViewController
{
    // Вызывается при открытии приложения и последующих изменениях статуса авторизации
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(authorizationTokenReceived:)
                                                     name:DAZAuthorizationTokenReceivedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(authorizationTokenExpired:)
                                                     name:DAZAuthorizationTokenExpiredNotification
                                                   object:nil];
    });
    
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    
    if (!loggedIn)
    {
        // Показать экран авторизации
        return [[DAZAuthorizationViewController alloc] init];
    }
    else
    {
        // Показать экран приложения
        return self.tabBarController;
    }
}


#pragma mark - RootViewController Assembly

- (UITabBarController *)tabBarController
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[self.firstViewController, self.secondViewController, self.thirdViewController];
    
    return tabBarController;
}

- (UIViewController *)firstViewController
{
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:[[DAZPartiesTableViewController alloc] init]];
    
    [navigationController.navigationBar sh_customShadow];
    
    navigationController.navigationBar.prefersLargeTitles = YES;
    
    navigationController.tabBarItem.title = @"Тусовки";
    navigationController.tabBarItem.image = [UIImage imageNamed:@"Parties Icon"];
    
    return navigationController;
}

- (UIViewController *)secondViewController
{
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:[[DAZClaimsTableViewController alloc] init]];
    
    [navigationController.navigationBar sh_customShadow];
    
    navigationController.navigationBar.prefersLargeTitles = YES;
    
    navigationController.tabBarItem.title = @"Запросы";
    navigationController.tabBarItem.image = [UIImage imageNamed:@"Claims Icon"];
    
    return navigationController;
}

- (UIViewController *)thirdViewController
{
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:[[DAZProfileViewController alloc] init]];
    
    [navigationController.navigationBar sh_customShadow];
    
    navigationController.navigationBar.prefersLargeTitles = YES;
    
    navigationController.tabBarItem.title = @"Профиль";
    navigationController.tabBarItem.image = [UIImage imageNamed:@"Profile Icon"];
    
    return navigationController;
}

#pragma mark - Public

- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (animated)
    {
        [UIView transitionWithView:window
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
            window.rootViewController = rootViewController;
                        } completion:nil];
    }
}

#pragma mark - Private

- (void)authorizationTokenReceived:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setRootViewController:[self rootViewController] animated:YES];
}

- (void)authorizationTokenExpired:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedIn"];
    [NSUserDefaults resetStandardUserDefaults];
    
    [self setRootViewController:[self rootViewController] animated:YES];
}

@end
