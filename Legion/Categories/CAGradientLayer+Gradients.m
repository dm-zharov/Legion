//
//  CAGradientLayer+Gradients.m
//  Legion
//
//  Created by Дмитрий Жаров on 02.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "CAGradientLayer+Gradients.h"
#import "UIColor+Colors.h"

@implementation CAGradientLayer (Gradients)

+ (CAGradientLayer *)purpleGradientLayer
{
    UIColor *topLeftColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    UIColor *bottomRightColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    
    NSArray *gradientColors = @[(id)topLeftColor.CGColor, (id)bottomRightColor.CGColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    return gradientLayer;
}

@end
