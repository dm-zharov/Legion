//
//  DAZCreatePartyViewController.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PartyMO+CoreDataClass.h"

@interface DAZPartyCreateViewController : UIViewController

@property (nonatomic, strong) PartyMO *party;
@property (nonatomic, strong) UILabel *titleLabel;

@end
