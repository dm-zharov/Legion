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

@end

@implementation DAZCoreDataManager


#pragma mark - Instance Accessors

+ (NSManagedObjectContext *)coreDataContext
{
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate =  (AppDelegate*)application.delegate;
    
    NSPersistentContainer *container = appDelegate.persistentContainer;
    return container.viewContext;
}

+ (NSArray<PartyMO *> *)convertPartiesArray:(NSArray<NSDictionary *> *)parties
{
    NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:[parties count]];
    for (NSDictionary *party in parties)
    {
        PartyMO *item = [PartyMO partyWithContext:[self coreDataContext] dictionary:party];
        if (!item)
        {
            partiesArray = nil;
            return partiesArray;
        }
        else
        {
            [partiesArray addObject:item];
        }
    }
    
    return partiesArray;
}

+ (NSArray<ClaimMO *> *)convertClaimsArray:(NSArray<NSDictionary *> *)claims
{
    NSMutableArray *claimsArray = [NSMutableArray arrayWithCapacity:[claims count]];
    for (NSDictionary *claim in claims)
    {
        ClaimMO *item = [ClaimMO claimWithContext:[self coreDataContext] dictionary:claim];
        if (!item)
        {
            claimsArray = nil;
            return claimsArray;
        }
        else
        {
            [claimsArray addObject:item];
        }
    }
    
    return claimsArray;
}

+ (NSArray<NSArray *> *)incomeAndOutcomeArraysFromClaimsArray:(NSArray<ClaimMO *> *)claims
{
    NSMutableArray *outcomeArray = [NSMutableArray new];
    NSMutableArray *incomeArray = [NSMutableArray new];
    
    for (ClaimMO *claim in claims)
    {
        if (claim.authorID != [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            [outcomeArray addObject:claim];
        }
        else
        {
            [incomeArray addObject:claim];
        }
    }
    
    NSArray *devidedArray = @[outcomeArray, incomeArray];
    return devidedArray;
    
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


#pragma mark - Parties Selectors

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

#pragma mark - Claims Selectors

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

#pragma mark - CoreData Accessors

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    //fetchRequest.fetchLimit = 1;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
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

- (void)saveObjects:(NSArray *)objects
{
    for (id object in objects) {
        [self.coreDataContext insertObject:object];
    }
    
    [self saveContext];
}

- (void)deleteObjects:(NSArray *)objects
{
    for (id object in objects) {
        [self.coreDataContext deleteObject:object];
    }
    
    [self saveContext];
}

- (void)saveObject:(id)object
{
    [self.coreDataContext insertObject:object];
    [self saveContext];
}

- (void)deleteObject:(id)object
{
    [self.coreDataContext deleteObject:object];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error;
    if ([self.coreDataContext hasChanges] && ![self.coreDataContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
}

@end
