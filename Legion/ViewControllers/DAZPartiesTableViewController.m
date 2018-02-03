//
//  DAZPartiesTableViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "DAZViewControllerRouter.h"
#import "DAZPartiesTableViewController.h"
#import "DAZPartyTableViewCell.h"
#import "DAZProxyService.h"

#import "PartyMO+CoreDataClass.h"


static NSString *const DAZPartiesTableViewCellReuseIdentifier = @"Party Cell";


@interface DAZPartiesTableViewController () <DAZProxyServiceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DAZProxyService *networkService;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, nullable, copy) NSArray<PartyMO *> *partiesArray;

@end

@implementation DAZPartiesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupNetworkService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    //[self.tableView.refreshControl beginRefreshing];
    
    [self.networkService getParties];
}

#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Тусовки";
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    //tableView.estimatedRowHeight = 200;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    //tableView.refreshControl = [[UIRefreshControl alloc] init];
    
    [tableView registerClass:[DAZPartyTableViewCell class] forCellReuseIdentifier:@"DAZPartyTableViewCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupNetworkService {
    self.networkService  = [[DAZProxyService alloc] init];
    self.networkService.delegate = self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.partiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAZPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DAZPartyTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PartyMO *party = self.partiesArray[indexPath.row];
    [cell setWithParty:party];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.layer.opacity = 0;
//    [UIView animateWithDuration:0.75 animations:^{
//        cell.layer.opacity = 1;
//    }];
}

#pragma mark - DAZProxyServiceDelegate

- (void)proxyServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)array
{
    self.partiesArray = array;
    
    //[self.tableView.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
