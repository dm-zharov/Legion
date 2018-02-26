//
//  DAZPlaceholderView.h
//  Legion
//
//  Created by Дмитрий Жаров on 14.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAZPlaceholderView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@end
