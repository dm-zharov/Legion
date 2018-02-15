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
    if (CGRectIsEmpty(self.cellFrame))
    {
        return;
    }
    
    DAZPartiesTableViewController *origin = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DAZPartyDetailsViewControllers *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:destination.view];
    
    // Начальное состояние, подстраиваемся под полученный фрейм
    CATransform3D translate = CATransform3DMakeTranslation(self.cellFrame.origin.x, self.cellFrame.origin.y, 0.0);
    
    destination.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.cellFrame), CGRectGetHeight(self.cellFrame));
    destination.view.layer.masksToBounds = YES;
    destination.view.layer.cornerRadius = 10;
    destination.view.layer.transform = translate;
    
    CATransform3D translateScrollView = CATransform3DMakeTranslation(0, CGRectGetHeight(origin.view.bounds), 0.0);
    destination.scrollView.layer.transform = translateScrollView;
    
    [containerView layoutIfNeeded];
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.65
                                                                           dampingRatio:0.9
                                                                             animations:^{
        // Финальное состояние
        destination.view.layer.transform = CATransform3DIdentity;
        destination.view.frame = origin.view.frame;
        destination.view.layer.cornerRadius = 5;
                                                                                 
        destination.scrollView.layer.transform = CATransform3DIdentity;
       
        [destination.view layoutIfNeeded];
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [transitionContext completeTransition:YES];
    }];
     
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.65;
}
@end
