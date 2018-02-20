//
//  DAZAuthorizationViewController.h
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAZAuthorizationFacade.h"


@interface DAZAuthorizationViewController : UIViewController

@property (nonatomic, strong) DAZAuthorizationFacade *authorizationMediator;

@end
