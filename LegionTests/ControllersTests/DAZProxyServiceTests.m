//
//  DAZProxyServiceTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 19.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "DAZProxyService.h"
#import "DAZCoreDataManager.h"
#import "DAZNetworkService.h"

#import "PartyMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"

@interface DAZProxyService (Tests) <DAZNetworkServiceDelegate>

@property (nonatomic, strong) DAZCoreDataManager *coreDataManager;
@property (nonatomic, strong) DAZNetworkService *networkService;

@end

@interface DAZProxyServiceTests : XCTestCase

@property (nonatomic, strong) DAZProxyService *proxyService;

@end

@implementation DAZProxyServiceTests

- (void)setUp
{
    [super setUp];
    
    DAZCoreDataManager *coreDataManager = OCMClassMock([DAZCoreDataManager class]);
    OCMStub(ClassMethod([(id)coreDataManager alloc])).andReturn(coreDataManager);
    
    DAZNetworkService *networkService = OCMClassMock([DAZNetworkService class]);
    OCMStub(ClassMethod([(id)networkService alloc])).andReturn(networkService);
    
    self.proxyService = OCMPartialMock([[DAZProxyService alloc] init]);
}

- (void)tearDown
{
    self.proxyService = nil;
    
    [super tearDown];
}

- (void)testIsServerReachable
{
    id networkService = self.proxyService.networkService;
    OCMStub([networkService isServerReachable]).andReturn(YES);
    
    BOOL isServerReachable = [self.proxyService isServerReachable];
    
    expect(isServerReachable).to.equal(YES);
}

- (void)testGetPartiesWhenServerIsReachable
{
    OCMStub([self.proxyService isServerReachable]).andReturn(YES);
    
    id networkService = self.proxyService.networkService;
    OCMStub([networkService downloadParties]);
    
    [self.proxyService downloadParties];
    
    OCMVerify([networkService downloadParties]);
}

- (void)testGetPartiesWhenServerNotReachable
{
    OCMStub([self.proxyService isServerReachable]).andReturn(NO);
    
    id coreDataManager = self.proxyService.coreDataManager;
    OCMStub([coreDataManager fetchParties]).andReturn([NSArray array]);
    
    id delegate = OCMProtocolMock(@protocol(DAZProxyServiceDelegate));
    self.proxyService.delegate = delegate;
    
    [self.proxyService downloadParties];
    
    OCMVerify([delegate proxyServiceDidFinishDownloadParties:[OCMArg isNotNil] networkStatus:DAZNetworkOffline]);
}



@end