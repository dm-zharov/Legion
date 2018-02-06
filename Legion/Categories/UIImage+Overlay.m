//
//  UIImage+Overlay.m
//  Legion
//
//  Created by Дмитрий Жаров on 06.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)

+ (UIImage *)tintedImageFrom:(UIImage *)source withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color setFill];
    
    // Перевод из UI системы координат в CG систему (переворачиваем)
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextClipToMask(context, rect, source.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // Сгенерировать UIImage из текущего графического контекста
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

- (UIImage *)tinted
{
    UIColor *topLeftColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:0.7];
    UIColor *bottomRightColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:0.7];
    
    NSArray *colorsArr = @[(id)topLeftColor, (id)bottomRightColor];
    
    CGFloat scale = self.scale;
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width * scale, self.size.height * scale);
    CGContextDrawImage(context, rect, self.CGImage);
    
    // Create gradient
    
    UIColor *colorOne = [colorsArr objectAtIndex:0]; // top color
    UIColor *colorTwo = [colorsArr objectAtIndex:1]; // bottom color
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    
    // Apply gradient
    
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(self.size.width,self.size.height * scale), 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

@end
