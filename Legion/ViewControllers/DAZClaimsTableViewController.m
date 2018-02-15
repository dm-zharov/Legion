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
#import "DAZEmptyViewPlaceholder.h"
#import "DAZInfoView.h"

#import "UIViewController+Alerts.h"
#import "UIColor+Colors.h"
#import "ClaimMO+CoreDataClass.h"


static NSString *const DAZClaimTableViewCellIdentifier = @"DAZClaimTableViewCell";


@interface DAZClaimsTableViewController () <DAZProxyServiceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, getter=isInbox, assign) BOOL inbox;

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic, copy) NSArray<NSArray *> *claimsArray;
@property (nonatomic, copy) NSArray<DAZEmptyViewPlaceholder *> *placeholdersArray;

@property (nonatomic, assign) NSInteger selectedSegment;

@end


@implementation DAZClaimsTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNetworkService];
    
    [self setupNavigationBar];
    [self setupSegmentedControl];
    
    [self setupTableView];
    [self setupPlaceholdersViews];
    
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.networkService getClaims];
}


#pragma mark - Network Service

- (void)setupNetworkService
{
    self.networkService  = [[DAZProxyService alloc] init];
    self.networkService.delegate = self;
}


#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Запросы";
}

- (void)setupSegmentedControl
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Отправленные", @"Входящие"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(actionSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;
    
    self.segmentedControl = segmentedControl;
}

- (void)setupPlaceholdersViews
{
    DAZEmptyViewPlaceholder *outboxPlaceholderView = [[DAZEmptyViewPlaceholder alloc]
        initWithTitle:@"Запросов нет" message:@"Все отправленные вами запросы на получение адресов тусовок будут "
                                                        "отображены здесь"];
    outboxPlaceholderView.hidden = YES;
    [self.view addSubview:outboxPlaceholderView];
    
    [outboxPlaceholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    DAZEmptyViewPlaceholder *inboxPlaceholderView = [[DAZEmptyViewPlaceholder alloc]
        initWithTitle:@"Запросов нет" message:@"Организуйте тусовку и управляйте входящими запросами на место "
                                                        "проведения здесь!"];
    inboxPlaceholderView.hidden = YES;
    [self.view addSubview:inboxPlaceholderView];
    
    [inboxPlaceholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.placeholdersArray = @[outboxPlaceholderView, inboxPlaceholderView];
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
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            self.inbox = NO;
            self.tableView.tableFooterView.hidden = YES;
            self.placeholdersArray[1].hidden = YES;
        }
        else if (segmentedControl.selectedSegmentIndex == 1)
        {
            self.inbox = YES;
            self.tableView.tableFooterView.hidden = NO;
            self.placeholdersArray[0].hidden = YES;
        }
    }
    
    [self.tableView reloadData];
}

- (void)actionRefreshClaims:(id)sender
{
    if ([sender isKindOfClass:[UIRefreshControl class]])
    {
        [self.tableView.refreshControl beginRefreshing];
        [self.networkService performSelector:@selector(getClaims) withObject:nil afterDelay:0.5];
    }
    else
    {
        [self.networkService getClaims];
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
    
    self.tableView.hidden = (self.claimsArray[index].count == 0);
    self.placeholdersArray[index].hidden = (![self.tableView isHidden]);
    
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
