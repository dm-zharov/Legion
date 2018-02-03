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

+ (NSArray<PartyMO *> *)partiesArrayWithArrayOfDictionaries:(NSArray<NSDictionary *> *)parties
{
    
    NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:[parties count]];
    for (NSDictionary *party in parties)
    {
        PartyMO *item = [PartyMO partyWithContext:[self coreDataContext] dictionary:party];
        if (!item)
        {
            partiesArray = nil;
        }
        else
        {
            [partiesArray addObject:item];
        }
    }
    
    return partiesArray;
}

+ (NSArray<ClaimMO *> *)claimsArrayWithArrayOfDictionaries:(NSArray<NSDictionary *> *)claims
{
    
    NSMutableArray *claimsArray = [NSMutableArray arrayWithCapacity:[claims count]];
    for (NSDictionary *claim in claims)
    {
        ClaimMO *item = [ClaimMO claimWithContext:[self coreDataContext] dictionary:claim];
        if (!item)
        {
            [claimsArray addObject:item];
        }
        else
        {
            return nil;
        }
    }
    
    return claimsArray;
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


#pragma mark - Parties Interface

- (NSArray<PartyMO *> *)fetchParties
{
    return [self fetchObjectsWithEntityName:[PartyMO entityName]];
}

- (void)saveParties:(NSArray<PartyMO *> *)parties
{
    [self saveObjects:parties];
}

- (void)saveParty:(PartyMO *)party
{
    [self saveObject:party];
}

- (void)deleteParty:(PartyMO *)party
{
    [self deleteObject:party];
}

#pragma mark - Claims Interface

- (NSArray<ClaimMO *> *)fetchClaims
{
    return [self fetchObjectsWithEntityName:[ClaimMO entityName]];
}

- (void)saveClaims:(NSArray<ClaimMO *> *)claims
{
    [self saveObjects:claims];
}

- (void)saveClaim:(ClaimMO *)claim
{
    [self updateCoreData];
}

- (void)deleteClaim:(ClaimMO *)claim
{
    [self deleteObject:claim];
}

#pragma mark - Accessors

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    //fetchRequest.fetchLimit = 1;
    
    //NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    //[fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error;
    NSArray *results = [self.coreDataContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetching error: %@", error);
    
    return results;
}

- (void)saveObjects:(NSArray *)objects
{
    for (id object in objects) {
        [self.coreDataContext insertObject:object];
    }
    [self updateCoreData];
}

- (void)saveObject:(id)object
{
    [self.coreDataContext insertObject:object];
    [self updateCoreData];
}

- (void)deleteObject:(id)object
{
    [self.coreDataContext deleteObject:object];
    [self updateCoreData];
}

- (BOOL)updateCoreData
{
    NSError *error;
    if ([self.coreDataContext hasChanges] && ![self.coreDataContext save:&error])
    {
        return NO;
    }
    
    return YES;
}

@end
