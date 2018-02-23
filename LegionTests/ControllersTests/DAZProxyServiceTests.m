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

@interface DAZProxyService (Tests) <DAZNetworkServicePartiesDelegate, DAZNetworkServiceClaimsDelegate>

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
    OCMExpect(ClassMethod([(id)coreDataManager alloc])).andReturn(coreDataManager);
    
    DAZNetworkService *networkService = OCMClassMock([DAZNetworkService class]);
    OCMExpect(ClassMethod([(id)networkService alloc])).andReturn(networkService);
    
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
    OCMExpect([networkService isServerReachable]).andReturn(YES);
    
    BOOL isServerReachable = [self.proxyService isServerReachable];
    
    expect(isServerReachable).to.equal(YES);
}

- (void)testGetPartiesWhenServerIsReachable
{
    OCMExpect([self.proxyService isServerReachable]).andReturn(YES);
    
    id networkService = self.proxyService.networkService;
    OCMStub([networkService downloadParties]);
    
    [self.proxyService downloadParties];
    
    OCMVerify([networkService downloadParties]);
}

- (void)testGetPartiesWhenServerNotReachable
{
    OCMExpect([self.proxyService isServerReachable]).andReturn(NO);
    
    id coreDataManager = self.proxyService.coreDataManager;
    OCMStub([coreDataManager fetchParties]).andReturn([NSArray array]);
    
    id delegate = OCMProtocolMock(@protocol(DAZProxyServicePartiesDelegate));
    self.proxyService.partiesDelegate = delegate;
    
    [self.proxyService downloadParties];
    
    OCMVerify([delegate proxyServiceDidFinishDownloadParties:[OCMArg isNotNil] networkStatus:DAZNetworkOffline]);
}

- (void)testAddPartyWhenServerIsReachable
{
    OCMExpect([self.proxyService isServerReachable]).andReturn(YES);
    PartyMO *party = OCMClassMock([PartyMO class]);

    id networkService = self.proxyService.networkService;
    OCMStub([networkService addParty:party]);

    OCMStub([party dictionary]).andReturn([NSDictionary new]);

    [self.proxyService addParty:party];

    OCMVerify([networkService addParty:[OCMArg isKindOfClass:[NSDictionary class]]]);
}

- (void)testAddPartyWhenServerNotReachable
{
    OCMStub([self.proxyService isServerReachable]).andReturn(NO);

    id delegate = OCMProtocolMock(@protocol(DAZProxyServicePartiesDelegate));
    self.proxyService.partiesDelegate = delegate;

    PartyMO *party = OCMClassMock([PartyMO class]);

    [self.proxyService addParty:party];

    OCMVerify([delegate proxyServiceDidFinishAddPartyWithNetworkStatus:DAZNetworkOffline]);
}

@end
