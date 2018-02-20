//
//  ClaimMO+CoreDataClass.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "ClaimMO+CoreDataClass.h"


@implementation ClaimMO


#pragma mark - Static Properties

+ (NSString *)entityName
{
    return @"Claim";
}


#pragma mark - Creation

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context
{
    ClaimMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    
    return item;
}

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary
{
    ClaimMO *item = [self claimWithContext:context];
    
    if (dictionary[@"authorID"])
    {
        item.authorID = dictionary[@"authorID"];
    }

    if (dictionary[@"partyID"])
    {
        item.partyID = dictionary[@"partyID"];
    }
    
    if (dictionary[@"partyTitle"])
    {
        item.partyTitle = dictionary[@"partyTitle"];
    }
    
    if (dictionary[@"status"])
    {
        item.status = dictionary[@"status"];
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
    
    if (dictionary[@"date"])
    {
        NSTimeInterval date = [dictionary[@"date"] doubleValue];
        item.date = [NSDate dateWithTimeIntervalSince1970:date];
    }
    
    return item;
}

#pragma mark - Instance Accesors

+ (NSDictionary *)dictionaryFromClaim:(ClaimMO *)claim
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (claim.authorID)
    {
        dictionary[@"authorID"] = claim.authorID;
    }
    
    if (claim.partyID)
    {
        dictionary[@"partyID"] = claim.partyID;
    }
    
    if (claim.partyTitle)
    {
        dictionary[@"partyTitle"] = claim.partyTitle;
    }
    
    if (claim.status)
    {
        dictionary[@"status"] = claim.status;
    }
    
    if (claim.authorName) 
    {
        dictionary[@"authorName"] = claim.authorName;
    }
    
    if (claim.photoURL)
    {
        dictionary[@"photoURL"] = [claim.photoURL absoluteString];
    }
    
    if (claim.date)
    {
        dictionary[@"date"] = [@(claim.date.timeIntervalSince1970) stringValue];
    }
    
    return dictionary;
}

+ (NSString *)stringFromStatus:(DAZClaimStatus)status
{
    return @[@"Подтверждено", @"Запрошено", @"Отклонено"][status];
}

+ (DAZClaimStatus)statusFromString:(NSString *)status
{
    if ([@"Подтверждено" isEqualToString:status])
    {
        return DAZClaimStatusConfirmed;
    }
    else if ([@"Запрошено" isEqualToString:status])
    {
        return DAZClaimStatusRequested;
    }
    else if ([@"Отклонено" isEqualToString:status])
    {
        return DAZClaimStatusClosed;
    }
    
    return NSNotFound;
}


#pragma mark - Custom Accessors

- (DAZClaimStatus)claimStatus
{
    return [ClaimMO statusFromString:self.status];
}

- (void)setClaimStatus:(DAZClaimStatus)status
{
    self.status = [ClaimMO stringFromStatus:status];
}


- (NSDictionary *)dictionaryFromClaim {
    return [ClaimMO dictionaryFromClaim:self];
}


#pragma mark - Basic

- (BOOL)saveClaim
{
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)deleteClaim {
    [self.managedObjectContext deleteObject:self];
    return [self saveClaim];
}

@end
