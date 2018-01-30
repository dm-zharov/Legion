//
//  DAZNetworkService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAZCoreDataManager, PartyMO, ClaimMO;

@protocol DAZNetworkServiceDelegate <NSObject>

- (void)networkServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)parties;
- (void)networkServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)claims;

@end

@interface DAZNetworkService : NSObject

@property (nonatomic, weak) id <DAZNetworkServiceDelegate> delegate;

- (void)downloadParties;
- (void)uploadParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

- (void)downloadClaims;
- (void)uploadClaim:(ClaimMO *)claim;
- (void)deleteClaim:(ClaimMO *)claim;

@end
