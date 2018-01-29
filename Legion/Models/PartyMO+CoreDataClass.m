//
//  PartyMO+CoreDataClass.m
//  
//
//  Created by Дмитрий Жаров on 29.01.2018.
//
//

#import "PartyMO+CoreDataClass.h"

@implementation PartyMO

+ (NSString *)stringFromStatus:(DAZPartyStatus)status
{
    return @[@"Открыто", @"Закрыто"][status];
}

+ (DAZPartyStatus)statusFromString:(NSString *)string {
    if ([@"Открыто" isEqualToString:string]) {
        return DAZPartyStatusOpen;
    } else if ([@"Закрыто" isEqualToString:string]) {
        return DAZPartyStatusClosed;
    }
    
    return NSNotFound;
}

- (DAZPartyStatus)partyStatus {
    return [PartyMO statusFromString:self.status];
}

- (void)setPartyStatus:(DAZPartyStatus)status {
    self.status = [PartyMO stringFromStatus:status];
}



@end
