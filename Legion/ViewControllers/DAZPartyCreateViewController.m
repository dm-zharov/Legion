//
//  DAZCreatePartyViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZPartyCreateViewController.h"

@interface DAZPartyCreateViewController ()

@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UIButton *continueButton;

@end

@implementation DAZPartyCreateViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupDatePicker];
    [self setupContinueButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отменить"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(cancelCreateParty:)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Когда состоится тусовка?";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    titleLabel.numberOfLines = 0;
    
    [self.view addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}

- (void)setupDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = datePicker.date;
    
    // Установить максимальную дату на 1 месяц от текущей даты.
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    datePicker.maximumDate = [calendar dateByAddingComponents:dateComponents toDate:datePicker.minimumDate options:0];
    
    [self.view addSubview:datePicker];
    
    self.datePicker = datePicker;
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)setupContinueButton
{
    UIButton *continueButton = [[UIButton alloc] init];
    
    continueButton.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    continueButton.layer.cornerRadius = 10;
    [continueButton setTitle:@"Далее" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[continueButton addTarget:self action:@selector(actionSignIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:continueButton];
    
    self.continueButton = continueButton;
    
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-16);
        make.height.equalTo(@48);
    }];
}

#pragma mark - Actions

- (void)cancelCreateParty:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmCreateParty:(id)sender
{
    
}

@end
