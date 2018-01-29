//
//  PartyMO+CoreDataProperties.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "PartyMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSDate *published;
@property (nonatomic) BOOL status;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) ClaimMO *claim;

@end

NS_ASSUME_NONNULL_END
