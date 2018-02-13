//
//  DAZPresentPartyDetailsTransitionController.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZPresentPartyDetailsTransitionController.h"
#import "DAZPartiesTableViewController.h"
#import "DAZPartyDetailsViewControllers.h"

@interface DAZPresentPartyDetailsTransitionController ()

@end

@implementation DAZPresentPartyDetailsTransitionController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *origin = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:destination.view];
    
    // Начаальное состояние
    
    CATransform3D translate = CATransform3DMakeTranslation(self.cellFrame.origin.x, self.cellFrame.origin.y, 0.0);
    
    destination.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.cellFrame), CGRectGetHeight(self.cellFrame));
    destination.view.layer.masksToBounds = YES;
    destination.view.layer.cornerRadius = 10;
    destination.view.layer.transform = translate;
    
//    destination.view.layer.transform = translate;
//    destination.view.layer.zPosition = 999;
//    destination.view.layer.cornerRadius = 10;
    
    [containerView layoutIfNeeded];
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.6
                                                                           dampingRatio:0.9
                                                                             animations:^{
        // Финальное состояние
        //destination.view.layer.transform = CATransform3DIdentity;
       destination.view.frame = origin.view.frame;
       destination.view.layer.cornerRadius = 5;
//
    [destination.view layoutIfNeeded];
                                                                                 
        CGRect navigationBarFrame = origin.navigationController.navigationBar.frame;
        origin.navigationController.navigationBar.transform =
            CGAffineTransformMakeTranslation(0, -(CGRectGetHeight(navigationBarFrame) + 20));

        CGRect tabBarFrame = origin.tabBarController.tabBar.frame;
        origin.tabBarController.tabBar.transform =
            CGAffineTransformMakeTranslation(0, CGRectGetHeight(tabBarFrame));
//
//         destination.scrollView.layer.cornerRadius = 0;
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [transitionContext completeTransition:YES];
    }];
     
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}
@end
