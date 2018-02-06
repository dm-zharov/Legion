//
//  DAZPartyDetailsViewControllers.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartyMO+CoreDataClass.h"

#import "DAZPartiesTableViewController.h"

@interface DAZPartyDetailsViewControllers : UIViewController

@property (nonatomic, weak) DAZPartiesTableViewController *delegate;

@property (nonatomic, strong) PartyMO *party;

@end
