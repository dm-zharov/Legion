//
//  UIViewController+Alerts.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)al_presentAlertViewControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];

    [alert addAction:agreeAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)al_presentOfflineModeAlertViewController
{
    return [self al_presentAlertViewControllerWithTitle:@"Офлайн-режим"
                                                message:@"Наблюдаются проблемы с сетевым подключением, будут "
                                                            "отображены последние сохраненные данные"];
}

@end
