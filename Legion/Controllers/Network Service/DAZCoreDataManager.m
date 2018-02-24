//
//  DAZCoreDataManager.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "AppDelegate.h"

#import "DAZCoreDataManager.h"
#import "PartyMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"


@interface DAZCoreDataManager ()

@property (nonatomic, weak) NSManagedObjectContext *coreDataContext;

@end

@implementation DAZCoreDataManager


#pragma mark - Core Data stack

+ (NSPersistentContainer *)persistentContainer
{
    static NSPersistentContainer *_persistentContainer;
    
    if (_persistentContainer == nil)
    {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Legion"];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                 abort();
             }
         }];
    }
    
    return _persistentContainer;
}

+ (NSManagedObjectContext *)coreDataContext
{
    NSPersistentContainer *container = self.persistentContainer;
    return container.viewContext;
}


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coreDataContext = [[self class] coreDataContext];
    }
    return self;
}


#pragma mark - CoreData Accessors

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *results = [self.coreDataContext executeFetchRequest:fetchRequest error:&error];
    
    if (!results)
    {
        NSLog(@"Fetching error: %@", error);
        return nil;
    }
    
    return results;
}

- (void)removeObjectsWithEntityName:(NSString *)entityName
{
    NSArray *removableObjects = [self fetchObjectsWithEntityName:entityName];
    
    for (id object in removableObjects) {
        [self.coreDataContext deleteObject:object];
    }
}


#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *context = [[self class] coreDataContext];
    
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)saveObjects:(NSArray *)objects
{
    [self saveContext];
}

- (void)deleteObjects:(NSArray *)objects
{
    for (id object in objects) {
        [self.coreDataContext deleteObject:object];
    }
    
    [self saveContext];
}

@end


@implementation DAZCoreDataManager (Parties)


#pragma mark - Instance Accesors

+ (NSArray<PartyMO *> *)partiesArrayByDictionariesArray:(NSArray<NSDictionary *> *)parties
{
    NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:parties.count];
    for (NSDictionary *party in parties)
    {
        PartyMO *item = [PartyMO partyWithContext:[self coreDataContext] dictionary:party];
        if (!item)
        {
            return nil;
        }
        else
        {
            [partiesArray addObject:item];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];    
    NSArray *result = [partiesArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return result;
}


#pragma mark - Parties Accessors

- (NSArray<PartyMO *> *)fetchParties
{
    return [self fetchObjectsWithEntityName:[PartyMO entityName]];
}

- (void)saveParties:(NSArray<PartyMO *> *)parties
{
    [self saveObjects:parties];
}

- (void)removeParties
{
    [self removeObjectsWithEntityName:[PartyMO entityName]];
}

@end

@implementation DAZCoreDataManager (Claims)


#pragma mark - Instance Accesors

+ (NSArray<ClaimMO *> *)claimsArrayByDictionariesArray:(NSArray<NSDictionary *> *)claims
{
    NSMutableArray *claimsArray = [NSMutableArray arrayWithCapacity:claims.count];
    for (NSDictionary *claim in claims)
    {
        ClaimMO *item = [ClaimMO claimWithContext:[self coreDataContext] dictionary:claim];
        if (!item)
        {
            return nil;
        }
        else
        {
            [claimsArray addObject:item];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *result = [claimsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return result;
}


#pragma mark - Claims Accessors

- (NSArray<ClaimMO *> *)fetchClaims
{
    return [self fetchObjectsWithEntityName:[ClaimMO entityName]];
}

- (void)saveClaims:(NSArray<ClaimMO *> *)claims
{
    [self saveObjects:claims];
}

- (void)removeClaims
{
    [self removeObjectsWithEntityName:[ClaimMO entityName]];
}

@end
