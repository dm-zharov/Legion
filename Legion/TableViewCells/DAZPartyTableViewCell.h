//
//  DAZPartyTableViewCell.h
//  Legion
//
//  Created by Дмитрий Жаров on 02.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartyMO;

@interface DAZPartyTableViewCell : UITableViewCell

@property (nonatomic, readonly) PartyMO *party;

- (void)setWithParty:(PartyMO *)party;

@end
