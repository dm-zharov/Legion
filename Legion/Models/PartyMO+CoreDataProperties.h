//
//  PartyMO+CoreDataProperties.h
//  
//
//  Created by Дмитрий Жаров on 10.02.2018.
//
//

#import "PartyMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *apartment;
@property (nullable, nonatomic, copy) NSString *authorID;
@property (nullable, nonatomic, copy) NSDate *closed;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nonatomic) int32_t members;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *partyID;
@property (nullable, nonatomic, copy) NSString *authorName;
@property (nullable, nonatomic, retain) ClaimMO *claim;

@end

NS_ASSUME_NONNULL_END
