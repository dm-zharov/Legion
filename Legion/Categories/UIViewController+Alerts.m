//
//  UIViewController+Alerts.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)al_presentNetworkAlertViewController
{
    static NSString *alertTitle = @"Ошибка сети";
    static NSString *alertMessage = @"Произошла ошибка сети, проверьте соединение с интернетом либо попробуйте позже.";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil];

    [alert addAction:agreeAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
