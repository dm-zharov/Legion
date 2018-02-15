//
//  UIImage+Overlay.m
//  Legion
//
//  Created by Дмитрий Жаров on 06.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)

+ (UIImage *)ov_tintedImageFrom:(UIImage *)source WithColor:(UIColor *)color
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

@end
