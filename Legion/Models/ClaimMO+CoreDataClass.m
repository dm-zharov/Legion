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

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context {
    ClaimMO *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                  inManagedObjectContext:context];
    
    return item;
}

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary {
    ClaimMO *item = [self claimWithContext:context];
    
    item.author = dictionary[@"author"];
    item.uid = dictionary[@"uid"];
    item.status = dictionary[@"status"];
    
    NSTimeInterval date = [dictionary[@"date"] doubleValue];
    item.date = [NSDate dateWithTimeIntervalSince1970:date];
    
    return item;
}

+ (NSDictionary *)dictionaryFromClaim:(ClaimMO *)claim
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (claim.author)
    {
        dictionary[@"author"] = claim.author;
    }
    
    if (claim.uid)
    {
        dictionary[@"uid"] = claim.uid;
    }
    
    if (claim.status)
    {
        dictionary[@"status"] = claim.status;
    }
    
    if (claim.date)
    {
        dictionary[@"date"] = [@(claim.date.timeIntervalSince1970) stringValue];
    }
    
    return dictionary;
}

// Instance Accessors
+ (NSString *)stringFromStatus:(DAZClaimStatus)status
{
    return @[@"Подтверждено", @"Запрошено", @"Отклонено"][status];
}

+ (DAZClaimStatus)statusFromString:(NSString *)status
{
    if ([@"Подтверждено" isEqualToString:status]) {
        return DAZClaimStatusConfirmed;
    } else if ([@"Запрошено" isEqualToString:status]) {
        return DAZClaimStatusRequested;
    } else if ([@"Отклонено" isEqualToString:status]) {
        return DAZClaimStatusClosed;
    }
    
    return NSNotFound;
}

// Accessors
- (DAZClaimStatus)claimStatus
{
    return [ClaimMO statusFromString:self.status];
}

- (void)setClaimStatus:(DAZClaimStatus)status
{
    self.status = [ClaimMO stringFromStatus:status];
}

// Coding
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
