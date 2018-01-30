//
//  UserMO+CoreDataProperties.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "UserMO+CoreDataProperties.h"

@implementation UserMO (CoreDataProperties)

+ (NSFetchRequest<UserMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic email;
@dynamic uid;
@dynamic claims;

@end
