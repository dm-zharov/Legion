//
//  DAZPartiesTableViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "DAZProxyService.h"
#import "DAZPartiesTableViewController.h"
#import "DAZPartyTableViewCell.h"
#import "DAZPartyCreationViewControllersAssembly.h"
#import "DAZPartyDetailsViewControllers.h"
#import "DAZPresentPartyDetailsTransitionController.h"
#import "DAZPlaceholderView.h"

#import "UIViewController+Alerts.h"
#import "CAGradientLayer+Gradients.h"

#import "PartyMO+CoreDataClass.h"


static NSString *const DAZPartiesTableViewCellReuseIdentifier = @"Party Cell";


@interface DAZPartiesTableViewController () <UIViewControllerTransitioningDelegate, DAZProxyServicePartiesDelegate,
                                                DAZPartyCreationViewControllerAssemblyDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, copy) NSArray *partiesArray;

@property (nonatomic, weak) DAZPlaceholderView *placeholderView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic, strong) DAZPresentPartyDetailsTransitionController *presentDetailsViewController;
@property (nonatomic, strong) DAZPartyCreationViewControllersAssembly *partyCreationViewControllerAssembly;

@end


@implementation DAZPartiesTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNetworkService];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupPlaceholderView];
    [self setupRefreshControl];
    
    [self.networkService downloadParties];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView.refreshControl isRefreshing])
    {
        [self.tableView.refreshControl endRefreshing];
    }
}

#pragma mark - Network Service

- (void)setupNetworkService
{
    self.networkService  = [[DAZProxyService alloc] init];
    self.networkService.partiesDelegate = self;
}


#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Вечеринки";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                     target:self
                                                                     action:@selector(actionCreateParty:)];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 16, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    [tableView registerClass:[DAZPartyTableViewCell class] forCellReuseIdentifier:DAZPartiesTableViewCellReuseIdentifier];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupPlaceholderView
{
    DAZPlaceholderView *placeholderView = [[DAZPlaceholderView alloc]
        initWithTitle:@"Вечеринок нет" message:@"Организуйте вечеринку и будьте первым!"];
    placeholderView.hidden = YES;

    [self.view addSubview:placeholderView];
    
    self.placeholderView = placeholderView;
    
    [self.placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshParties:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}


#pragma mark - Actions

- (void)actionRefreshParties:(id)sender
{
    if ([sender isKindOfClass:[UIRefreshControl class]])
    {
        [self.tableView.refreshControl beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.networkService downloadParties];
        });
    }
    else
    {
        [self.networkService downloadParties];
    }
}

- (void)actionCreateParty:(id)sender
{
    self.partyCreationViewControllerAssembly = [[DAZPartyCreationViewControllersAssembly alloc] init];
    self.partyCreationViewControllerAssembly.delegate = self;
    
    UIViewController *partyCreationViewController = [self.partyCreationViewControllerAssembly partyCreationViewController];
    
    [self presentViewController:partyCreationViewController animated:YES completion:nil];
}


#pragma mark - Custom Accessors

- (void)setViewStateWithNetworkStatus:(DAZNetworkStatus)status;
{
    BOOL isOnline = status == DAZNetworkOnline ? YES: NO;
    
    self.navigationItem.rightBarButtonItem.enabled = isOnline;
    self.tableView.allowsSelection = isOnline;

    if (!isOnline)
    {
        [self al_presentOfflineModeAlertViewController];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.partiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAZPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DAZPartiesTableViewCellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PartyMO *party = self.partiesArray[indexPath.row];
    [cell setWithParty:party];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DAZPartyTableViewCell height];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Получение начального фрейма перехода из ячейки
    DAZPartyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect cellFrame = [self.view convertRect:cell.cardView.bounds fromView:cell.cardView];
    
    self.presentDetailsViewController = [[DAZPresentPartyDetailsTransitionController alloc] init];
    self.presentDetailsViewController.cellFrame = cellFrame;
    
    PartyMO *party = self.partiesArray[indexPath.row];
    DAZPartyDetailsViewControllers *partyDetailsViewController = [[DAZPartyDetailsViewControllers alloc] initWithParty:party];
    partyDetailsViewController.delegate = self;
    partyDetailsViewController.transitioningDelegate = self;
    
    [self presentViewController:partyDetailsViewController animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentDetailsViewController;
}

- (void)reloadTableView
{
    if (![self.tableView.refreshControl isRefreshing])
    {
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView performBatchUpdates:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [self.tableView.refreshControl endRefreshing];
            }
        }];
    }
}


#pragma mark - DAZProxyServiceDelegate

- (void)proxyServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)parties networkStatus:(DAZNetworkStatus)status
{
    self.partiesArray = parties;
    
    [self reloadTableView];
    
    [self setViewStateWithNetworkStatus:status];
}

- (void)proxyServiceDidFinishAddPartyWithNetworkStatus:(DAZNetworkStatus)status
{
    [self.networkService downloadParties];
    
    [self setViewStateWithNetworkStatus:status];
}

- (void)proxyServiceDidFinishDeletePartyWithNetworkStatus:(DAZNetworkStatus)status
{
    [self.networkService downloadParties];
    
    [self setViewStateWithNetworkStatus:status];
}


#pragma mark - DAZPartyCreationViewControllerDelegate

- (void)partyCreationViewControllerCompletedWorkWithParty:(PartyMO *)party
{
    [self.networkService addParty:party];
}

@end
