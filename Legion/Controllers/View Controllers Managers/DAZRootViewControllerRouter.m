//
//  DAZRootViewControllerRouter.m
//  Legion
//
//  Created by Дмитрий Жаров on 31.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZRootViewControllerRouter.h"
#import "DAZAuthorizationViewController.h"
#import "DAZUserProfile.h"

#import "DAZPartiesTableViewController.h"
#import "DAZClaimsTableViewController.h"
#import "DAZProfileViewController.h"

#import "UINavigationBar+Shadow.h"

NSString *const DAZAuthorizationTokenReceivedNotification = @"DAZAuthorizationTokenReceivedNotification";
NSString *const DAZAuthorizationTokenExpiredNotification = @"DAZAuthorizationTokenExpiredNotification";

@interface DAZRootViewControllerRouter ()

@property (nonatomic, strong) DAZUserProfile *profile;

// Обработка сообщений от центра нотификаций
- (void)authorizationTokenReceived:(NSNotification *)notification;
- (void)authorizationTokenExpired:(NSNotification *)notification;

@end


@implementation DAZRootViewControllerRouter


#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _profile = [[DAZUserProfile alloc] init];
    }
    return self;
}


#pragma mark - Custom Accessors

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
    DAZProfileViewController *profileViewController = [[DAZProfileViewController alloc] init];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    profileViewController.navigationItem.title = @"Профиль";
    
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = NO;
    
    //navigationController.navigationBar.prefersLargeTitles = YES;
    
    navigationController.tabBarItem.title = @"Профиль";
    navigationController.tabBarItem.image = [UIImage imageNamed:@"Profile Icon"];
    
    return navigationController;
}

#pragma mark - NSNotificationCenter Observers

- (void)authorizationTokenReceived:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [self setRootViewController:[self rootViewController] animated:YES];
}

- (void)authorizationTokenExpired:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIn"];
    [DAZUserProfile resetUserProfile];
    
    [self setRootViewController:[self rootViewController] animated:YES];
}

@end
