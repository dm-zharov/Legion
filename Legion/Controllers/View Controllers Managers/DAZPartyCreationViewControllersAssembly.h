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

- (void)partyCreationViewCompletedWorkWithParty:(PartyMO *)party;

@end;

/* Сборщик экранов создания новой тусовки
 */
@interface DAZPartyCreationViewControllersAssembly : NSObject

@property (nonatomic, weak) id <DAZPartyCreationViewControllerDelegate> delegate;

@property (nonatomic, strong) PartyMO *party;

- (UIViewController *)partyCreationViewController;

@end
