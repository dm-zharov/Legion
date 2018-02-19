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

+ (CAGradientLayer *)gr_purpleGradientLayer
{
    UIColor *topLeftColor = [UIColor cl_lightPurpleColor];
    UIColor *bottomRightColor = [UIColor cl_darkPurpleColor];
    
    NSArray *gradientColors = @[(id)topLeftColor.CGColor, (id)bottomRightColor.CGColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    return gradientLayer;
}

@end
