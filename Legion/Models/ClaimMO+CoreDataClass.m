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
    return @"Party";
}

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context {
    return nil;
}

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary {
    return nil;
}

+ (instancetype)claimWithContext:(NSManagedObjectContext *)context data:(NSData *)data {
    return nil;
}

//// Instance Accessors
//+ (NSString *)stringFromStatus:(DAZClaimStatus)status;
//+ (DAZClaimStatus)statusFromString:(NSString *)status;
//
//// Accessors
//- (DAZClaimStatus)claimStatus;
//- (void)setPartyStatus:(DAZClaimStatus)status;
//
//// Coding
- (NSDictionary *)dictionaryFromClaim {
    return [NSDictionary new];
}
- (NSData *)dataFromClaim {
    return [NSData new];
}

@end
