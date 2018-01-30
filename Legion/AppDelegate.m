//
//  AppDelegate.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "AppDelegate.h"
#import "DAZAuthorizationMediator.h"
#import "DAZAuthorizationViewController.h"
#import "DAZPartiesTableViewController.h"


NSString *const DAZAuthorizationTokenReceivedNotification = @"DAZAuthorizationTokenReceivedNotification";
NSString *const DAZAuthorizationTokenExpiredNotification = @"DAZAuthorizationTokenExpiredNotification";


@interface AppDelegate ()

@property (nonatomic, weak) DAZAuthorizationViewController *authorizationViewController;

@end


@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [DAZAuthorizationMediator configureService];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self rootViewController];
    
    [self.window makeKeyAndVisible];
    
    [self setupAuthorizationStateObserving];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DAZAuthorizationTokenExpiredNotification object:nil];
    
    [self saveContext];
}


#pragma mark - Authorization state management

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Called when received authorization string with included token.
    if (!self.authorizationViewController)
    {
        return NO;
    }
    
    [self.authorizationViewController.authorizationMediator openURL:url];
    
    return YES;
}

- (UIViewController *)rootViewController
{
    // Вызывается при открытии приложения и последующих изменениях статуса авторизации.
    
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    
    if (!loggedIn)
    {
        return [[DAZAuthorizationViewController alloc] init];
    }
    else
    {
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:[[DAZPartiesTableViewController alloc] init]];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[navigationController];
        
        return tabBarController;
    }
}

- (void)setupAuthorizationStateObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authorizationTokenReceived)
                                                 name:DAZAuthorizationTokenReceivedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authorizationTokenExpired)
                                                 name:DAZAuthorizationTokenExpiredNotification
                                               object:nil];
}

- (void)authorizationTokenReceived
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    
    UIViewController *rootViewController = self.rootViewController;
    
    [UIView transitionWithView:self.window
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
        self.window.rootViewController = rootViewController;
    } completion:nil];
}

- (void)authorizationTokenExpired
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedIn"];
    
    UIViewController *rootViewController = self.rootViewController;
    
    [UIView transitionWithView:self.window
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
        self.window.rootViewController = rootViewController;
     } completion:nil];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer
{
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self)
    {
        if (_persistentContainer == nil)
        {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Legion"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil)
                {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
