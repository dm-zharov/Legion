//
//  DAZAuthorizationViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZAuthorizationViewController.h"
#import "DAZAuthorizationMediator.h"

#import "DAZPartiesTableViewController.h"

@interface DAZAuthorizationViewController () <DAZAuthorizationServiceDelegate>

@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, weak) UIButton *anonymousInButton;

@end

@implementation DAZAuthorizationViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSignInButton];
    [self setupAnonymousInButton];
    
    [self setupAuthorizationService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup UI

- (void)setupSignInButton
{
    UIEdgeInsetsMake(0, 16, 0, 16);
    UIButton *signInButton = [[UIButton alloc] initWithFrame:
                                CGRectMake(16, 539, CGRectGetWidth(self.view.bounds) - 32, 48)];
    
    [signInButton setBackgroundColor:[UIColor blueColor]];
    signInButton.layer.cornerRadius = 5;
    [signInButton setTitle:@"Авторизоваться через ВК" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(actionSignIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signInButton];
    
    self.signInButton = signInButton;
}

- (void)setupAnonymousInButton
{
    
    UIButton *anonymousInButton = [[UIButton alloc] initWithFrame:
                                     CGRectMake(16, 539 + 48 + 8, CGRectGetWidth(self.view.bounds) - 32, 48)];;
    
    [anonymousInButton setTitle:@"Продолжить без авторизации" forState:UIControlStateNormal];
    [anonymousInButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [anonymousInButton addTarget:self action:@selector(actionAnonymousIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:anonymousInButton];
    
    self.anonymousInButton = anonymousInButton;
    
}

#pragma mark - Actions

- (void)actionSignIn:(id)sender
{
    [self.authorizationService signInWithAuthType:DAZAuthorizationVkontakte];
}

- (void)actionAnonymousIn:(id)sender
{
    [self.authorizationService signInWithAuthType:DAZAuthorizationAnonymously];
}

#pragma mark - DAZAuthorizationService

- (void)setupAuthorizationService
{
    self.authorizationService = [[DAZAuthorizationMediator alloc] init];
    self.authorizationService.delegate = self;
}

#pragma mark - DAZAuthotizationServiceDelegate

- (void)authorizationDidFinishWithResult:(id)result
{
    
    DAZPartiesTableViewController *partiesTableViewController = [[DAZPartiesTableViewController alloc] init];
    //[UIApplication sharedApplication].keyWindow.rootViewController = partiesTableViewController;
    //[self presentViewController:partiesTableViewController animated:YES completion:nil];
    
    self.navigationController.view.backgroundColor = [UIColor redColor];
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.navigationController pushViewController:partiesTableViewController animated:NO];
                    }
                    completion:nil];
    
}

- (void)authorizationDidFinishWithError:(NSError *)error
{
    
    static NSString *alertTitle = @"Ошибка сети";
    static NSString *alertMessage = @"Произошла ошибка подключения, проверьте"
                                     "соединение с интернетом либо попробуйте позже.";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:agreeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)authorizationDidFinishSignOutProcess
{
    
}
@end
