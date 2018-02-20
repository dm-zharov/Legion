//
//  PartyMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 15.02.2018.
//
//

#import "PartyMO+CoreDataProperties.h"


@implementation PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Party"];
}

@dynamic address;
@dynamic apartment;
@dynamic authorID;
@dynamic authorName;
@dynamic closed;
@dynamic created;
@dynamic date;
@dynamic desc;
@dynamic members;
@dynamic partyID;
@dynamic photoURL;
@dynamic status;
@dynamic title;
@dynamic ownership;
@dynamic claim;

@end
