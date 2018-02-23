//
//  DAZCreationBaseViewController.h
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DAZSelectionScreenBaseViewControllerProtocol <NSObject>

@optional
- (void)contentInView:(UIView *)contentView; // Заполнить полученный contentView.
- (void)actionButtonPressed; // Нажата кнопка завершения.

@end

@interface DAZSelectionScreenBaseViewController : UIViewController

@property (nonatomic, readonly) NSString *messageString;
@property (nonatomic, readonly) UIButton *actionButton;

- (instancetype)initWithMessage:(NSString *)message;

@end
