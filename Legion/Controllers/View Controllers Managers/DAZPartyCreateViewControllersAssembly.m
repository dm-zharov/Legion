//
//  DAZPartyCreateViewControllersAssembly.m
//  Legion
//
//  Created by Дмитрий Жаров on 04.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZPartyCreateViewControllersAssembly.h"
#import "DAZSelectionScreenViewController.h"

#import "DAZProxyService.h"
#import "DAZCoreDataManager.h"

static NSString *const DAZPartyMessageDate = @"Когда планируется тусовка?";
static NSString *const DAZPartyMessageTime = @"Во сколько начало?";
static NSString *const DAZPartyMessageAddress = @"В каком общежитии?";
static NSString *const DAZPartyMessageApartment = @"В какой квартире?";
static NSString *const DAZPartyMessageMembers = @"Сколько людей ожидается?";
static NSString *const DAZPartyMessage = @"Добавьте сообщение для гостей!";


@interface DAZPartyCreateViewControllersAssembly () <DAZSelectionScreenDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) DAZProxyService *networkService;

@property (nonatomic, assign) NSInteger currentItem;
@property (nonatomic, copy) NSArray *chainArray;

@end

@implementation DAZPartyCreateViewControllersAssembly

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkService = [[DAZProxyService alloc] init];
    }
    return self;
}

- (UIViewController *)rootViewController
{
    self.currentItem = 0;
    
    self.party = [PartyMO partyWithContext:[DAZCoreDataManager coreDataContext]];
    
    self.chainArray = @[
                        @[DAZPartyMessageDate, @(DAZSelectionScreenDatePicker)],
                        @[DAZPartyMessageTime, @(DAZSelectionScreenTimePicker)],
                        @[DAZPartyMessageAddress, @(DAZSelectionScreenPickerView)],
                        @[DAZPartyMessageApartment, @(DAZSelectionScreenTextField)],
                        @[DAZPartyMessageMembers, @(DAZSelectionScreenSlider)],
                        @[DAZPartyMessage, @(DAZSelectionScreenTextView)]
                       ];
    
    self.navigationController =
        [[UINavigationController alloc] initWithRootViewController:[self nextViewController]];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    return self.navigationController;
}

- (DAZSelectionScreenViewController *)nextViewController
{
    self.currentItem = self.navigationController.viewControllers.count;
    
    NSArray *item = self.chainArray[self.currentItem];
    
    DAZSelectionScreenType type = [item[1] integerValue];
    NSString *message = item[0];
    
    DAZSelectionScreenViewController *nextViewController =
        [[DAZSelectionScreenViewController alloc] initWithType:type message:message];
    nextViewController.delegate = self;
    
    nextViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:nil
                                                                                          action:nil];
    
    if (self.currentItem == 0)
    {
        [self tuneFirstViewController:nextViewController];
    }
    
    if (self.currentItem == (self.chainArray.count - 1))
    {
        [self tuneLastViewController:nextViewController];
    }
        
    return nextViewController;
    
}

- (DAZSelectionScreenViewController *)tuneFirstViewController:(DAZSelectionScreenViewController *)viewController
{
    viewController.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Отменить"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(cancelButtonPressed:)];
    
    return viewController;
}

- (DAZSelectionScreenViewController *)tuneLastViewController:(DAZSelectionScreenViewController *)viewController
{
    [viewController.actionButton setTitle:@"Завершить" forState:UIControlStateNormal];
    
    return viewController;
}

#pragma mark - Actions

- (void)continueButtonPressed
{
    self.currentItem = self.navigationController.viewControllers.count - 1;
    
    if (self.currentItem < self.chainArray.count - 1)
    {
        UIViewController *nextViewController = [self nextViewController];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else
    {
        [self.networkService saveParty:self.party];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DAZSelectionScreenDelegate

- (void)selectionScreenCompletedWorkWithResult:(id)result ofType:(DAZSelectionScreenType)type
{
    switch (type) {
        case DAZSelectionScreenDatePicker:
        {
            NSDate *date = result;
            self.party.date = date;
            break;
        }
        case DAZSelectionScreenTimePicker:
        {
            NSDate *date = result;
            self.party.time = date.timeIntervalSince1970;
            break;
        }
        case DAZSelectionScreenPickerView:
        {
            NSString *address = result;
            self.party.address = address;
            break;
        }
        case DAZSelectionScreenTextField:
        {
            NSString *apartment = result;
            self.party.apartment = apartment;
            break;
        }
        case DAZSelectionScreenTextView:
        {
            NSString *description = result;
            self.party.desc = description;
            break;
        }
        case DAZSelectionScreenSlider:
        {
            NSNumber *members = result;
            self.party.members = [members intValue];
            break;
        }
        default:
            break;
    }

    [self continueButtonPressed];
}
    
@end
