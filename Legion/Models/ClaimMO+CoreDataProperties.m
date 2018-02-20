//
//  ClaimMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 11.02.2018.
//
//

#import "ClaimMO+CoreDataProperties.h"


@implementation ClaimMO (CoreDataProperties)

+ (NSFetchRequest<ClaimMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Claim"];
}

@dynamic authorID;
@dynamic authorName;
@dynamic date;
@dynamic partyID;
@dynamic status;
@dynamic photoURL;
@dynamic partyTitle;
@dynamic party;

@end
