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


@interface DAZProxyService () <DAZNetworkServicePartiesDelegate, DAZNetworkServiceClaimsDelegate>

@property (nonatomic, strong) DAZCoreDataManager *coreDataManager;
@property (nonatomic, strong) DAZNetworkService *networkService;

@end


@implementation DAZProxyService


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coreDataManager = [[DAZCoreDataManager alloc] init];
        
        _networkService = [[DAZNetworkService alloc] init];
        _networkService.partiesDelegate = self;
        _networkService.claimsDelegate = self;
    }
    return self;
}


#pragma mark - Reachability Testing

- (BOOL)isServerReachable
{
    return [self.networkService isServerReachable];
}

@end

@implementation  DAZProxyService (Parties)


#pragma mark - Parties Accessors

- (void)downloadParties
{
    if ([self isServerReachable])
    {
        [self.networkService downloadParties];
    }
    else
    {
        NSArray<PartyMO *> *partiesArray = [self.coreDataManager fetchParties];
        if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:networkStatus:)])
        {
            [self.partiesDelegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOffline];
        }
    }
}

- (void)addParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService addParty:[party dictionary]];
    }
    else
    {
        if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishAddPartyWithNetworkStatus:)])
        {
            [self.partiesDelegate proxyServiceDidFinishAddPartyWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)updateParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService updateParty:[party dictionary]];
    }
    else
    {
        if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishUpdatePartyWithNetworkStatus:)])
        {
            [self.partiesDelegate proxyServiceDidFinishUpdatePartyWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)deleteParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService deleteParty:[party dictionary]];
        [party deleteParty];
    }
    else
    {
        if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishDeletePartyWithNetworkStatus:)])
        {
            [self.partiesDelegate proxyServiceDidFinishDeletePartyWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

#pragma mark - DAZNetworkServiceDelegate

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties
{
    // Мы получили новые данные, кешированные в базу данных вечеринки могли утратить актуальность
    [self.coreDataManager removeParties];
    
    NSArray *partiesArray = [[self.coreDataManager class] partiesArrayByDictionariesArray:parties];
    
    if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:networkStatus:)])
    {
        [self.partiesDelegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOnline];
    }
    
    // Сохраняем обновленные вечеринки
    [self.coreDataManager saveContext];
}

- (void)networkServiceDidFinishAddParty
{
    if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishAddPartyWithNetworkStatus:)])
    {
        [self.partiesDelegate proxyServiceDidFinishAddPartyWithNetworkStatus:DAZNetworkOnline];
    }
}

- (void)networkServiceDidFinishDeleteParty
{
    if ([self.partiesDelegate respondsToSelector:@selector(proxyServiceDidFinishDeletePartyWithNetworkStatus:)])
    {
        [self.partiesDelegate proxyServiceDidFinishDeletePartyWithNetworkStatus:DAZNetworkOnline];
    }
}

@end

@implementation DAZProxyService (Claims)


#pragma mark - Claims Accessors

- (void)downloadClaims
{
    if ([self isServerReachable])
    {
        [self.networkService downloadClaims];
    }
    else
    {
        NSArray<ClaimMO *> *claimsArray = [self.coreDataManager fetchClaims];
        if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:networkStatus:)])
        {
            [self.claimsDelegate proxyServiceDidFinishDownloadClaims:claimsArray networkStatus:DAZNetworkOffline];
        }
        
    }
}

- (void)sendClaimForParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService sendClaimForPartyID:party.partyID];
    }
    else
    {
        if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishSendClaimWithNetworkStatus:)])
        {
            [self.claimsDelegate proxyServiceDidFinishSendClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)updateClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService updateClaim:[claim dictionary]];
    }
    else
    {
        if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishUpdateClaimWithNetworkStatus:)])
        {
            [self.claimsDelegate proxyServiceDidFinishUpdateClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)deleteClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService deleteClaim:[claim dictionary]];
        [claim deleteClaim];
    }
    else
    {
        if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishDeleteClaimWithNetworkStatus:)])
        {
            [self.claimsDelegate proxyServiceDidFinishDeleteClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
        
}


#pragma mark - DAZNetworkServiceDelegate

- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claims
{
    // Мы получили новые данные, кешированные в базу данных запросы могли утратить актуальность
    [self.coreDataManager removeClaims];
    
    NSArray *claimsArray = [[self.coreDataManager class] claimsArrayByDictionariesArray:claims];
    
    if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:networkStatus:)])
    {
        [self.claimsDelegate proxyServiceDidFinishDownloadClaims:claimsArray networkStatus:DAZNetworkOnline];
    }
    
    // Сохраняем обновленные запросы
    [self.coreDataManager saveContext];
}

- (void)networkServiceDidFinishSendClaim
{
    if ([self.claimsDelegate respondsToSelector:@selector(proxyServiceDidFinishSendClaimWithNetworkStatus:)])
    {
        [self.claimsDelegate proxyServiceDidFinishSendClaimWithNetworkStatus:DAZNetworkOnline];
    }
}

@end
