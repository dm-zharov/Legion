//
//  DAZPartyCreateViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 04.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>

#import "DAZSelectionScreenViewController.h"
#import "UIColor+Colors.h"

@interface DAZSelectionScreenViewController () <UIPickerViewDataSource, UIPickerViewDelegate,
                                                    UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) DAZSelectionScreenType type;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *pickerData;
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, copy)NSString * textViewPlaceholder;

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
    else if (self.textView && [self.textView canBecomeFirstResponder])
    {
        [self.textView becomeFirstResponder];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutsideTextView:)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
}


#pragma mark - DAZSelectionScreenBaseViewControllerProtocol

- (void)setupContentInView:(UIView *)contentView
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
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 30;
    
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Округлить до ближайших следующих 30 минут
    NSDateComponents *minuteComponent = [calendar components:NSCalendarUnitMinute fromDate:datePicker.date];
    minuteComponent.minute = 30 - ([minuteComponent minute] % 30);
    datePicker.date = [calendar dateByAddingComponents:minuteComponent toDate:datePicker.date options:0];
    
    datePicker.minimumDate = datePicker.date;
    
    // Установить максимальную дату на 1 месяц от текущей даты
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    datePicker.maximumDate = [calendar dateByAddingComponents:dateComponents toDate:datePicker.minimumDate options:0];
    
    datePicker.date = datePicker.minimumDate;
    
    [self.contentView addSubview:datePicker];
    
    self.datePicker = datePicker;
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
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
    textField.textColor = [UIColor cl_darkPurpleColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length < 10)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    
    [self selectionCompleted];
    
    return YES;
}

#pragma mark - DAZSelectionScreenTextView

- (void)setupTextView
{
    UITextView *textView = [[UITextView alloc] init];
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    // Placeholder text
    self.textViewPlaceholder = @"Скажите гостям: что взять с собой, какие условия... Минимум 10 символов!";
    textView.text = self.textViewPlaceholder;
    textView.textColor = [UIColor lightGrayColor];
    
    textView.delegate = self;
    
    textView.textContainer.maximumNumberOfLines = 12;
    textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:textView];
    
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(16);
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
    }];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:self.textViewPlaceholder])
    {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    
    return YES;
}

#pragma mark Actions

-(void)tappedOutsideTextView:(UITapGestureRecognizer *)tapRecognizer
{
    if ([self.textView isFirstResponder] && [self.textView.text length] > 10)
    {
        [self.textView resignFirstResponder];
    }
    else if ([self.textView canBecomeFirstResponder])
    {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - DAZSelectionScreenSlider

- (void)setupSlider
{
    UILabel *membersLabel = [[UILabel alloc] init];
    
    membersLabel.text = @"5";
    membersLabel.font = [UIFont systemFontOfSize:27 weight:UIFontWeightBold];
    membersLabel.textColor = [UIColor cl_darkPurpleColor];
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
