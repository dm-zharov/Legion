//
//  UIImage+Overlay.h
//  Legion
//
//  Created by Дмитрий Жаров on 06.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Overlay)

+ (UIImage *)tintedImageFrom:(UIImage *)source withColor:(UIColor *)color;

- (UIImage *)tinted;

@end
