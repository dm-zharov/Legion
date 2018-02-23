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

@property (readonly, class) NSPersistentContainer *persistentContainer;
@property (readonly, class) NSManagedObjectContext *coreDataContext;

- (void)saveContext;

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName;
- (void)removeObjectsWithEntityName:(NSString *)entityName;
- (void)saveObjects:(NSArray *)objects;
- (void)deleteObjects:(NSArray *)objects;

@end


@interface DAZCoreDataManager (Parties)

+ (NSArray<PartyMO *> *)partiesArrayByDictionariesArray:(NSArray<NSDictionary *> *)parties;

- (NSArray<PartyMO*> *)fetchParties;
- (void)saveParties:(NSArray<PartyMO *> *)parties;
- (void)removeParties;

@end


@interface DAZCoreDataManager (Claims)

+ (NSArray<ClaimMO *> *)claimsArrayByDictionariesArray:(NSArray<NSDictionary *> *)claims;

- (NSArray<ClaimMO *> *)fetchClaims;
- (void)saveClaims:(NSArray<ClaimMO *> *)claims;
- (void)removeClaims;

@end
