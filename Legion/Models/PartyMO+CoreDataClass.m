//
//  PartyMO+CoreDataClass.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "PartyMO+CoreDataClass.h"

@implementation PartyMO


#pragma mark - Static Property

+ (NSString *)entityName
{
    return @"Party";
}

#pragma mark - Instance Accessors

+ (instancetype)partyWithContext:(NSManagedObjectContext *)context
{
    PartyMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                  inManagedObjectContext:context];
    
    return item;
}

+ (instancetype)partyWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary
{
    PartyMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                  inManagedObjectContext:context];
    
    NSDictionary *itemDictionary = dictionary;
    //BOOL dictionaryCorrect = YES;

    item.author = itemDictionary[@"author"];
    item.uid = itemDictionary[@"uid"];
    item.title = itemDictionary[@"title"];
    item.address = itemDictionary[@"address"];
    item.apartment = itemDictionary[@"apartment"];
    
    NSTimeInterval created = [itemDictionary[@"created"] doubleValue];
    item.created = [NSDate dateWithTimeIntervalSince1970:created];
    
    NSTimeInterval closed = [itemDictionary[@"closed"] doubleValue];
    item.closed = closed > 0 ? [NSDate new] : [NSDate dateWithTimeIntervalSince1970:closed];
    
    NSTimeInterval date = [itemDictionary[@"date"] doubleValue];
    item.date = [NSDate dateWithTimeIntervalSince1970:date];
    
    item.desc = itemDictionary[@"desc"];
    item.members = [itemDictionary[@"members"] intValue];
    
    item.status = itemDictionary[@"status"];
    
    return item;
}

+ (instancetype)partyWithContext:(NSManagedObjectContext *)context data:(NSData *)data {
    PartyMO *item = [self partyWithContext:context];
    
    return item;
}

#pragma mark - Creation

+ (NSString *)stringFromStatus:(DAZPartyStatus)status
{
    return @[@"Открыто", @"Закрыто"][status];
}

+ (DAZPartyStatus)statusFromString:(NSString *)status {
    if ([@"Открыто" isEqualToString:status]) {
        return DAZPartyStatusOpen;
    } else if ([@"Закрыто" isEqualToString:status]) {
        return DAZPartyStatusClosed;
    }
    
    return NSNotFound;
}

#pragma mark - Accessors
- (DAZPartyStatus)partyStatus
{
    return [PartyMO statusFromString:self.status];
}

- (void)setPartyStatus:(DAZPartyStatus)status
{
    self.status = [PartyMO stringFromStatus:status];
}

#pragma mark - Coding
- (NSDictionary *)dictionaryFromParty {
    return [NSDictionary dictionary];
}

- (NSData *)dataFromParty {
    return [NSData data];
}

#pragma mark - Basic

- (BOOL)saveParty
{
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)deleteParty {
    [self.managedObjectContext deleteObject:self];
    return [self saveParty];
}


@end
