//
//  DAZCreationBaseViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZSelectionScreenBaseViewController.h"
#import "UIColor+Colors.h"

@interface DAZSelectionScreenBaseViewController ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation DAZSelectionScreenBaseViewController


#pragma mark - Lifecycle

- (instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _messageString = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupMessageLabel];
    [self setupContinueButton];
    [self setupContentView];
    // Do any additional setup after loading the view.
}


#pragma mark - Setup UI

- (void)setupMessageLabel
{
    UILabel *messageLabel = [[UILabel alloc] init];
    
    if (self.messageString)
    {
        messageLabel.text = self.messageString;
    }
    
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightMedium];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:messageLabel];
    
    self.messageLabel = messageLabel;
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(16);
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}

- (void)setupContinueButton
{
    UIButton *actionButton = [[UIButton alloc] init];
    
    actionButton.backgroundColor = [UIColor cl_darkPurpleColor];
    actionButton.layer.cornerRadius = 10;
    [actionButton setTitle:@"Далее" forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(actionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:actionButton];
    
    self.actionButton = actionButton;
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-16);
        make.height.equalTo(@48);
    }];
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.actionButton.mas_top);
    }];
    
    [self setupContentInView:contentView];
}


#pragma mark - DAZSelectionScreenBaseViewControllerProtocol

- (void)setupContentInView:(UIView *)contentView
{
    return;
}

- (void)actionButtonPressed
{
    return;
}

@end
