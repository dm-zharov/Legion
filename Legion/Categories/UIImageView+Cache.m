//
//  UIImageView+Cache.m
//  Legion
//
//  Created by Дмитрий Жаров on 10.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "UIImage+Cache.h"

@implementation UIImageView (Cache)

- (void)ch_imageWithContentsOfURL:(NSURL *)url
{
    if (!url)
    {
        return;
    }
    
    [UIImage ch_imageWithContentsOfURL:url completion:^(UIImage *image) {
        [UIView transitionWithView:self
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            self.image = image;
        } completion:nil];
        
    }];
}

@end
