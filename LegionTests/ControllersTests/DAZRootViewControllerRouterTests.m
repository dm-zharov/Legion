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
#import "DAZUserProfile.h"

@interface DAZRootViewControllerRouter (Tests)

@property (nonatomic, strong) DAZUserProfile *profile;

@property (nonatomic, readonly) UIViewController *firstViewController;
@property (nonatomic, readonly) UIViewController *secondViewController;
@property (nonatomic, readonly) UIViewController *thirdViewController;

// Обработка сообщений от центра нотификаций
- (void)authorizationTokenReceived:(NSNotification *)notification;
- (void)authorizationTokenExpired:(NSNotification *)notification;

@end

@interface DAZRootViewControllerRouterTests : XCTestCase

@end

@implementation DAZRootViewControllerRouterTests

- (void)setUp
{
    [super setUp];
    
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);
    
    OCMStub([DAZUserProfile alloc])._andReturn;
    
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testExample
{
    
}

@end
