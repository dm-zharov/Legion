//
//  DAZProfileViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 12.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZProfileViewController.h"
#import "CAGradientLayer+Gradients.h"
#import "DAZUserProfile.h"
#import "DAZRootViewControllerRouter.h"
#import "UIImageView+Cache.h"
#import "UIColor+Colors.h"
#import "UIViewController+Alerts.h"

#ifdef DEBUG
#import "DAZNetworkService.h"
#endif


@interface DAZProfileViewController ()
#ifdef DEBUG
<UIGestureRecognizerDelegate>
#endif

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *profileView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *emailLabel;

@property (nonatomic, weak) UIButton *signOutButton;

@property (nonatomic, weak) UIView *footerView;

@end


@implementation DAZProfileViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.tabBarController.tabBar.translucent = NO;
    
    [self setupHeaderView];
    [self setupFooterView];
    [self setupSignOutButton];
    
#ifdef DEBUG
    [self setupDebugView];
#endif
    
    [self setValuesWithUserProfile];
}

#pragma mark - Setup UI

- (void)setupHeaderView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.15;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 2.0;
    
    [self.view addSubview:view];
    
    self.headerView = view;
    
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
    }];
    
    [self setupProfileView];
}

- (void)setupProfileView
{
    UIView *view = [[UIView alloc] init];
    
    [self.headerView addSubview:view];
    
    self.profileView = view;
    
    [self.profileView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerView);
        make.left.and.right.equalTo(self.view);
    }];
    
    [self setupAvatarImageView];
    [self setupProfileTitle];
    [self setupEmailLabel];
}

- (void)setupAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple Avatar"]];
    
    avatarImageView.layer.cornerRadius = 72.5;
    avatarImageView.layer.masksToBounds = YES;
    
    [self.headerView addSubview:avatarImageView];
    
    self.avatarImageView = avatarImageView;
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileView);
        make.centerX.equalTo(self.profileView);
        make.size.equalTo(@145);
    }];
}

- (void)setupProfileTitle
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    
    [self.headerView addSubview:nameLabel];
    
    self.nameLabel = nameLabel;
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(16);
        make.left.equalTo(self.profileView).with.offset(16);
        make.right.equalTo(self.profileView).with.offset(-16);
        make.centerX.equalTo(self.profileView);
    }];
}

- (void)setupEmailLabel
{
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    emailLabel.textColor = [UIColor lightGrayColor];
    emailLabel.text = @"Вы не авторизованы";
    
    [self.headerView addSubview:emailLabel];
    
    self.emailLabel = emailLabel;
    
    [self.emailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.centerX.equalTo(self.nameLabel);
        make.bottom.equalTo(self.profileView.mas_bottom).with.offset(-32);

    }];
}

- (void)setupFooterView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:view belowSubview:self.headerView];
    
    self.footerView = view;
    
    CAGradientLayer *purpleLayer = [CAGradientLayer gr_purpleGradientLayer];
    purpleLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 180);
    [self.footerView.layer addSublayer:purpleLayer];
    
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@180);
    }];
}

- (void)setupSignOutButton
{
    UIButton *signOutButton = [[UIButton alloc] init];
    
    signOutButton.backgroundColor = [UIColor whiteColor];
    signOutButton.layer.cornerRadius = 24;
    signOutButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [signOutButton setTitle:@"ВЫЙТИ ИЗ ПРОФИЛЯ" forState:UIControlStateNormal];
    [signOutButton setTitleColor:[UIColor cl_darkPurpleColor] forState:UIControlStateNormal];
    [signOutButton addTarget:self action:@selector(actionSignOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:signOutButton];
    
    self.signOutButton = signOutButton;
    
    self.signOutButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.signOutButton.layer.shadowOpacity = 0.15;
    self.signOutButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.signOutButton.layer.shadowRadius = 2.0;
    
    [self.signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_bottom);
        make.leading.equalTo(self.headerView.mas_leading).with.offset(48);
        make.trailing.equalTo(self.headerView.mas_trailing).with.offset(-48);
        make.height.equalTo(@48);
    }];
}


#pragma mark - Actions

- (void)actionSignOut:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
}


#pragma mark - Custom Mutators

- (void)setValuesWithUserProfile
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    
    if (profile.photoURL)
    {
        [self.avatarImageView ch_imageWithContentsOfURL:profile.photoURL];
    }
    
    if (profile.fullName)
    {
        self.nameLabel.text = profile.fullName;
    }
    
    if (profile.email)
    {
        self.emailLabel.text = profile.email;
    }

#ifdef DEBUG
    if (!profile.email)
    {
        self.avatarImageView.userInteractionEnabled = NO;
        [self setupFooterView];
    }
#endif
}


#pragma mark - Debug Target Only

#ifdef DEBUG
- (void)setupDebugView {
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
    
    [self setupGestureRecognizer];
}

- (void)setupGestureRecognizer
{
    UILongPressGestureRecognizer *gestureRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    gestureRecognizer.minimumPressDuration = 0.0;
    [self.avatarImageView addGestureRecognizer:gestureRecognizer];
    
    self.avatarImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageTapped:)];
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

- (void)avatarImagePressed:(UILongPressGestureRecognizer *)sender
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

- (void)avatarImageTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [self al_presentAlertViewControllerWithTitle:@"Готово" message:@"Выборка данных получена. Приятного тестирования!"];
        DAZNetworkService *networkService = [[DAZNetworkService alloc] init];
        [networkService setTestData];
    
        sender.enabled = NO;
    }
}
#endif

@end
