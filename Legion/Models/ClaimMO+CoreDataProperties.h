//
//  ClaimMO+CoreDataProperties.h
//  
//
//  Created by Дмитрий Жаров on 08.02.2018.
//
//

#import "ClaimMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) PartyMO *party;

@end

NS_ASSUME_NONNULL_END
