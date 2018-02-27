//
//  DAZProfileViewController+Debug.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <objc/runtime.h>
#import <Masonry.h>
#import "DAZProfileViewController+Debug.h"
#import "DAZNetworkService+Debug.h"
#import "DAZUserProfile.h"
#import "UIViewController+Alerts.h"


@interface DAZProfileViewController () <UIGestureRecognizerDelegate>

- (void)setupFooterView;

@end

@implementation DAZProfileViewController (Debug)
@dynamic avatarImageView;
@dynamic footerView;
@dynamic signOutButton;

+ (void)load
{
    Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method db_viewDidLoad = class_getInstanceMethod(self, @selector(db_viewDidLoad));
    method_exchangeImplementations(viewDidLoad, db_viewDidLoad);
}

- (void)db_viewDidLoad
{
    [self db_viewDidLoad];
    
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    
    if (!profile.email)
    {
        self.avatarImageView.userInteractionEnabled = NO;
        [self setupFooterView];
    }
    else
    {
        [self db_setupDebugView];
    }
}

- (void)db_setupDebugView {
    UILabel *debugTitle = [[UILabel alloc] init];
    
    debugTitle.textAlignment = NSTextAlignmentCenter;
    debugTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    debugTitle.textColor = [UIColor whiteColor];
    debugTitle.text = @"Режим тестирования";
    
    [self.footerView addSubview:debugTitle];
    
    [debugTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signOutButton.mas_bottom).with.offset(16);
        make.left.equalTo(self.footerView).with.offset(16);
        make.right.equalTo(self.footerView).with.offset(-16);
        make.centerX.equalTo(self.footerView);
        
    }];
    
    UILabel *debugMessage = [[UILabel alloc] init];
    
    debugMessage.textAlignment = NSTextAlignmentCenter;
    debugMessage.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    debugMessage.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    debugMessage.text = @"В данном режиме у вас есть возможность получить выборку тестовых данных "
    "с помощью простого пятикратного нажатия по аватарке пользователя!";
    debugMessage.numberOfLines = 0;
    
    [self.footerView addSubview:debugMessage];
    
    [debugMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(debugTitle.mas_bottom).with.offset(16);
        make.left.equalTo(self.footerView).with.offset(16);
        make.right.equalTo(self.footerView).with.offset(-16);
        make.centerX.equalTo(debugTitle);
        
    }];
    
    [self db_setupGestureRecognizer];
}

- (void)db_setupGestureRecognizer
{
    UILongPressGestureRecognizer *gestureRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(db_avatarImagePressed:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    gestureRecognizer.minimumPressDuration = 0.0;
    [self.avatarImageView addGestureRecognizer:gestureRecognizer];
    
    self.avatarImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(db_avatarImageTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 5;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)db_avatarImagePressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.05
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.avatarImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                            } completion:nil];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.05
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.avatarImageView.transform = CGAffineTransformIdentity;
                            } completion:nil];
    }
}

- (void)db_avatarImageTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [self al_presentAlertViewControllerWithTitle:@"Готово" message:@"Выборка данных получена. Приятного тестирования!"];
        
        DAZNetworkService *networkService = [[DAZNetworkService alloc] init];
        [networkService setTestData];
        
        sender.enabled = NO;
    }
}

@end
