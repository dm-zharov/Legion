//
//  AppDelegate.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>
#import "AppDelegate.h"
#import "DAZRootViewControllerRouter.h"
#import "DAZAuthorizationViewController.h"
#import "UIColor+Colors.h"


@interface AppDelegate ()

@property (nonatomic, strong) DAZRootViewControllerRouter *rootViewControllerRouter;
           
@end


@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor cl_darkPurpleColor];
    
    self.window.layer.cornerRadius = 5;
    self.window.layer.masksToBounds = YES;
    
    self.rootViewControllerRouter = [[DAZRootViewControllerRouter alloc] init];
    self.window.rootViewController = self.rootViewControllerRouter.rootViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // Передача полученной строки с токеном сервису авторизации
    if ([self.window.rootViewController isKindOfClass:[DAZAuthorizationViewController class]])
    {
        DAZAuthorizationViewController *viewController = (DAZAuthorizationViewController *)self.window.rootViewController;
        [viewController.authorizationMediator processAuthorizationURL:url];
    }
    
    return YES;
}

@end
