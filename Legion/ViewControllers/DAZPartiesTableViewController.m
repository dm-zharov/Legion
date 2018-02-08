//
//  DAZPartiesTableViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 22.01.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "DAZRootViewControllerRouter.h"
#import "DAZPartiesTableViewController.h"
#import "DAZPartyTableViewCell.h"
#import "DAZPartyDetailsViewControllers.h"
#import "DAZProxyService.h"
#import "DAZPartyCreationViewControllersAssembly.h"

#import "CAGradientLayer+Gradients.h"

#import "PartyMO+CoreDataClass.h"


static NSString *const DAZPartiesTableViewCellReuseIdentifier = @"Party Cell";


@interface DAZPartiesTableViewController () <DAZProxyServiceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, nullable, copy) NSArray<PartyMO *> *partiesArray;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic, weak) UIView *purpleView;
@property (nonatomic, assign) CGRect cellRect;

@property (nonatomic, strong) DAZPartyCreationViewControllersAssembly *partyCreateViewController;

@end

@implementation DAZPartiesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupRefreshControl];
    [self setupNetworkService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.networkService getParties];
}

#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Тусовки";
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
    
    [tableView registerClass:[DAZPartyTableViewCell class] forCellReuseIdentifier:@"DAZPartyTableViewCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(actionRefreshParties:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}

- (void)setupNetworkService {
    self.networkService  = [[DAZProxyService alloc] init];
    self.networkService.delegate = self;
}

#pragma mark - Actions

- (void)actionRefreshParties:(id)sender
{
    if ([sender isKindOfClass:[UIRefreshControl class]])
    {
        [self.tableView.refreshControl beginRefreshing];
        [self.networkService performSelector:@selector(getParties) withObject:nil afterDelay:0.5];
    }
    else
    {
        [self.networkService getParties];
    }
}

- (void)actionCreateParty:(id)sender
{
    self.partyCreateViewController = [[DAZPartyCreationViewControllersAssembly alloc] init];
    
    UIViewController *partyCreateViewController = [self.partyCreateViewController rootViewController];
    
    [self presentViewController:partyCreateViewController animated:YES completion:nil];
}

- (void)actionShowParty:(id)sender
{
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DAZPartyTableViewCell height];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Получение начального фрейма перехода из ячейки
    DAZPartyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect cellFrame = [self.view convertRect:cell.cardView.bounds fromView:cell.cardView];
    self.cellRect = cellFrame;
    
    UIView *purpleView = [[UIView alloc] initWithFrame:cellFrame];
    self.purpleView = purpleView;

    CAGradientLayer *purpleLayer = [CAGradientLayer purpleGradientLayer];
    purpleLayer.frame = self.view.bounds;
    [purpleView.layer addSublayer:purpleLayer];
    
    purpleView.layer.cornerRadius = 10;
    purpleView.layer.masksToBounds = YES;
    purpleView.userInteractionEnabled = YES;
    
    [self.view addSubview:purpleView];
    
    DAZPartyDetailsViewControllers *partyDetailsViewController = [[DAZPartyDetailsViewControllers alloc] init];
    partyDetailsViewController.delegate = self;
    partyDetailsViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    partyDetailsViewController.party = self.partiesArray[indexPath.row];
    
    partyDetailsViewController.view.frame = CGRectInset(self.view.frame, 50, 50);
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        purpleView.layer.cornerRadius = 5;
        purpleView.frame = self.view.frame;
        
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        self.navigationController.navigationBar.transform =
            CGAffineTransformMakeTranslation(0, -(CGRectGetHeight(navigationBarFrame) + 20));
        
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        self.tabBarController.tabBar.transform =
            CGAffineTransformMakeTranslation(0, CGRectGetHeight(tabBarFrame));
     } completion:^(BOOL finished) {
         self.navigationController.navigationBarHidden = YES;
         [self presentViewController:partyDetailsViewController animated:YES completion:nil];
     }];
}

- (void)dismiss
{
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.navigationController.navigationBar.transform =
                         CGAffineTransformIdentity;
                         
                         self.tabBarController.tabBar.transform =
                         CGAffineTransformIdentity;
                         
                         self.purpleView.layer.cornerRadius = 10;
                         self.purpleView.frame = self.cellRect;
                     } completion:^(BOOL finished) {
                         [self.purpleView removeFromSuperview];
                     }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.navigationController isNavigationBarHidden])
    {
        return UIStatusBarStyleDefault;
    }
    else
    {
        return UIStatusBarStyleLightContent;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.layer.opacity = 0;
//    [UIView animateWithDuration:0.75 animations:^{
//        cell.layer.opacity = 1;
//    }];
}

#pragma mark - DAZProxyServiceDelegate


- (void)proxyServiceDidFinishDownloadParties:(NSArray<PartyMO *> *)array networkStatus:(DAZNetworkStatus)status
{
    self.partiesArray = array;
    
    [self.tableView performBatchUpdates:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationNone];
    } completion:^(BOOL finished) {
        if (finished)
        {
            if ([self.tableView.refreshControl isRefreshing])
            {
                [self.tableView.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
            }
        }
    }];
}

@end
