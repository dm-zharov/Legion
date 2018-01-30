//
//  ClaimMO+CoreDataClass.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PartyMO;

NS_ASSUME_NONNULL_BEGIN

@interface ClaimMO : NSManagedObject

+ (NSString *)entityName;

@end

NS_ASSUME_NONNULL_END

#import "ClaimMO+CoreDataProperties.h"
