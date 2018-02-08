//
//  PartyMO+CoreDataClass.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClaimMO;

typedef NS_ENUM(NSUInteger, DAZPartyStatus) {
    DAZPartyStatusOpen,
    DAZPartyStatusClosed
};

NS_ASSUME_NONNULL_BEGIN

@interface PartyMO : NSManagedObject

+ (NSString *)entityName;

// Creation
+ (instancetype)partyWithContext:(NSManagedObjectContext *)context;
+ (instancetype)partyWithContext:(NSManagedObjectContext *)context dictionary:(NSDictionary *)dictionary;

// Instance Accessors
+ (NSDictionary *)dictionaryFromParty:(PartyMO *)party;
+ (NSString *)stringFromStatus:(DAZPartyStatus)status;
+ (DAZPartyStatus)statusFromString:(NSString *)status;

// Accessors
- (DAZPartyStatus)partyStatus;
- (void)setPartyStatus:(DAZPartyStatus)status;

// Coding
- (NSDictionary *)dictionary;

// Basic
- (BOOL)saveParty;
- (BOOL)deleteParty;

@end

NS_ASSUME_NONNULL_END

#import "PartyMO+CoreDataProperties.h"
