//
//  DAZNetworkService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DAZNetworkServicePartiesDelegate <NSObject>

@optional
- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties;
- (void)networkServiceDidFinishAddParty;
- (void)networkServiceDidFinishUpdateParty;
- (void)networkServiceDidFinishDeleteParty;

@end


@protocol DAZNetworkServiceClaimsDelegate <NSObject>

@optional
- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claimsDictionary;
- (void)networkServiceDidFinishSendClaim;
- (void)networkServiceDidFinishUpdateClaim;
- (void)networkServiceDidFinishDeleteClaim;

@end


@interface DAZNetworkService : NSObject

@property (nonatomic, weak) id <DAZNetworkServicePartiesDelegate> partiesDelegate;
@property (nonatomic, weak) id <DAZNetworkServiceClaimsDelegate> claimsDelegate;

- (BOOL)isServerReachable;

@end


@interface DAZNetworkService (Parties)

- (void)downloadParties;
- (void)addParty:(NSDictionary *)partyDictionary;
- (void)updateParty:(NSDictionary *)partyDictionary;
- (void)deleteParty:(NSDictionary *)partyDictionary;

@end


@interface DAZNetworkService (Claims)

- (void)downloadClaims;
- (void)sendClaimForPartyID:(NSString *)partyID;
- (void)updateClaim:(NSDictionary *)claimDictionary;
- (void)deleteClaim:(NSDictionary *)claimDictionary;

@end
