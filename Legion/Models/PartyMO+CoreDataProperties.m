//
//  PartyMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "PartyMO+CoreDataProperties.h"

@implementation PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Party"];
}

@dynamic uid;
@dynamic date;
@dynamic published;
@dynamic status;
@dynamic title;
@dynamic claim;

@end
