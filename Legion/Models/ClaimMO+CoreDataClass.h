//
//  ClaimMO+CoreDataClass.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PartyMO, UserMO;

typedef NS_ENUM(NSUInteger, DAZClaimStatus) {
    DAZClaimStatusOpen,
    DAZClaimStatusClosed
};

NS_ASSUME_NONNULL_BEGIN

@interface ClaimMO : NSManagedObject

+ (NSString *)entityName;

//// Creation
+ (instancetype)claimWithContext:(NSManagedObjectContext *)context;
+ (instancetype)claimWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary;
+ (instancetype)claimWithContext:(NSManagedObjectContext *)context data:(NSData *)data;

//// Instance Accessors
//+ (NSString *)stringFromStatus:(DAZClaimStatus)status;
//+ (DAZClaimStatus)statusFromString:(NSString *)status;
//
//// Accessors
//- (DAZClaimStatus)claimStatus;
//- (void)setPartyStatus:(DAZClaimStatus)status;
//
//// Coding
- (NSDictionary *)dictionaryFromClaim;
- (NSData *)dataFromClaim;
//
//// Basic
//- (BOOL)saveClaim;
//- (BOOL)deleteClaim;

@end

NS_ASSUME_NONNULL_END

#import "ClaimMO+CoreDataProperties.h"
