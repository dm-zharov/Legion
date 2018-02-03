//
//  DAZCoreDataManager.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PartyMO;
@class ClaimMO;
@class UserMO;

@interface DAZCoreDataManager : NSObject

@property (nonatomic, weak) NSManagedObjectContext *coreDataContext;

+ (NSManagedObjectContext *)coreDataContext;

+ (NSArray<PartyMO *> *)partiesArrayWithArrayOfDictionaries:(NSArray<NSDictionary *> *)parties;
+ (NSArray<ClaimMO *> *)claimsArrayWithArrayOfDictionaries:(NSArray<NSDictionary *> *)claimsDictionary;

- (NSArray<PartyMO*> *)fetchParties;
- (void)saveParties:(NSArray<PartyMO *> *)parties;
- (void)saveParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

- (NSArray<ClaimMO *> *)fetchClaims;
- (void)saveClaims:(NSArray<ClaimMO *> *)claims;
- (void)saveClaim:(ClaimMO *)claim;
- (void)deleteClaim:(ClaimMO *)claim;

@end
