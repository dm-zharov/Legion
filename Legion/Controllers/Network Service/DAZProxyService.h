//
//  DAZProxyService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAZNetworkService.h"

@class PartyMO, ClaimMO;

@protocol DAZProxyServiceDelegate <NSObject>

@optional
- (void)proxyServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)array;
- (void)proxyServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)array;

@end

@interface DAZProxyService : NSObject

@property (nonatomic, weak) id <DAZProxyServiceDelegate> delegate;

- (void)getParties;
- (void)saveParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

- (void)getClaims;
- (void)saveClaim:(ClaimMO *)claim;
- (void)deleteClaim:(ClaimMO *)claim;

@end
