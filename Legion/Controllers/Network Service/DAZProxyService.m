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


#pragma mark - Reachability Testing

- (BOOL)isServerReachable
{
    return [self.networkService isServerReachable];
}


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
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:networkStatus:)])
        {
            [self.delegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOffline];
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
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishAddPartyWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishAddPartyWithNetworkStatus:DAZNetworkOffline];
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
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishUpdatePartyWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishUpdatePartyWithNetworkStatus:DAZNetworkOffline];
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
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDeletePartyWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishDeletePartyWithNetworkStatus:DAZNetworkOffline];
        }
    }
}


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
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:networkStatus:)])
        {
            [self.delegate proxyServiceDidFinishDownloadClaims:claimsArray networkStatus:DAZNetworkOffline];
        }
        
    }
}

- (void)sendClaimForParty:(PartyMO *)party
{
    if ([self isServerReachable])
    {
        [self.networkService sendClaimForParty:[party dictionary]];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishSendClaimWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishSendClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)updateClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService updateClaim:[claim dictionaryFromClaim]];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishUpdateClaimWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishUpdateClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
}

- (void)deleteClaim:(ClaimMO *)claim
{
    if ([self isServerReachable])
    {
        [self.networkService deleteClaim:[claim dictionaryFromClaim]];
        [claim deleteClaim];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDeleteClaimWithNetworkStatus:)])
        {
            [self.delegate proxyServiceDidFinishDeleteClaimWithNetworkStatus:DAZNetworkOffline];
        }
    }
        
}


#pragma mark - DAZNetworkServiceDelegate

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties
{
    // Мы получили новые данные, кешированные в базу данных вечеринки могли утратить актуальность
    [self.coreDataManager removeParties];
    
    NSArray *partiesArray = [[self.coreDataManager class] partiesArrayByDictionariesArray:parties];
    
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:networkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDownloadParties:partiesArray networkStatus:DAZNetworkOnline];
    }
    
    // Сохраняем обновленные вечеринки
    [self.coreDataManager saveContext];
}

- (void)networkServiceDidFinishAddParty
{
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishAddPartyWithNetworkStatus:)])
    {
        [self.delegate proxyServiceDidFinishAddPartyWithNetworkStatus:DAZNetworkOnline];
    }
}

- (void)networkServiceDidFinishDeleteParty
{
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDeletePartyWithNetworkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDeletePartyWithNetworkStatus:DAZNetworkOnline];
    }
}

- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claims
{
    // Мы получили новые данные, кешированные в базу данных запросы могли утратить актуальность
    [self.coreDataManager removeClaims];
    
    NSArray *claimsArray = [[self.coreDataManager class] claimsArrayByDictionariesArray:claims];
    
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:networkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDownloadClaims:claimsArray networkStatus:DAZNetworkOnline];
    }
    
    // Сохраняем обновленные запросы
    [self.coreDataManager saveContext];
}

- (void)networkServiceDidFinishSendClaim
{
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishSendClaimWithNetworkStatus:)])
    {
        [self.delegate proxyServiceDidFinishSendClaimWithNetworkStatus:DAZNetworkOnline];
    }
}

@end
