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

#pragma mark - Parties

- (void)getParties
{
    if ([self isConnectionActive])
    {
        [self.networkService downloadParties];
    }
    else
    {
        [self.coreDataManager fetchParties];
    }
}

- (void)saveParty:(PartyMO *)party
{
    if ([self isConnectionActive])
    {
        [self.networkService uploadParty:[party dictionaryFromParty]];
    }
}

- (void)deleteParty:(PartyMO *)party {
    if ([self isConnectionActive])
    {
        [self.networkService deleteParty:[party dictionaryFromParty]];
    }
}

#pragma mark - Claims

- (void)getClaims
{
    if ([self isConnectionActive])
    {
        [self.networkService downloadClaims];
    }
    else
    {
        [self.coreDataManager fetchClaims];
    }
}

- (void)saveClaim:(ClaimMO *)claim
{
    if ([self isConnectionActive])
    {
        [self.networkService uploadClaim:[claim dictionaryFromClaim]];
    }
}

- (void)deleteClaim:(ClaimMO *)claim
{
    if ([self isConnectionActive])
    {
        [self.networkService deleteClaim:[claim dictionaryFromClaim]];
    }
}

#pragma mark - Internet connection test

- (BOOL)isConnectionActive
{
    // Тестирование активного соединения
    NSURL *serverURL = [NSURL URLWithString:@"https://us-central1-legion-svc.cloudfunctions.net/"];
    NSData *data = [NSData dataWithContentsOfURL:serverURL];
    
    return data ? YES : NO;
}

#pragma mark - DAZNetworkServiceDelegate

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties {
    NSArray *partiesArray = [[self.coreDataManager class] partiesArrayWithArrayOfDictionaries:parties];
    [self.coreDataManager saveParties:partiesArray];
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadParties:)])
    {
        [self.delegate proxyServiceDidFinishDownloadParties:partiesArray];
    }
}

- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claims {
    NSArray *claimsArray = [[self.coreDataManager class] claimsArrayWithArrayOfDictionaries:claims];
    [self.coreDataManager saveClaims:claimsArray];
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDownloadClaims:)])
    {
        [self.delegate proxyServiceDidFinishDownloadClaims:claimsArray];
    }
}

@end
