//
//  ClaimMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 30.01.2018.
//
//

#import "ClaimMO+CoreDataProperties.h"

@implementation ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Claim"];
}

@dynamic published;
@dynamic status;
@dynamic party;
@dynamic uid;

@end
