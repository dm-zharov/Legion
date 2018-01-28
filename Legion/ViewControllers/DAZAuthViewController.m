//
//  DAZStartViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 27.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <SafariServices/SafariServices.h>

#import "DAZAuthViewController.h"
#import "DAZVkontakteNetworkService.h"

@interface DAZAuthViewController ()

@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, weak) UIButton *anonInButton;

@property (nonatomic, strong) SFAuthenticationSession *session;
@property (nonatomic, strong) DAZVkontakteNetworkService *VKNetworkService;

@end

@implementation DAZAuthViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSignInButton];
    [self setupAnonInButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup UI

- (void)setupSignInButton
{
    UIEdgeInsetsMake(0, 16, 0, 16);
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 539, CGRectGetWidth(self.view.bounds) - 32, 48)];
    
    [signInButton setBackgroundColor:[UIColor blueColor]];
    signInButton.layer.cornerRadius = 5;
    [signInButton setTitle:@"Авторизоваться через ВК" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(actionSignIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signInButton];
    
    self.signInButton = signInButton;
}

- (void)setupAnonInButton
{
    
    UIButton *anonInButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 539 + 48 + 8, CGRectGetWidth(self.view.bounds) - 32, 48)];;
    
    [anonInButton setTitle:@"Продолжить без авторизации" forState:UIControlStateNormal];
    [anonInButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [anonInButton addTarget:self action:@selector(actionAnonIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:anonInButton];
    
    self.anonInButton = anonInButton;
    
}

#pragma mark - Actions

- (void)actionSignIn:(id)sender
{
    NSString *urlString = @"authorize?revoke=1&response_type=token&display=mobile&scope=friends%2Cemail%2Coffline&v=5.40&redirect_uri=vk6347345%3A%2F%2Fauthorize&sdk_version=1.4.6&client_id=6347345";
    
    // VK App vkauthorize://authorize?client_id=6347345&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.52
    // Safari // https://oauth.vk.com/authorize?revoke=1&response_type=token&display=mobile&scope=friends%2Cemail%2Coffline&v=5.40&redirect_uri=vk6347345%3A%2F%2Fauthorize&sdk_version=1.4.6&client_id=6347345
    
    /* https://oauth.vk.com/authorize
     ?client_id=5490057
     &display=page
     &redirect_uri=
     https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.52
     */

    
    BOOL vkAppExist = [self vkAppExist];
    
    if (vkAppExist) {
        
        NSURL *baseURL = [NSURL URLWithString:@"vkauthorize://authorize"];
        NSURL *absoluteURL = [NSURL URLWithString:urlString relativeToURL:baseURL];
        
        UIApplication *application = [UIApplication sharedApplication];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            NSDictionary *options = @{ UIApplicationOpenURLOptionUniversalLinksOnly: @NO };
            
            [application openURL:absoluteURL options:options completionHandler:^(BOOL success) {
                
                if (!success) {
                    // Произошла ошибка авторизации
                }
            }];
        }
    } else {
        NSURL *baseURL = [NSURL URLWithString:@"https://oauth.vk.com/"];
        NSURL *absoluteURL = [NSURL URLWithString:urlString relativeToURL:baseURL];
        
        SFAuthenticationSession *session = [[SFAuthenticationSession alloc] initWithURL:absoluteURL callbackURLScheme:@"vk6347345://" completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
            if (callbackURL) {
                NSLog(@"%@", callbackURL.absoluteString);
            }
            
            [self.session cancel];
        }];
        
        
        self.session = session;
        [self.session start];
//        SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:urlToOpen];
//        viewController.delegate = self;
//        
//        [self.navigationController.topViewController presentViewController:viewController animated:YES completion:nil];
    }
    
}

- (void)actionAnonIn:(id)sender
{
    
}

- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL {
    
}

#pragma mark - Authorization

- (BOOL)vkAppExist {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vkauthorize://authorize"]];
}

@end
