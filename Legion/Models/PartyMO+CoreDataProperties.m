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

@dynamic date;
@dynamic created;
@dynamic status;
@dynamic title;
@dynamic uid;
@dynamic closed;
@dynamic desc;
@dynamic members;
@dynamic left;
@dynamic claim;

@end
