//
//  DAZProxyService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PartyMO, ClaimMO;


typedef NS_ENUM(NSInteger, DAZNetworkStatus) {
    DAZNetworkOnline = 1,
    DAZNetworkOffline,
};


@protocol DAZProxyServiceDelegate <NSObject>

@optional

- (void)proxyServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)parties networkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishAddPartyWithNetworkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishUpdatePartyWithNetworkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishDeletePartyWithNetworkStatus:(DAZNetworkStatus)status;

- (void)proxyServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)claims networkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishSendClaimWithNetworkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishUpdateClaimWithNetworkStatus:(DAZNetworkStatus)status;
- (void)proxyServiceDidFinishDeleteClaimWithNetworkStatus:(DAZNetworkStatus)status;

@end

@interface DAZProxyService : NSObject

@property (nonatomic, weak) id <DAZProxyServiceDelegate> delegate;

- (BOOL)isServerReachable;

- (void)downloadParties;
- (void)addParty:(PartyMO *)party;
- (void)updateParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

- (void)downloadClaims;
- (void)sendClaimForParty:(PartyMO *)party;
- (void)updateClaim:(ClaimMO *)claim;
- (void)deleteClaim:(ClaimMO *)claim;

@end
