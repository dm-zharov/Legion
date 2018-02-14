//
//  DAZPartyDetailsViewControllers.m
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZPartyDetailsViewControllers.h"
#import "DAZProxyService.h"
#import "CAGradientLayer+Gradients.h"
#import "UIImage+Overlay.h"
#import "UIColor+Colors.h"
#import "UIImage+Cache.h"
#import "UINavigationBar+Shadow.h"
#import "PartyMO+CoreDataClass.h"


@interface DAZPartyDetailsViewControllers () <DAZProxyServiceDelegate, UINavigationBarDelegate, UIScrollViewDelegate>

@property (nonatomic, getter=isStatusBarLight, assign) BOOL statusBarLight;

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, strong) PartyMO *party;

@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UIView *navigationBackground;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *navigationLabel;

@property (nonatomic, weak) UIView *detailsView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) UILabel *descriptionHeading;
@property (nonatomic, weak) UILabel *descriptionLabel;

@property (nonatomic, weak) UIButton *claimButton;
@property (nonatomic, weak) UIButton *inviteButton;

@property (nonatomic, weak) UILabel *addressHeading;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *apartmentLabel;

@property (nonatomic, weak) UILabel *membersHeading;
@property (nonatomic, weak) UILabel *membersLabel;

@property (nonatomic, weak) UIButton *editButton;
@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, weak) UIButton *closeButton;

@end


@implementation DAZPartyDetailsViewControllers


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNetworkService];
    [self setupBackgroundLayer];
    [self setupScrollView];
    [self setupNavigationBar];
    [self setupCloseButton];
    
    [self setContentWithParty:self.party];
    
    self.statusBarLight = YES;
    [self preferredStatusBarStyle];
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat contentWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat contentHeight = CGRectGetHeight(self.contentView.frame) + 60;
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.statusBarLight = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Network Service

- (void)setupNetworkService
{
    self.networkService = [[DAZProxyService alloc] init];
    self.networkService.delegate = self;
}

#pragma mark - Setup UI

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self isStatusBarLight])
    {
        return UIStatusBarStyleLightContent;
    }
    else
    {
        return UIStatusBarStyleDefault;
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)setupBackgroundLayer
{
    CAGradientLayer *purpleLayer = [CAGradientLayer gr_purpleGradientLayer];
    purpleLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:purpleLayer];
}

- (void)setupNavigationBar
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.items = @[self.navigationItem];
    navigationBar.delegate = self;
    navigationBar.alpha = 0;
    
    // Делаем навигационный бар полностью прозрачным
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = YES;
    
    self.navigationItem.title = @"Подробности";
    self.navigationItem.hidesBackButton = YES;
    
    [self.view addSubview:navigationBar];
    
    self.navigationBar = navigationBar;
    
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    self.navigationBar = navigationBar;
    
    UIView *navigationBackground = [[UIView alloc] init];
    navigationBackground.backgroundColor = [UIColor whiteColor];    navigationBackground.alpha = 0;
    
    [self.view insertSubview:navigationBackground belowSubview:navigationBar];
    
    self.navigationBackground = navigationBackground;

    [navigationBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(navigationBar);
    }];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    scrollView.layer.masksToBounds = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self setupContentView];
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:contentView];
    
    self.contentView = contentView;
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self setupHeaderView];
    [self setupDetailsView];
    
}

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowOpacity = 0.15;
    headerView.layer.shadowOffset = CGSizeMake(0, 2);
    headerView.layer.shadowRadius = 2.0;
    
    [self.contentView addSubview:headerView];
    
    self.headerView = headerView;
    
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@120);
    }];
    
    [self setupNavigationLabel];
}

- (void)setupNavigationLabel
{
    UILabel *navigationLabel = [[UILabel alloc] init];
    navigationLabel.textColor = [UIColor whiteColor];
    navigationLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    navigationLabel.text = @"Бардак";
    
    [self.headerView addSubview:navigationLabel];
    
    self.navigationLabel = navigationLabel;
    
    [self.navigationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).with.offset(64);
        make.left.equalTo(self.headerView).with.offset(16);
        make.right.equalTo(self.headerView).with.offset(-16);
    }];
}

#pragma mark - Detail View UI

