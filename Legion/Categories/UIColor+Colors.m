//
//  UIColor+Colors.m
//  Legion
//
//  Created by Дмитрий Жаров on 07.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)


#pragma mark - Convenience methods

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
    static UIColor *darkPurpleColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        darkPurpleColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    });
    
    return darkPurpleColor;
}

+ (UIColor *)cl_lightBlueColor
{
    static UIColor *lightBlueColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightBlueColor = [UIColor colorWithRed:241/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    });
    
    return lightBlueColor;
}

@end
