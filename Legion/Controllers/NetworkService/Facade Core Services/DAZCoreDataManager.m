//
//  DAZCoreDataManager.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZCoreDataManager.h"
#import "PartyMO+CoreDataClass.h"
#import "UserMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"

@interface DAZCoreDataManager ()

@end

@implementation DAZCoreDataManager

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Legion"];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
            if (error != nil)
            {
                NSLog(@"Failed to load Core Data stack: %@", error);
                abort();
            }
            else
            {
                _managedObjectContext = _persistentContainer.viewContext;
            }
        }];
    }
    return self;
}

#pragma mark - Parties

- (NSArray<PartyMO *> *)fetchParties
{
    return [self fetchObjectsWithEntityName:[PartyMO entityName]];
}

- (void)saveParties:(NSArray<PartyMO *> *)parties
{
    [self saveObjects:parties];
}

- (void)saveParty:(PartyMO *)party {
    [self saveObject:party];
}

- (void)deleteParty:(PartyMO *)party {
    [self deleteObject:party];
}

- (NSArray<ClaimMO *> *)fetchClaims
{
    return [self fetchObjectsWithEntityName:[ClaimMO entityName]];
}

- (void)saveClaims:(NSArray<ClaimMO *> *)claims
{
    [self saveObjects:claims];
}

- (void)saveClaim:(ClaimMO *)claim {
    [self saveObject:claim];
}

- (void)deleteClaim:(ClaimMO *)claim {
    [self deleteObject:claim];
}

#pragma mark - Objects fetching

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
{
    __block NSArray *results;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    //fetchRequest.fetchLimit = 1;
    
    //NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    //[fetchRequest setSortDescriptors:@[sort]];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error;
        results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"Fetching error: %@", error);
    }];
    
    NSLog(@"Object count: %ld", results.count);
    
    return results;
}

- (void)saveObjects:(NSArray *)objects {
    for (id object in objects) {
        [self.managedObjectContext insertObject:object];
    }
    [self updateCoreData];
}

- (void)saveObject:(id)object {
    [self.managedObjectContext insertObject:object];
}

- (void)deleteObject:(id)object {
    [self.managedObjectContext deleteObject:object];
    [self updateCoreData];
}

- (BOOL)updateCoreData
{
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        return NO;
    }
    
    return YES;
}

@end
