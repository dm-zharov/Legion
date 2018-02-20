//
//  UIImage+Cache.h
//  Legion
//
//  Created by Дмитрий Жаров on 10.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Cache)

+ (void)ch_imageWithContentsOfURL:(NSURL *)url completion:(void (^)(UIImage *))completion;

@end