- (void)setupDetailsView
{
    UIView *detailsView = [[UIView alloc] init];
    detailsView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView insertSubview:detailsView belowSubview:self.headerView];
    
    self.detailsView = detailsView;

    [self.detailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        //make.left.and.bottom.and.right.equalTo(self.contentView);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(60);
    }];
    
    [self setupAvatarImageView];
    [self setupDetailsAuthorName];
    [self setupDetailsHeader];
    [self setupDetailsDescription];
    [self setupDetailsClaimButton];
    [self setupDetailsInviteButton];
    [self setupDetailsAddress];
    [self setupDetailsMembers];
    [self setupEditButton];
    [self setupDeleteButton];
}

- (void)setupAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.backgroundColor = [UIColor whiteColor];
    avatarImageView.layer.cornerRadius = 32;
    avatarImageView.layer.masksToBounds = YES;

    [self.detailsView addSubview:avatarImageView];

    self.avatarImageView = avatarImageView;

    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsView.mas_top).with.offset(16);
        make.size.equalTo(@64);
        make.left.equalTo(self.detailsView).with.offset(16);
    }];
}

- (void)setupDetailsAuthorName
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor cl_lightPurpleColor];
    nameLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
    nameLabel.text = @"Дмитрий Жаров";
    
    [self.detailsView addSubview:nameLabel];
    
    self.nameLabel = nameLabel;
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView).with.offset(8);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(12);
    }];
}

- (void)setupDetailsHeader
{
    UILabel *ratingLabel = [[UILabel alloc] init];
    ratingLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    ratingLabel.textColor = [UIColor lightGrayColor];
    
    [self.detailsView addSubview:ratingLabel];
    
    //self.dateLabel = dateLabel;
    
    [ratingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(12);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.bottom.equalTo(self.avatarImageView).with.offset(-8);
    }];
}

- (void)setupDetailsDate
{
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    
    [self.detailsView addSubview:dateLabel];
    
    self.dateLabel = dateLabel;
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.detailsView.mas_right).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.bottom.equalTo(self.avatarImageView).with.offset(-8);
    }];
}

- (void)setupDetailsDescription
{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@1);
    }];
    
    UILabel *descriptionHeading = [[UILabel alloc] init];
    descriptionHeading.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    descriptionHeading.text = @"Описание";
    
    [self.detailsView addSubview:descriptionHeading];
    
    self.descriptionHeading = descriptionHeading;
    
    [self.descriptionHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).with.offset(12);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    descriptionLabel.numberOfLines = 0;
    
    [self.detailsView addSubview:descriptionLabel];
    
    self.descriptionLabel = descriptionLabel;
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionHeading.mas_bottom).with.offset(8);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupDetailsClaimButton
{
    UIButton *claimButton = [[UIButton alloc] init];
    claimButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    claimButton.layer.cornerRadius = 14;
    claimButton.layer.masksToBounds = YES;
    
    claimButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [claimButton setTitle:@"Где проходит?" forState:UIControlStateNormal];
    [claimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [claimButton addTarget:self action:@selector(actionClaimButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:claimButton];
    
    self.claimButton = claimButton;
    
    [self.claimButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.height.equalTo(@48);
    }];
}

- (void)setupDetailsInviteButton
{
    UIButton *inviteButton = [[UIButton alloc] init];
    inviteButton.backgroundColor = [UIColor whiteColor];
    inviteButton.layer.borderColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0].CGColor;
    inviteButton.layer.borderWidth = 2.0f;
    inviteButton.layer.cornerRadius = 14;
    inviteButton.layer.masksToBounds = YES;
    
    inviteButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [inviteButton setTitle:@"Позвать друга" forState:UIControlStateNormal];
    [inviteButton setTitleColor:[UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0] forState:UIControlStateNormal];
    //[inviteButton addTarget:self action:@selector(actionInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:inviteButton];
    
    self.inviteButton = inviteButton;
    
    [self.inviteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.claimButton);
        make.left.equalTo(self.claimButton.mas_right).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.width.equalTo(self.claimButton);
    }];
}

