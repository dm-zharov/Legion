//
//  DAZPartyCreateViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 04.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>

#import "DAZSelectionScreenViewController.h"

@interface DAZSelectionScreenViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) DAZSelectionScreenType type;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UIDatePicker *timePicker;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *pickerData;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, weak) UILabel *membersLabel;
@property (nonatomic, weak) UISlider *sliderView;

@end

@implementation DAZSelectionScreenViewController

#pragma mark - Lifecycle

- (instancetype)initWithType:(DAZSelectionScreenType)type message:(NSString *)message
{
    self = [super initWithMessage:message];
    if (self) {
        _type = type;
        _message = message;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.textField && [self.textField canBecomeFirstResponder])
    {
        [self.textField becomeFirstResponder];
    }
    
    if (self.textView && [self.textView canBecomeFirstResponder])
    {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - DAZSelectionScreenBaseViewControllerProtocol

- (void)contentInView:(UIView *)contentView
{
    if (!contentView)
    {
        return;
    }
    
    self.contentView = contentView;
    
    switch (self.type)
    {
        case DAZSelectionScreenDatePicker:
            [self setupDatePicker];
            break;
        case DAZSelectionScreenTimePicker:
            [self setupTimePicker];
            break;
        case DAZSelectionScreenPickerView:
            [self setupPickerView];
            break;
        case DAZSelectionScreenTextField:
            [self setupTextField];
            break;
        case DAZSelectionScreenTextView:
            [self setupTextView];
            break;
        case DAZSelectionScreenSlider:
            [self setupSlider];
        default:
            break;
    }
}

- (void)actionButtonPressed
{
    [self selectionCompleted];
}

#pragma mark - DAZSelectionScreenDatePicker

- (void)setupDatePicker
{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    datePicker.date = [calendar startOfDayForDate:datePicker.date];
    
    datePicker.timeZone = [NSTimeZone localTimeZone];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    
    // Установить максимальную дату на 1 месяц от текущей даты.
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    datePicker.minimumDate = datePicker.date;
    datePicker.maximumDate = [calendar dateByAddingComponents:dateComponents toDate:datePicker.minimumDate options:0];
    
    [self.contentView addSubview:datePicker];
    
    self.datePicker = datePicker;
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.and.right.equalTo(self.view);
    }];
}

#pragma mark - DAZSelectionScreenTimePicker

- (void)setupTimePicker
{
    UIDatePicker *timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    timePicker.minimumDate = [calendar startOfDayForDate:timePicker.date];
    
    timePicker.timeZone = [NSTimeZone localTimeZone];
    timePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    
    timePicker.minuteInterval = 30;
    
    // Установить по умолчанию на 20:00
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 24;
    timePicker.maximumDate = [calendar dateByAddingComponents:dateComponents toDate:timePicker.minimumDate options:0];
    
    [self.contentView addSubview:timePicker];
    
    self.timePicker = timePicker;
    
    [self.timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.and.right.equalTo(self.view);
    }];
}

#pragma mark DAZSelectionScreenPickerView

- (void)setupPickerView
{
    self.pickerData = @[@"Трилистник", @"Дубки"];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    
    [self.contentView addSubview:pickerView];
    
    self.pickerView = pickerView;
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.and.right.equalTo(self.view);
    }];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}


#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

#pragma mark - DAZSelectionScreenTextField

- (void)setupTextField
{
    UITextField *textField = [[UITextField alloc] init];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:27 weight:UIFontWeightBold];
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textField.returnKeyType = UIReturnKeyNext;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    
    textField.delegate = self;
    
    [self.contentView addSubview:textField];
    
    self.textField = textField;
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    
    [self selectionCompleted];
    
    return YES;
}

#pragma mark - DAZSelectionScreenSliderTextView

- (void)setupTextView
{
    UITextView *textView = [[UITextView alloc] init];
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    textView.textContainer.maximumNumberOfLines = 12;
    textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:textView];
    
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(16);
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.left.equalTo(self.contentView.mas_right).with.offset(-16);
    }];
}

#pragma mark UITextViewDelegate

#pragma mark - DAZSelectionScreenSlider

- (void)setupSlider
{
    UILabel *membersLabel = [[UILabel alloc] init];
    
    membersLabel.text = @"5";
    membersLabel.font = [UIFont systemFontOfSize:27 weight:UIFontWeightBold];
    membersLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:1.0];
    membersLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:membersLabel];
    
    self.membersLabel = membersLabel;
    
    UISlider *sliderView = [[UISlider alloc] init];
    sliderView.minimumValue = 5;
    sliderView.value = 2;
    sliderView.maximumValue = 50;
    
    [self.contentView addSubview:sliderView];
    
    self.sliderView = sliderView;
    
    [self.sliderView addTarget:self action:@selector(actionSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.membersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(48);
        make.right.equalTo(self.contentView.mas_right).with.offset(-48);
        make.centerY.equalTo(self.contentView.mas_centerY).multipliedBy(0.5);
    }];

    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(32);
        make.right.equalTo(self.contentView.mas_right).with.offset(-32);
        make.centerY.equalTo(self.contentView.mas_centerY).multipliedBy(1.5);
    }];
}

- (void)actionSliderValueChanged:(UISlider *)sender
{
    NSInteger step = 5;
    NSInteger membersCount = (NSInteger)(sender.value / step) * step;
    sender.value = (float)membersCount;
    self.membersLabel.text = [NSString stringWithFormat:@"%@", @(membersCount)];
}

#pragma mark - DAZSelectionScreenDelegate

- (void)selectionCompleted
{
    id result;
    
    switch (self.type)
    {
        case DAZSelectionScreenDatePicker:
        {
            result = self.datePicker.date;
            break;
        }
        case DAZSelectionScreenTimePicker:
        {
            result = self.timePicker.date;
            break;
        }
        case DAZSelectionScreenPickerView:
        {
            NSInteger row = [self.pickerView selectedRowInComponent:0];
            result = self.pickerData[row];
            break;
        }
        case DAZSelectionScreenTextField:
        {
            result = self.textField.text;
            break;
        }
        case DAZSelectionScreenTextView:
        {
            result = self.textView.text;
            break;
        }
        case DAZSelectionScreenSlider:
        {
            result = @(self.sliderView.value);
            break;
        }
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(selectionScreenCompletedWorkWithResult:ofType:)])
    {
        [self.delegate selectionScreenCompletedWorkWithResult:result ofType:self.type];
    }
}

@end
