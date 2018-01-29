//
//  PartyMO+CoreDataClass.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, DAZPartyStatus) {
    DAZPartyStatusOpen,
    DAZPartyStatusClosed
};

NS_ASSUME_NONNULL_BEGIN

@interface PartyMO : NSManagedObject

+ (NSString *)entityName;

// Creation
+ (PartyMO *)partyWithContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSString *)stringFromStatus:(DAZPartyStatus)status;


- (BOOL)saveObject;
- (BOOL)deleteObject;

- (DAZPartyStatus)partyStatus;
- (void)setPartyStatus:(DAZPartyStatus)status;
@end

NS_ASSUME_NONNULL_END

#import "PartyMO+CoreDataProperties.h"
