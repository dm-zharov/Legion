//
//  DAZPartyCreationViewControllersAssembly.h
//  Legion
//
//  Created by Дмитрий Жаров on 04.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PartyMO+CoreDataClass.h"


@protocol DAZPartyCreationViewControllerDelegate <NSObject>

- (void)partyCreationViewControllerCompletedWorkWithParty:(PartyMO *)party;

@end;

/* Сборщик экранов создания новой вечеринки
 */
@interface DAZPartyCreationViewControllersAssembly : NSObject

@property (nonatomic, weak) id <DAZPartyCreationViewControllerDelegate> delegate;

- (UIViewController *)partyCreationViewController;

@end
