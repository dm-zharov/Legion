//
//  PartyMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 05.02.2018.
//
//

#import "PartyMO+CoreDataProperties.h"

@implementation PartyMO (CoreDataProperties)

+ (NSFetchRequest<PartyMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Party"];
}

@dynamic address;
@dynamic apartment;
@dynamic author;
@dynamic closed;
@dynamic created;
@dynamic date;
@dynamic desc;
@dynamic members;
@dynamic status;
@dynamic title;
@dynamic uid;
@dynamic time;
@dynamic claim;

@end
