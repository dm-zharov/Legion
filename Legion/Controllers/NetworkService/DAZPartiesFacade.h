//
//  DAZPartiesFacade.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartyMO;

@interface DAZPartiesFacade : NSObject

- (NSArray<PartyMO *> *)getParties;

- (void)createParty:(PartyMO *)party;
- (void)editParty:(PartyMO *)party;
- (void)openParty:(PartyMO *)party;
- (void)closeParty:(PartyMO *)party;
- (void)deleteParty:(PartyMO *)party;

@end
