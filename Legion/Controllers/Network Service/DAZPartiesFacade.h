//
//  DAZPartiesFacade.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartyMO, ClaimMO;

@protocol DAZPartiesFacadeDelegate <NSObject>

@optional
- (void)partiesFacadeDidFinishUpdateParties:(NSArray<PartyMO *> *)parties;;
- (void)partiesFacadeDidFinishUpdateClaims:(NSArray<ClaimMO *> *)claims;

@end

@interface DAZPartiesFacade : NSObject

@property (nonatomic, weak) id <DAZPartiesFacadeDelegate> delegate;

- (NSArray<PartyMO *> *)getParties;
- (void)saveParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

- (NSArray<ClaimMO *> *)getClaims;
- (void)saveClaim:(ClaimMO *)claim;
- (void)deleteClaim:(ClaimMO *)claim;

@end
