//
//  DAZProxyService.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZProxyService.h"
#import "DAZCoreDataManager.h"
#import "DAZNetworkService.h"

#import "PartyMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"

@interface DAZProxyService () <DAZNetworkServiceDelegate>

@property (nonatomic, strong) DAZCoreDataManager *coreDataManager;
@property (nonatomic, strong) DAZNetworkService *networkService;

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties;
- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claims;

@end

@implementation DAZProxyService

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coreDataManager = [[DAZCoreDataManager alloc] init];
        _networkService = [[DAZNetworkService alloc] init];
        
        _networkService.delegate = self;
    }
    return self;
}

#pragma mark - Reachability

- (BOOL)isServerReachable
{
    return [self.networkService isServerReachable];
}

#pragma mark - Parties

- (void)getParties
{
    if ([self isServerReachable])
    {
        [self.networkService downloadParties];
    }
    else
    {
        NSArray<PartyMO *> *partiesArray = [self.coreDataManager fetchParties];
        [self.delegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOffline];
    }
}

- (void)addParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService addParty:[party dictionary]];
    }
}

- (void)updateParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService updateParty:[party dictionary]];
    }
}

- (void)deleteParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService deleteParty:[party dictionary]];
    }
}

#pragma mark - Claims

- (void)sendClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService sendClaim:[claim dictionaryFromClaim]];
    }
}

- (void)updateClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService updateClaim:[claim dictionaryFromClaim]];
    }
}

- (void)deleteClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService deleteClaim:[claim dictionaryFromClaim]];
    }
}

#pragma mark - DAZNetworkServiceDelegate

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties
{
    [self.coreDataManager removeParties];
    NSArray *partiesArray = [[self.coreDataManager class] partiesArrayByArrayOfDictionaries:parties];
    
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:networkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOnline];
    }
    
    [self.coreDataManager saveContext];
}

- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claims
{
    [self.coreDataManager removeClaims];
    NSArray *claimsArray = [[self.coreDataManager class] claimsArrayByArrayOfDictionaries:claims];
    
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:networkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDownloadClaims:claimsArray networkStatus:DAZNetworkOnline];
    }
    
    [self.coreDataManager saveContext];
}

@end
