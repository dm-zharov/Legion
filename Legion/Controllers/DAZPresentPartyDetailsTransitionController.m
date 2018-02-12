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
    DAZPartiesTableViewController *origin = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DAZPartyDetailsViewControllers *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1
                                                                           dampingRatio:0.6
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

- (void)foo{
// Получение начального фрейма перехода из ячейки

//    UIView *purpleView = [[UIView alloc] initWithFrame:cellFrame];
//    self.purpleView = purpleView;
//
//    CAGradientLayer *purpleLayer = [CAGradientLayer gr_purpleGradientLayer];
//    purpleLayer.frame = self.view.bounds;
//    [purpleView.layer addSublayer:purpleLayer];
//
//    purpleView.layer.cornerRadius = 10;
//    purpleView.layer.masksToBounds = YES;
//    purpleView.userInteractionEnabled = YES;
//
//    [self.view addSubview:purpleView];

//    partyDetailsViewController.view.frame = CGRectInset(self.view.frame, 50, 50);
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//        purpleView.layer.cornerRadius = 5;
//        purpleView.frame = self.view.frame;
//
//        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
//        self.navigationController.navigationBar.transform =
//            CGAffineTransformMakeTranslation(0, -(CGRectGetHeight(navigationBarFrame) + 20));
//
//        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
//        self.tabBarController.tabBar.transform =
//            CGAffineTransformMakeTranslation(0, CGRectGetHeight(tabBarFrame));
//     } completion:^(BOOL finished) {
//         self.navigationController.navigationBarHidden = YES;
//         [self presentViewController:partyDetailsViewController animated:YES completion:nil];
//     }];
}

//- (void)dismiss
//{
//    self.navigationController.navigationBarHidden = NO;
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//
//                         self.navigationController.navigationBar.transform =
//                         CGAffineTransformIdentity;
//
//                         self.tabBarController.tabBar.transform =
//                         CGAffineTransformIdentity;
//
//                         self.purpleView.layer.cornerRadius = 10;
//                         self.purpleView.frame = self.cellRect;
//                     } completion:^(BOOL finished) {
//                         [self.purpleView removeFromSuperview];
//                     }];
//}
@end
