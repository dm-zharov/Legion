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

@interface DAZCoreDataManager : NSObject

@property (nonatomic, weak) NSManagedObjectContext *coreDataContext;

+ (NSManagedObjectContext *)coreDataContext;

+ (NSArray<PartyMO *> *)partiesArrayByDictionariesArray:(NSArray<NSDictionary *> *)parties;
+ (NSArray<ClaimMO *> *)claimsArrayByDictionariesArray:(NSArray<NSDictionary *> *)claims;

- (NSArray<PartyMO*> *)fetchParties;
- (void)saveParties:(NSArray<PartyMO *> *)parties;
- (void)removeParties;

- (NSArray<ClaimMO *> *)fetchClaims;
- (void)saveClaims:(NSArray<ClaimMO *> *)claims;
- (void)removeClaims;

- (void)saveContext;

@end
