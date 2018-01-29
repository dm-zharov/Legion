//
//  DAZPartiesFacade.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZPartiesFacade.h"
#import "DAZCoreDataManager.h"
#import "DAZNetworkService.h"

#import "PartyMO+CoreDataClass.h"

@interface DAZPartiesFacade () <DAZNetworkServiceDelegate>

@property (nonatomic, strong) DAZCoreDataManager *coreDataManager;
@property (nonatomic, strong) DAZNetworkService *networkService;

@end

@implementation DAZPartiesFacade

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

- (NSArray<PartyMO *> *)getParties
{
    NSArray *parties = [NSArray new];
    parties = [self.coreDataManager fetchParties];
    [self.networkService downloadParties];
    
    return parties;
}

- (void)saveParty:(PartyMO *)party {
    [self.coreDataManager saveParty:party];
    [self.networkService uploadParty:party];
}

- (void)deleteParty:(PartyMO *)party {
    
}

#pragma mark - Claims

- (NSArray<ClaimMO *> *)getClaims
{
    NSArray *claims = [NSArray new];
    claims = [self.coreDataManager fetchClaims];
    [self.networkService downloadClaims];
    
    return claims;
}

- (void)saveClaim:(ClaimMO *)claim
{
    [self.coreDataManager saveClaim:claim];
    [self.networkService uploadClaim:claim];
}

- (void)removeClaim:(ClaimMO *)claim {
    [self.coreDataManager deleteClaim:claim];
    [self.networkService deleteClaim:claim];
}

- (void)networkServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)parties {
    [self.coreDataManager saveParties:parties];
    //[self.delegate respondsToSelector:<#(SEL)#>]
}

- (void)networkServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)claims {
    
}

@end
