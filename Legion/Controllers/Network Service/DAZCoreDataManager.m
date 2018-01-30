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
#import "UserMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"


@interface DAZCoreDataManager ()

@end

@implementation DAZCoreDataManager

#pragma mark - Accessors

- (NSManagedObjectContext*)coreDataContext
{
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate =  (AppDelegate*)application.delegate;
    
    NSPersistentContainer *container = appDelegate.persistentContainer;
    return container.viewContext;
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

- (void)saveParty:(PartyMO *)party
{
    [self saveObject:party];
}

- (void)deleteParty:(PartyMO *)party
{
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

- (void)saveClaim:(ClaimMO *)claim
{
    [self updateCoreData];
}

- (void)deleteClaim:(ClaimMO *)claim
{
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
    
    NSError *error;
        results = [self.coreDataContext executeFetchRequest:fetchRequest error:&error];
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
