//
//  DAZRootViewControllerRouterTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 18.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "DAZRootViewControllerRouter.h"
#import "DAZAuthorizationViewController.h"
#import "DAZUserProfile.h"

@interface DAZRootViewControllerRouter (Tests)

@property (nonatomic, strong) DAZUserProfile *profile;

@property (nonatomic, readonly) UITabBarController *tabBarController;
@property (nonatomic, readonly) UIViewController *firstViewController;
@property (nonatomic, readonly) UIViewController *secondViewController;
@property (nonatomic, readonly) UIViewController *thirdViewController;

// Обработка сообщений от центра нотификаций
- (void)authorizationTokenReceived:(NSNotification *)notification;
- (void)authorizationTokenExpired:(NSNotification *)notification;

@end

@interface DAZRootViewControllerRouterTests : XCTestCase

@property (nonatomic, strong) DAZRootViewControllerRouter *rootViewControllerRouter;

@end

@implementation DAZRootViewControllerRouterTests

- (void)setUp
{
    [super setUp];
    
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);
    OCMStub(ClassMethod([(id)profile alloc])).andReturn(profile);
    
    self.rootViewControllerRouter = OCMPartialMock([[DAZRootViewControllerRouter alloc] init]);
}

- (void)tearDown
{
    self.rootViewControllerRouter = nil;
    
    [super tearDown];
}

- (void)testRootViewControllerWhenLoggedIn
{
    id profile = self.rootViewControllerRouter.profile;
    OCMStub([profile isLoggedIn]).andReturn(YES);
    
    OCMStub([self.rootViewControllerRouter tabBarController]);
    
    [self.rootViewControllerRouter rootViewController];
    
    OCMVerify([self.rootViewControllerRouter tabBarController]);
}

- (void)testRootViewControllerWhenLoggedOut
{
    id profile = self.rootViewControllerRouter.profile;
    
    OCMStub([profile isLoggedIn]).andReturn(NO);
    
    DAZAuthorizationViewController *authorizationViewController = OCMClassMock([DAZAuthorizationViewController class]);
    OCMStub(ClassMethod([(id)authorizationViewController alloc])).andReturn(authorizationViewController);
    
    id rootViewController = [self.rootViewControllerRouter rootViewController];
    
    expect(rootViewController).to.equal(authorizationViewController);
}

- (void)testSetNilRootViewController
{
    OCMReject([UIApplication sharedApplication]);
    
    [self.rootViewControllerRouter setRootViewController:nil animated:YES];
}

- (void)testSetRootViewControllerWithAnimation
{
    UIApplication *application = OCMClassMock([UIApplication class]);
    OCMStub(ClassMethod([(id)application sharedApplication])).andReturn(application);
    
    UIWindow *window = OCMClassMock([UIWindow class]);
    OCMStub([application keyWindow]).andReturn(window);

    UIViewController *viewController = OCMClassMock([UIViewController class]);
    
    [self.rootViewControllerRouter setRootViewController:viewController animated:YES];
    
    OCMVerify([window setRootViewController:OCMOCK_ANY]);
}

- (void)testSetRootViewControllerWithoutAnimation
{
    UIApplication *application = OCMClassMock([UIApplication class]);
    OCMStub(ClassMethod([(id)application sharedApplication])).andReturn(application);
    
    UIWindow *window = OCMClassMock([UIWindow class]);
    OCMStub([application keyWindow]).andReturn(window);
    
    UIViewController *viewController = OCMClassMock([UIViewController class]);
    
    [self.rootViewControllerRouter setRootViewController:viewController animated:NO];
    
    OCMVerify([window setRootViewController:OCMOCK_ANY]);
}

- (void)testTabBarController
{
    UITabBarController *tabBarController = [self.rootViewControllerRouter tabBarController];
    
    expect(tabBarController.viewControllers.count).to.equal(@3);
    expect(tabBarController.viewControllers.count).notTo.beNil();
}

- (void)testFirstViewController
{
    UIViewController *firstViewController = [self.rootViewControllerRouter firstViewController];
    
    expect(firstViewController).notTo.beNil();
}

- (void)testSecondViewController
{
    UIViewController *secondViewController = [self.rootViewControllerRouter secondViewController];
    
    expect(secondViewController).notTo.beNil();
}

- (void)testThirdViewController
{
    UIViewController *thirdViewController = [self.rootViewControllerRouter thirdViewController];
    
    expect(thirdViewController).notTo.beNil();
}

- (void)testAuthorizationTokenReceiver
{
    id profile = self.rootViewControllerRouter.profile;
    
    OCMStub([profile setLoggedIn:YES]);
    OCMStub([self.rootViewControllerRouter setRootViewController:OCMOCK_ANY animated:YES]);
    
    [self.rootViewControllerRouter authorizationTokenReceived:nil];
    
    OCMVerify([profile setLoggedIn:YES]);
    OCMVerify([self.rootViewControllerRouter setRootViewController:OCMOCK_ANY animated:YES]);
}

- (void)testAuthorizationTokenExpired
{
    id profile = self.rootViewControllerRouter.profile;
    
    OCMStub([profile setLoggedIn:NO]);
    OCMStub(ClassMethod([(id)profile resetUserProfile]));
    OCMStub([self.rootViewControllerRouter setRootViewController:OCMOCK_ANY animated:YES]);
    
    [self.rootViewControllerRouter authorizationTokenExpired:nil];
    
    OCMVerify([profile setLoggedIn:NO]);
    OCMVerify(ClassMethod([(id)profile resetUserProfile]));
    OCMVerify([self.rootViewControllerRouter setRootViewController:OCMOCK_ANY animated:YES]);
}

@end
