//
//  DAZPartyDetailsViewControllers.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartyMO;
@protocol DAZProxyServiceDelegate;


@interface DAZPartyDetailsViewControllers : UIViewController

@property (nonatomic, readonly) UIScrollView *scrollView; // Необходим для кастомной анимации

@property (nonatomic, weak) id <DAZProxyServiceDelegate> delegate;

- (instancetype)initWithParty:(PartyMO *)party;

@end
