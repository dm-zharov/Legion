//
//  DAZAuthorizationViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZRootViewControllerRouter.h"
#import "DAZAuthorizationViewController.h"
#import "DAZPartiesTableViewController.h"
#import "DAZAuthorizationMediator.h"
#import "CAGradientLayer+Gradients.h"


@interface DAZAuthorizationViewController () <DAZAuthorizationServiceDelegate>

@property (nonatomic, weak) UILabel *greetingLabel;
@property (nonatomic, weak) UILabel *authorizeLabel;
@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, weak) UIButton *anonymousInButton;

@end

@implementation DAZAuthorizationViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackgroundLayer];
    [self setupGreetingLabel];
    [self setupAuthorizeLabel];
    [self setupSignInButton];
    [self setupAnonymousInButton];
    
    [self setupAuthorizationService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Setup UI

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupBackgroundLayer
{
    CAGradientLayer *purpleLayer = [CAGradientLayer purpleGradientLayer];
    purpleLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:purpleLayer atIndex:0];
}

- (void)setupGreetingLabel
{
    UILabel *greetingLabel = [[UILabel alloc] init];
    greetingLabel.text = @"Не можете найти вечеринку в общежитии?";
    greetingLabel.textColor = [UIColor whiteColor];
    greetingLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightBold];
    greetingLabel.numberOfLines = 0;
    
    [self.view addSubview:greetingLabel];
    
    self.greetingLabel = greetingLabel;
    
    [self.greetingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-60);
        make.leading.equalTo(self.view.mas_leading).with.offset(16);
        make.width.equalTo(@325);
    }];
}

- (void)setupAuthorizeLabel
{
    UILabel *authorizeLabel = [[UILabel alloc] init];
    authorizeLabel.text = @"Создайте аккаунт, и мы посмотрим, чем можем вам помочь!";
    authorizeLabel.textColor = [UIColor whiteColor];
    authorizeLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    authorizeLabel.numberOfLines = 0;
    
    [self.view addSubview:authorizeLabel];
    
    self.authorizeLabel = authorizeLabel;
    
    [self.authorizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.greetingLabel.mas_bottom).with.offset(20);
        make.leading.equalTo(self.view.mas_leading).with.offset(16);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-20);
    }];
}

- (void)setupSignInButton
{
    UIButton *signInButton = [[UIButton alloc] init];
    
    signInButton.backgroundColor = [UIColor whiteColor];
    signInButton.layer.cornerRadius = 10;
    [signInButton setTitle:@"Авторизоваться через ВК" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0] forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(actionSignIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signInButton];
    
    self.signInButton = signInButton;
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).with.offset(16);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-16);
        make.height.equalTo(@48);
    }];
}

- (void)setupAnonymousInButton
{
    UIButton *anonymousInButton = [[UIButton alloc] init];;
    
    anonymousInButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    [anonymousInButton setTitle:@"Продолжить без авторизации" forState:UIControlStateNormal];
    [anonymousInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [anonymousInButton addTarget:self action:@selector(actionAnonymousIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:anonymousInButton];
    
    self.anonymousInButton = anonymousInButton;
    
    UIEdgeInsets offsets = UIEdgeInsetsMake(16, 16, -16, -16);
    [self.anonymousInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signInButton.mas_bottom).with.offset(offsets.top);
        make.leading.equalTo(self.view.mas_leading).with.offset(offsets.left);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(offsets.right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(offsets.bottom);
        make.height.equalTo(@48);
    }];
    
}

#pragma mark - Actions

- (void)actionSignIn:(id)sender
{
    [self.authorizationMediator signInWithAuthorizationType:DAZAuthorizationVkontakte];
}

- (void)actionAnonymousIn:(id)sender
{
    [self.authorizationMediator signInWithAuthorizationType:DAZAuthorizationAnonymously];
}

#pragma mark - DAZAuthorizationService

- (void)setupAuthorizationService
{
    self.authorizationMediator = [[DAZAuthorizationMediator alloc] init];
    self.authorizationMediator.delegate = self;
}

#pragma mark - DAZAuthotizationServiceDelegate

- (void)authorizationServiceDidFinishSignInWithResult:(id)result error:(NSError *)error
{
    if (result)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenReceivedNotification object:nil];
    }
    else
    {
        static NSString *alertTitle = @"Ошибка сети";
        static NSString *alertMessage = @"Произошла ошибка подключения, проверьте "
        "соединение с интернетом либо попробуйте позже.";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                       message:alertMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:agreeAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)authorizationServiceDidFinishSignOut
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DAZAuthorizationTokenExpiredNotification object:nil];
}
@end
