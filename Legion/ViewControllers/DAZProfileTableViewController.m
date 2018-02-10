//
//  DAZProfileTableViewController.m
//  Legion
//
//  Created by Дмитрий Жаров on 07.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZProfileTableViewController.h"
#import "DAZProfileTableViewCell.h"
#import "DAZLogoutTableViewCell.h"

@interface DAZProfileTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation DAZProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

#pragma mark - Setup UI

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Профиль";
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Настройки" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.contentInset = UIEdgeInsetsMake(-19, 0, 0, 0);
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    [tableView registerClass:[DAZProfileTableViewCell class] forCellReuseIdentifier:@"DAZProfileTableViewCell"];
    [tableView registerClass:[DAZLogoutTableViewCell class] forCellReuseIdentifier:@"DAZLogoutTableViewCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        DAZProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DAZProfileTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = @"Дмитрий Жаров";
        
        cell.partiesLabel.text = @"0";
        
        cell.membersLabel.text = @"0";
        
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        DAZLogoutTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DAZLogoutTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return [DAZProfileTableViewCell height];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return [DAZLogoutTableViewCell height];
    }
    
    return UITableViewAutomaticDimension;
}

@end
