//
//  UINavigationBar+Shadow.m
//  Legion
//
//  Created by Дмитрий Жаров on 07.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UINavigationBar+Shadow.h"


@implementation UINavigationBar (Shadow)


#pragma mark - Public

- (void)sh_customShadow
{
    self.shadowImage = [UIImage new];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 2.0;
}

@end
