//
//  DAZNetworkService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DAZNetworkServiceDelegate <NSObject>

@optional

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties;
- (void)networkServiceDidFinishAddParty;
- (void)networkServiceDidFinishUpdateParty;
- (void)networkServiceDidFinishDeleteParty;

- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claimsDictionary;
- (void)networkServiceDidFinishSendClaim;
- (void)networkServiceDidFinishUpdateClaim;
- (void)networkServiceDidFinishDeleteClaim;

@end

@interface DAZNetworkService : NSObject

@property (nonatomic, weak) id <DAZNetworkServiceDelegate> delegate;

- (BOOL)isServerReachable;

- (void)downloadParties;
- (void)addParty:(NSDictionary *)partyDictionary;
- (void)updateParty:(NSDictionary *)partyDictionary;
- (void)deleteParty:(NSDictionary *)partyDictionary;

- (void)downloadClaims;
- (void)sendClaimForParty:(NSDictionary *)partyDictionary;
- (void)updateClaim:(NSDictionary *)claimDictionary;
- (void)deleteClaim:(NSDictionary *)claimDictionary;

#ifdef DEBUG
- (void)setTestData;
#endif

@end
