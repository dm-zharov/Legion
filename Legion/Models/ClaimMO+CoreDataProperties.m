//
//  ClaimMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 08.02.2018.
//
//

#import "ClaimMO+CoreDataProperties.h"

@implementation ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Claim"];
}

@dynamic author;
@dynamic status;
@dynamic uid;
@dynamic date;
@dynamic party;

@end
