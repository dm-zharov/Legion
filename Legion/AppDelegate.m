//
//  AppDelegate.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Firebase.h>

#import "AppDelegate.h"

#import "DAZAuthViewController.h"
#import "ViewController.h"

#import "VKAccessToken.h"

@interface AppDelegate ()

//@property (nonatomic, strong) DAZAuthService *authService;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self rootViewController];
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (UIViewController *)rootViewController {
    if (_persistentContainer == nil) {
        return [[UINavigationController alloc] initWithRootViewController:[[DAZAuthViewController alloc] init]];
    } else {
        return [[ViewController alloc] init];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //[VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    NSLog(@"%@", url.absoluteString);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - VK Authorization

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    //[VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
//
//    return YES;
//}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    [self processURL:url];
    
    return YES;
}

- (BOOL)processURL:(NSURL *)passedURL // +
{
    if ([passedURL.scheme isEqualToString:[NSString stringWithFormat:@"vk6347345"]])
    {
        NSString *urlString = [passedURL absoluteString];
        NSRange rangeOfHash = [urlString rangeOfString:@"#"];

        if (rangeOfHash.location == NSNotFound) {
            return NO;
        }
        
        NSString *parametersString = [urlString substringFromIndex:rangeOfHash.location + 1];
        if (parametersString.length == 0) {
            return NO;
        }
        
        NSDictionary *parametersDict = [self explodeQueryString:parametersString];
        
        if (parametersDict[@"cancel"] || parametersDict[@"error"] || parametersDict[@"fail"]) {
            return NO;
        }
        
        if (parametersDict[@"access_token"])
        {
            VKAccessToken *token = [[VKAccessToken alloc] initTokenWithDictionary:parametersDict];
            // [self setAccessToken:token];
            NSLog(@"%@", token.userId);
        } else {
            return NO;
        }
        
        return YES;
    }

    return NO;
}

- (NSDictionary *)explodeQueryString:(NSString *)queryString { //+
    NSArray *keyValuePairs = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    for (NSString *keyValueString in keyValuePairs) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        parameters[keyValueArray[0]] = keyValueArray[1];
    }
    return parameters;
}

//- (void)setAccessToken:(VKAccessToken *)token { // +
//    [token saveTokenToDefaults:VK_ACCESS_TOKEN_DEFAULTS_KEY];
//
//    id oldToken = vkSdkInstance.accessToken;
//    if (!token && oldToken) {
//        [VKAccessToken delete:VK_ACCESS_TOKEN_DEFAULTS_KEY];
//    }
//
//    vkSdkInstance.authState = token ? VKAuthorizationAuthorized : VKAuthorizationInitialized;
//    vkSdkInstance.accessToken = token;
//}

//+ (VKAccessToken *)accessToken {
//    return vkSdkInstance.accessToken;
//}

//+ (BOOL)isLoggedIn {
//    if (vkSdkInstance.accessToken && ![vkSdkInstance.accessToken isExpired]) return true;
//    return false;
//}

//- (void)setAccessToken:(VKAccessToken *)accessToken {
//    VKAccessToken *old = _accessToken;
//    _accessToken = accessToken;
//
//    for (VKWeakDelegate *del in [self.sdkDelegates copy]) {
//        if ([del respondsToSelector:@selector(vkSdkAccessTokenUpdated:oldToken:)]) {
//            [del performSelector:@selector(vkSdkAccessTokenUpdated:oldToken:) withObject:self.accessToken withObject:old];
//        }
//    }
//}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Legion"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
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

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
