//
//  ClaimMO+CoreDataProperties.h
//  
//
//  Created by Дмитрий Жаров on 30.01.2018.
//
//

#import "ClaimMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *published;
@property (nonatomic) BOOL status;
@property (nullable, nonatomic, retain) PartyMO *party;
@property (nullable, nonatomic, retain) UserMO *uid;

@end

NS_ASSUME_NONNULL_END
