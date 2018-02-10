//
//  ClaimMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 10.02.2018.
//
//

#import "ClaimMO+CoreDataProperties.h"

@implementation ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Claim"];
}

@dynamic authorID;
@dynamic date;
@dynamic status;
@dynamic partyID;
@dynamic authorName;
@dynamic party;

@end
