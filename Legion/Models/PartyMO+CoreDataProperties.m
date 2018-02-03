//
//  PartyMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 01.02.2018.
//
//

#import "PartyMO+CoreDataProperties.h"

@implementation PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Party"];
}

@dynamic address;
@dynamic apartment;
@dynamic closed;
@dynamic created;
@dynamic date;
@dynamic desc;
@dynamic members;
@dynamic status;
@dynamic title;
@dynamic author;
@dynamic uid;
@dynamic claim;

@end
