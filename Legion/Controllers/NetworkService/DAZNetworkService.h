//
//  DAZNetworkService.h
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAZCoreDataManager;

@interface DAZNetworkService : NSObject

- (instancetype)initWithCoreDataManager:(DAZCoreDataManager *)manager;

- (NSArray *)downloadParties;

- (void)uploadParty;
- (void)deleteParty;

@end
