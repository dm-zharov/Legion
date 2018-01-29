//
//  DAZCoreDataManager.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZCoreDataManager.h"

#import "PartyMO+CoreDataClass.h"
#import "ClaimMO+CoreDataClass.h"
#import "UserMO+CoreDataClass.h"

@interface DAZCoreDataManager ()

@end

@implementation DAZCoreDataManager

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DataModel"];
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

- (BOOL)saveManagedObjectContext
{
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"CoreData save error: %@", error.localizedDescription);
        return NO;
    } else {
        return YES;
    }
}

- (NSArray<PartyMO *> *)fetchParties {
    __block NSArray *results;
    
    NSFetchRequest *fetchRequest = [PartyMO fetchRequest];
    // fetchRequest.fetchLimit = 1;
    
    //NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    //[fetchRequest setSortDescriptors:@[sort]];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error;
        results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"Fetching error: %@", error);
    }];
    
    NSLog(@"Parties count: %ld", results.count);
    
    return results;
}

- (void)saveParties:(NSArray<PartyMO *> *)parties {
    
}

- (void)deleteParty:(PartyMO *)party {
    [self.managedObjectContext deleteObject:party];
    [self saveManagedObjectContext];
}

@end
