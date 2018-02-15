//
//  DAZPartyDetailsViewControllers.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PartyMO;

typedef NS_ENUM(NSInteger, DAZPartyDetailsState) {
    DAZPartyDetailsOwner = YES,
    DAZPartyDetailsGuest = NO,
};

@interface DAZPartyDetailsViewControllers : UIViewController

@property (nonatomic, readonly) UIScrollView *scrollView;

- (instancetype)initWithState:(DAZPartyDetailsState)state;
- (void)setContentWithParty:(PartyMO *)party;

@end
