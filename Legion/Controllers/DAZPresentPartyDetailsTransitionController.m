//
//  DAZPresentPartyDetailsTransitionController.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZPresentPartyDetailsTransitionController.h"
#import "DAZPartyDetailsViewControllers.h"

@interface DAZPresentPartyDetailsTransitionController ()

@property (nonatomic, assign) CATransform3D cellTransform;

@end

@implementation DAZPresentPartyDetailsTransitionController

- (CATransform3D)animateCell:(CGRect)cellFrame
{    
    CGFloat scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000;
    CGFloat scaleMax = 1.0;
    CGFloat scaleMin = 0.6;
    if (scaleFromX > scaleMax)
    {
        scaleFromX = scaleMax;
    }
    if (scaleFromX < scaleMin)
    {
        scaleFromX = scaleMin;
    };
    
    CATransform3D scale = CATransform3DScale(CATransform3DIdentity, 0.91, 0.27, 1);
    
    return scale;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    DAZPartyDetailsViewControllers *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:destination.view];
    
    self.cellTransform = [self animateCell:self.cellFrame];
    
    // Начаальное состояние
    
    CATransform3D translate = CATransform3DMakeTranslation(self.cellFrame.origin.x, self.cellFrame.origin.y, 0.0);
    CATransform3D transform = CATransform3DConcat(translate, self.cellTransform);
    
    destination.view.layer.transform = transform;
    destination.view.layer.zPosition = 999;
    destination.view.layer.cornerRadius = 10;
    
    [destination.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@343);
        make.height.equalTo(@180);
    }];
    
    [containerView layoutIfNeeded];
    
    destination.scrollView.layer.cornerRadius = 14;
    destination.scrollView.layer.shadowOpacity = 0.25;
    destination.scrollView.layer.shadowOffset = CGSizeMake(0, 10);
    destination.scrollView.layer.shadowRadius = 20;
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1
                                                                           dampingRatio:0.7
                                                                             animations:^{
        // Финальное состояние
        destination.view.layer.transform = CATransform3DIdentity;
//
//        [destination.view layoutIfNeeded];
//
//         destination.scrollView.layer.cornerRadius = 0;
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [transitionContext completeTransition:YES];
    }];
     
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
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
