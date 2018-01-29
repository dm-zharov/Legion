//
//  PartyMO+CoreDataClass.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "PartyMO+CoreDataClass.h"

@implementation PartyMO

#pragma mark - Static Properties

+ (NSString *)entityName
{
    return @"Party";
}

#pragma mark - Creation

+ (PartyMO *)partyWithContext:(NSManagedObjectContext *)managedObjectContext
{
    PartyMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                  inManagedObjectContext:managedObjectContext];
    
    return item;
}

+ (NSString *)stringFromStatus:(DAZPartyStatus)status
{
    return @[@"Открыто", @"Закрыто"][status];
}

+ (DAZPartyStatus)statusFromString:(NSString *)string {
    if ([@"Открыто" isEqualToString:string]) {
        return DAZPartyStatusOpen;
    } else if ([@"Закрыто" isEqualToString:string]) {
        return DAZPartyStatusClosed;
    }
    
    return NSNotFound;
}

- (DAZPartyStatus)partyStatus {
    return [PartyMO statusFromString:self.status];
}

- (void)setPartyStatus:(DAZPartyStatus)status {
    self.status = [PartyMO stringFromStatus:status];
}

#pragma mark - Basic

- (BOOL)saveObject
{
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)deleteObject {    
    [self.managedObjectContext deleteObject:self];
    return [self saveObject];
}



@end
