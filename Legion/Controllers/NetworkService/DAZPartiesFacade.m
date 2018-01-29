//
//  DAZPartiesFacade.m
//  Legion
//
//  Created by Дмитрий Жаров on 29.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZPartiesFacade.h"
#import "DAZCoreDataManager.h"
#import "DAZNetworkService.h"

#import "PartyMO+CoreDataClass.h"

@interface DAZPartiesFacade ()

@property (nonatomic, strong) DAZCoreDataManager *coreDataService;
@property (nonatomic, strong) DAZNetworkService *networkService;

@end

@implementation DAZPartiesFacade

- (instancetype)init
{
    self = [super init];
    if (self) {
        _coreDataService = [[DAZCoreDataManager alloc] init];
        _networkService = [[DAZNetworkService alloc] init];
    }
    return self;
}

- (NSArray *)getParties
{
    NSArray *posts = [NSArray new];
    posts = [self.coreDataService fetchParties];
    
    if (posts.count == 0)
    {
        posts = [self.networkService downloadParties];
        [self.coreDataService saveParties:posts];
    }
    
    return posts;
}

- (void)createParty:(PartyMO *)party {
    
}

- (void)editParty:(PartyMO *)party {
    
}

- (void)openParty:(PartyMO *)party {
    
}

- (void)closeParty:(PartyMO *)party {
    
}

- (void)deleteParty:(PartyMO *)party {
    
}

@end
