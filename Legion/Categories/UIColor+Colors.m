//
//  UIColor+Colors.m
//  Legion
//
//  Created by Дмитрий Жаров on 07.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)cl_lightPurpleColor
{
    static UIColor *lightPurpleColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightPurpleColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    });
    
    return lightPurpleColor;
}

+ (UIColor *)cl_darkPurpleColor
{
    static UIColor *lightPurpleColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightPurpleColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    });
    
    return lightPurpleColor;
}

@end
