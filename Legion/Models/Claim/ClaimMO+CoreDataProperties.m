//
//  ClaimMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
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

@end
