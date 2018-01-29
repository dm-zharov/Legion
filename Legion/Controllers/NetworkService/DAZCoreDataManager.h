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

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (weak, readonly) NSManagedObjectContext *managedObjectContext;

- (NSArray<PartyMO*> *)fetchParties;
- (void)saveParties:(NSArray<PartyMO *> *)parties;

@end
