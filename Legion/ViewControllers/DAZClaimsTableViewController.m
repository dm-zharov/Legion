//
//  DAZClaimsTableViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 07.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>

#import "DAZClaimsTableViewController.h"
#import "DAZClaimTableViewCell.h"

#import "DAZProxyService.h"
#import "DAZUserProfile.h"
#import "DAZPlaceholderView.h"
#import "DAZInfoView.h"

#import "UIViewController+Alerts.h"
#import "UIColor+Colors.h"
#import "ClaimMO+CoreDataClass.h"


static NSString *const DAZClaimTableViewCellIdentifier = @"DAZClaimTableViewCell";

static NSString *const DAZPlaceholderViewTitle = @"Запросов нет";
static NSString *const DAZPlaceholderViewInboxMessage =
    @"Организуйте вечеринку и управляйте входящими запросами на место проведения здесь!";
static NSString *const DAZPlaceholderViewOutboxMessage =
    @"Все отправленные вами запросы на получение адресов тусовок будут отображены здесь";


@interface DAZClaimsTableViewController () <DAZProxyServiceClaimsDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, getter=isInbox, assign) BOOL inbox;

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, weak) DAZPlaceholderView *placeholderView;

@property (nonatomic, copy) NSArray<NSArray *> *claimsArray;

@end


@implementation DAZClaimsTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNetworkService];
    
    [self setupNavigationBar];
    [self setupSegmentedControl];
    
    [self setupTableView];
    [self setupPlaceholderView];
    
    [self setupRefreshControl];
    
    [self.networkService downloadClaims];
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
    self.networkService.claimsDelegate = self;
}


#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Запросы";
}

- (void)setupSegmentedControl
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Отправленные", @"Входящие"]];
    [segmentedControl addTarget:self action:@selector(actionSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = segmentedControl;
    
    self.segmentedControl = segmentedControl;
}

- (void)setupPlaceholderView
{
    DAZPlaceholderView *placeholderView = [[DAZPlaceholderView alloc]
        initWithTitle:DAZPlaceholderViewTitle message:DAZPlaceholderViewOutboxMessage];
    placeholderView.hidden = YES;
    
    [self.tableView addSubview:placeholderView];
    
    self.placeholderView = placeholderView;
    
    [self.placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    tableView.allowsSelection = NO;
    
    [tableView registerClass:[DAZClaimTableViewCell class] forCellReuseIdentifier:DAZClaimTableViewCellIdentifier];
    
    DAZInfoView *footerView = [[DAZInfoView alloc] init];
    footerView.infoLabel.text = @"Подтверждение заявки отправляет гостю полный адрес";
    tableView.tableFooterView = footerView;
    tableView.tableFooterView.hidden = YES;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshClaims:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}


#pragma mark - Actions

- (void)actionSegmentChanged:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]])
    {
        UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
        NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
        
        if (selectedSegment == 0)
        {
            self.inbox = NO;
            self.tableView.tableFooterView.hidden = YES;
            self.placeholderView.message = DAZPlaceholderViewOutboxMessage;
        }
        else if (selectedSegment == 1)
        {
            self.inbox = YES;
            self.tableView.tableFooterView.hidden = NO;
            self.placeholderView.message = DAZPlaceholderViewInboxMessage;
        }
        
        self.placeholderView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (void)actionRefreshClaims:(id)sender
{
    if ([sender isKindOfClass:[UIRefreshControl class]])
    {
        [self.tableView.refreshControl beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.networkService downloadClaims];
        });
    }
    else
    {
        [self.networkService downloadClaims];
    }
}

- (void)actionConfirmClaim:(ClaimMO *)claim
{
    [claim setClaimStatus:DAZClaimStatusConfirmed];
    [self.networkService updateClaim:claim];
}

- (void)actionDeclineClaim:(ClaimMO *)claim
{
    [claim setClaimStatus:DAZClaimStatusClosed];
    [self.networkService updateClaim:claim];
}


#pragma mark - Custom Accessors

- (void)setViewStateWithNetworkStatus:(DAZNetworkStatus)status
{
    if (status == DAZNetworkOffline)
    {
        [self al_presentOfflineModeAlertViewController];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = [self isInbox] ? 1 : 0;
    
    if (self.claimsArray[index].count == 0)
    {
        self.tableView.tableFooterView.hidden = YES;
        self.placeholderView.hidden = NO;
    }
    else
    {
        self.placeholderView.hidden = YES;
    }
    
    return self.claimsArray[index].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self isInbox] ? 1 : 0;
    
    DAZClaimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DAZClaimTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    ClaimMO *claim = self.claimsArray[index][indexPath.row];
    [cell setWithClaim:claim isIncome:[self isInbox]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isInbox];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DAZClaimTableViewCell height];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *confirmAction = [UIContextualAction
        contextualActionWithStyle:UIContextualActionStyleDestructive
                            title:@"Подтвердить"
                          handler:^(UIContextualAction *action, UIView *sourceView, void (^ completionHandler)(BOOL)) {
        NSInteger index = [self isInbox] ? 1 : 0;
                              
        ClaimMO *item = self.claimsArray[index][indexPath.row];
        [self actionConfirmClaim:item];
        completionHandler(YES);
    }];
    confirmAction.backgroundColor = [UIColor cl_lightPurpleColor];
    
    UISwipeActionsConfiguration *swipeActionsConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[confirmAction]];
    swipeActionsConfiguration.performsFirstActionWithFullSwipe = NO;
    
    return swipeActionsConfiguration;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *declineAction = [UIContextualAction
        contextualActionWithStyle:UIContextualActionStyleDestructive
                            title:@"Отклонить"
                          handler:^(UIContextualAction *action, UIView *sourceView, void (^ completionHandler)(BOOL)) {
        NSInteger index = [self isInbox] ? 1 : 0;
                            
        ClaimMO *item = self.claimsArray[index][indexPath.row];
        [self actionDeclineClaim:item];
        completionHandler(YES);
    }];
    declineAction.backgroundColor = [UIColor redColor];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[declineAction]];
}


#pragma mark - DAZProxyServiceDelegate

- (void)proxyServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)claims networkStatus:(DAZNetworkStatus)status
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    
    // Идентификатор отправишего запрос совпадает с авторизованным пользователем
    NSPredicate *outboxPredicate = [NSPredicate predicateWithFormat:@"authorID == %@", profile.userID];
    NSArray *outboxArray = [claims filteredArrayUsingPredicate:outboxPredicate];
    
    // Заявки, отправленные авторизованному пользователю
    NSPredicate *inboxPredicate = [NSPredicate predicateWithFormat:@"authorID != %@", profile.userID];
    NSArray *inboxArray = [claims filteredArrayUsingPredicate:inboxPredicate];
    
    NSArray *claimsArray = @[outboxArray, inboxArray];
    
    self.claimsArray = claimsArray;
    
    if (![self.tableView.refreshControl isRefreshing])
    {
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView performBatchUpdates:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationNone];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [self.tableView.refreshControl endRefreshing];
            }
        }];
    }
    
    if (status == DAZNetworkOffline)
    {
        [self setViewStateWithNetworkStatus:status];
    }
}

@end
