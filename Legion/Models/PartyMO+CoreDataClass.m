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
    PartyMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    
    return item;
}

+ (instancetype)partyWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary
{
    PartyMO *item = [self partyWithContext:context];
    
    if (dictionary[@"partyID"])
    {
        item.partyID = dictionary[@"partyID"];
    }
    
    if (dictionary[@"title"])
    {
        item.title = dictionary[@"title"];
    }
    
    if (dictionary[@"authorID"])
    {
        item.authorID = dictionary[@"authorID"];
    }
    
    if (dictionary[@"ownership"])
    {
        item.ownership = [dictionary[@"ownership"] boolValue];
    }
    
    if (dictionary[@"authorName"])
    {
        item.authorName = dictionary[@"authorName"];
    }

    if (dictionary[@"photoURL"])
    {
        NSURL *photoURL = [NSURL URLWithString:dictionary[@"photoURL"]];
        item.photoURL = photoURL;
    }
    
    if (dictionary[@"address"])
    {
        item.address = dictionary[@"address"];
    }

    if (dictionary[@"apartment"])
    {
        item.apartment = dictionary[@"apartment"];
    }
    
    NSTimeInterval created = dictionary[@"created"] ? [dictionary[@"created"] doubleValue] : 0;
    item.created = [NSDate dateWithTimeIntervalSince1970:created];
    
    NSTimeInterval closed = dictionary[@"closed"] ? [dictionary[@"closed"] doubleValue] : 0;
    item.closed = [NSDate dateWithTimeIntervalSince1970:closed];
    
    NSTimeInterval date = dictionary[@"date"] ? [dictionary[@"date"] doubleValue] : 0;
    item.date = [NSDate dateWithTimeIntervalSince1970:date];
    
    if (dictionary[@"desc"])
    {
        item.desc = dictionary[@"desc"];
    }

    item.members = dictionary[@"members"] ? [dictionary[@"members"] intValue] : 0;
    
    if (dictionary[@"status"])
    {
        item.status = dictionary[@"status"];
    }
    
    return item;
}

+ (NSDictionary *)dictionaryFromParty:(PartyMO *)party
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (party.partyID)
    {
        dictionary[@"partyID"] = party.partyID;
    }
    
    if (party.title)
    {
        dictionary[@"title"] = party.title;
    }
    
    if (party.authorID)
    {
        dictionary[@"authorID"] = party.authorID;
    }
    
    dictionary[@"ownership"] = [NSString stringWithFormat:@"%d", party.ownership];
    
    if (party.authorName)
    {
        dictionary[@"authorName"] = party.authorName;
    }
    if (party.photoURL)
    {
        dictionary[@"photoURL"] = party.photoURL;
    }
    
    if (party.address)
    {
        dictionary[@"address"] = party.address;
    }
    
    if (party.apartment)
    {
        dictionary[@"apartment"] = party.apartment;
    }

    if (party.created)
    {
        dictionary[@"created"] = [@(party.created.timeIntervalSince1970) stringValue];
    }
    
    if (party.closed)
    {
        dictionary[@"closed"] = [@(party.closed.timeIntervalSince1970) stringValue];
    }
    
    if (party.date)
    {
         dictionary[@"date"] = [@(party.date.timeIntervalSince1970) stringValue];
    }
    
    if (party.desc)
    {
        dictionary[@"desc"] = party.desc;
    }
    
    if (party.members > 0)
    {
        dictionary[@"members"] = [@(party.members) stringValue];
    }
    
    if (party.status)
    {
        dictionary[@"status"] = party.status;
    }
    
    return dictionary;
}


#pragma mark - Creation

+ (NSString *)stringFromStatus:(DAZPartyStatus)status
{
    return @[@"Открыто", @"Закрыто"][status];
}

+ (DAZPartyStatus)statusFromString:(NSString *)status
{
    if ([@"Открыто" isEqualToString:status])
    {
        return DAZPartyStatusOpen;
    } else if ([@"Закрыто" isEqualToString:status])
    {
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

- (NSDictionary *)dictionary {
    return [PartyMO dictionaryFromParty:self];
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
