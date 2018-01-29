//
//  UserMO+CoreDataProperties.h
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "UserMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserMO (CoreDataProperties)

+ (NSFetchRequest<UserMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, retain) NSSet<ClaimMO *> *claims;

@end

@interface UserMO (CoreDataGeneratedAccessors)

- (void)addClaimsObject:(ClaimMO *)value;
- (void)removeClaimsObject:(ClaimMO *)value;
- (void)addClaims:(NSSet<ClaimMO *> *)values;
- (void)removeClaims:(NSSet<ClaimMO *> *)values;

@end

NS_ASSUME_NONNULL_END
