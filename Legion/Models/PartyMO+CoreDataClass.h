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

+ (NSString *)stringFromStatus:(DAZPartyStatus)status;

- (DAZPartyStatus)partyStatus;
- (void)setPartyStatus:(DAZPartyStatus)status;

@end

NS_ASSUME_NONNULL_END

#import "PartyMO+CoreDataProperties.h"
