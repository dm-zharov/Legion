//
//  DAZPartyDetailsViewControllers.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartyMO;

@interface DAZPartyDetailsViewControllers : UIViewController

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

- (void)setContentWithParty:(PartyMO *)party;

@end
