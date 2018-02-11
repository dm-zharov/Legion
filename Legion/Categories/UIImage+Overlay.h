//
//  UIImage+Overlay.h
//  Legion
//
//  Created by Дмитрий Жаров on 06.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Overlay)

+ (UIImage *)ov_tintedImageFrom:(UIImage *)source WithColor:(UIColor *)color;

- (UIImage *)ov_tintedImage;

@end
