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
#import "DAZInfoView.h"
#import "UIColor+Colors.h"
#import "ClaimMO+CoreDataClass.h"

static NSString *const DAZClaimTableViewCellIdentifier = @"DAZClaimTableViewCell";

@interface DAZClaimsTableViewController () <DAZProxyServiceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, copy) NSArray<NSArray *> *claimsArray;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@end

@implementation DAZClaimsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSegmentedControl];
    [self setupTableView];
    [self setupRefreshControl];
    [self setupNetworkService];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.networkService getClaims];
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
    
//    [self.segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).with.offset(16);
//        make.right.equalTo(self.view).with.offset(-16);
//    }];
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

- (void)setupNetworkService
{
    self.networkService  = [[DAZProxyService alloc] init];
    self.networkService.delegate = self;
}

#pragma mark - Actions

- (void)actionSegmentChanged:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]])
    {
        UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            self.tableView.tableFooterView.hidden = YES;
        }
        else if (segmentedControl.selectedSegmentIndex == 1)
        {
            self.tableView.tableFooterView.hidden = NO;
        }
    }
    
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return NO;
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        return YES;
    }
    
    return NO;
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
        [self.networkService getParties];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return self.claimsArray[0].count;
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        return self.claimsArray[1].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAZClaimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DAZClaimTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        ClaimMO *claim = self.claimsArray[0][indexPath.row];
        [cell setWithClaim:claim isIncome:NO];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        ClaimMO *claim = self.claimsArray[1][indexPath.row];
        [cell setWithClaim:claim isIncome:YES];
    }
    
    
    return cell;
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
        ClaimMO *item = self.claimsArray[1][indexPath.row];
        [item setClaimStatus:DAZClaimStatusConfirmed];
        [self.networkService updateClaim:item];
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
        ClaimMO *item = self.claimsArray[1][indexPath.row];
        [item setClaimStatus:DAZClaimStatusClosed];
        [self.networkService updateClaim:item];
        completionHandler(YES);
    }];
    declineAction.backgroundColor = [UIColor redColor];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[declineAction]];
}

#pragma mark - DAZProxyServiceDelegate

- (void)proxyServiceDidFinishDownloadClaims:(NSArray<ClaimMO *> *)claims networkStatus:(DAZNetworkStatus)status
{
    DAZUserProfile *profile = [[DAZUserProfile alloc] init];
    
    // Автор заявки совпадает с авторизованным пользователем
    NSPredicate *outboxPredicate = [NSPredicate predicateWithFormat:@"authorID == %@", profile.userID];
    NSArray *outboxArray = [claims filteredArrayUsingPredicate:outboxPredicate];
    
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
}

@end
