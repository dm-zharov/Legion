//
//  DAZNetworkService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAZNetworkServiceDelegate <NSObject>

- (void)networkServiceDidFinishDownloadParties:(NSArray<NSDictionary *> *)parties;
- (void)networkServiceDidFinishDownloadClaims:(NSArray<NSDictionary *> *)claimsDictionary;

@end

@interface DAZNetworkService : NSObject

@property (nonatomic, weak) id <DAZNetworkServiceDelegate> delegate;

- (void)downloadParties;
- (void)uploadParty:(NSDictionary *)partyDictionary;
- (void)deleteParty:(NSDictionary *)partyDictionary;

- (void)downloadClaims;
- (void)uploadClaim:(NSDictionary *)claimDictionary;
- (void)deleteClaim:(NSDictionary *)claimDictionary;

@end