- (void)setupDetailsAddress
{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.claimButton.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@1);
    }];
    
    UILabel *addressHeading = [[UILabel alloc] init];
    addressHeading.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    addressHeading.text = @"Место проведения";
    
    [self.detailsView addSubview:addressHeading];
    
    self.addressHeading = addressHeading;
    
    [self.addressHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    [self.detailsView addSubview:addressLabel];
    
    self.addressLabel = addressLabel;
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressHeading.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UILabel *apartmentLabel = [[UILabel alloc] init];
    apartmentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    [self.detailsView addSubview:apartmentLabel];
    
    self.apartmentLabel = apartmentLabel;
    
    [self.apartmentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupDetailsMembers
{
    UILabel *membersHeading = [[UILabel alloc] init];
    membersHeading.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
    membersHeading.text = @"Ожидается людей";
    
    [self.detailsView addSubview:membersHeading];
    
    self.membersHeading = membersHeading;
    
    [self.membersHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.apartmentLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.membersHeading.mas_bottom).with.offset(6);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@1);
    }];
    
    UILabel *membersLabel = [[UILabel alloc] init];
    membersLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    [self.detailsView addSubview:membersLabel];
    
    self.membersLabel = membersLabel;
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.membersHeading.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}


- (void)setupEditButton
{
    UIButton *editButton = [[UIButton alloc] init];
    editButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    editButton.layer.cornerRadius = 14;
    editButton.layer.masksToBounds = YES;
    
    editButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [editButton setTitle:@"Редактировать" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[claimButton addTarget:self action:@selector(actionClaimButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:editButton];
    
    self.editButton = editButton;
    
    [self.editButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.membersLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@48);
    }];
}

- (void)setupDeleteButton
{
    UIButton *deleteButton = [[UIButton alloc] init];
    deleteButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    deleteButton.layer.cornerRadius = 14;
    deleteButton.layer.masksToBounds = YES;
    
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [deleteButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTintColor:[UIColor whiteColor]];
    [deleteButton addTarget:self action:@selector(actionDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:deleteButton];
    
    self.deleteButton = deleteButton;
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editButton.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@48);
        make.bottom.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupCloseButton
{
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"Close Glyph"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(actionDismissViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
    
    self.closeButton = closeButton;
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-16);
        make.size.equalTo(@28);
    }];
}

#pragma mark - Custom Accessors

- (void)setContentWithParty:(PartyMO *)party
{
    self.party = party;
    
    if (party.photoURL)
    {
         [UIImage ch_imageWithContentsOfURL:party.photoURL completion:^(UIImage *image) {
             self.avatarImageView.image = image;
         }];
    }
    else
    {
        self.avatarImageView.image = [UIImage imageNamed:@"Purple Avatar"];
    }
    
    self.navigationItem.title = party.title;
    self.navigationLabel.text = party.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = kCFDateFormatterShortStyle;
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:party.date];
    
    self.descriptionLabel.text = party.desc;
    
    self.addressLabel.text = party.address;
    
    self.apartmentLabel.text = party.apartment;
    
    self.membersLabel.text = [NSString stringWithFormat:@"%d", party.members];
}

#pragma mark - Actions

- (void)actionDismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        //[self.delegate dismiss];
    }];
}

- (void)actionClaimButton:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)sender;
    }
    
    [self.networkService sendClaimForParty:self.party];
}

- (void)actionDeleteButton:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)sender;
    }
    
    [self.networkService deleteParty:self.party];
    
    [self actionDismissViewController];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    
//    // Прячем заголовок тусовки
//    CGFloat navigationBarMinY = CGRectGetMinY(self.navigationLabel.frame) - CGRectGetMinY(self.navigationBar.frame);
//    if (currentOffset >= navigationBarMinY)
//    {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.navigationLabel.alpha = 0;
//        }];
//    }
//    else
//    {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.navigationLabel.alpha = 1;
//        }];
//    }
    
    // Покаказываем навигационную панель
    CGFloat navigationBarMaxY = CGRectGetMaxY(self.headerView.frame) - CGRectGetMaxY(self.navigationBackground.frame);
    if (currentOffset >= navigationBarMaxY)
    {
        self.statusBarLight = NO;
        [UIView animateWithDuration:0.05 animations:^{
            self.navigationBar.alpha = 1;
            self.navigationBackground.alpha = 1;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    else
    {
        self.statusBarLight = YES;
        [UIView animateWithDuration:0.05 animations:^{
            self.navigationBar.alpha = 0;
            self.navigationBackground.alpha = 0;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

@end
