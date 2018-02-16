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

#import "DAZActivityButton.h"

#import "CAGradientLayer+Gradients.h"
#import "UIImage+Cache.h"
#import "UIImage+Overlay.h"
#import "UIColor+Colors.h"
#import "UINavigationBar+Shadow.h"
#import "UIViewController+Alerts.h"

#import "PartyMO+CoreDataClass.h"

@interface DAZPartyDetailsViewControllers () <DAZProxyServiceDelegate, UINavigationBarDelegate, UIScrollViewDelegate>

@property (nonatomic, getter=isStatusBarLight, assign) BOOL statusBarLight;
@property (nonatomic, getter=isOwner, assign) BOOL owner;

@property (nonatomic, strong) DAZProxyService *networkService;
@property (nonatomic, strong) PartyMO *party;

@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UIView *navigationBackground;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *detailsView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) DAZActivityButton *claimButton;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *apartmentLabel;
@property (nonatomic, weak) UILabel *membersLabel;

@property (nonatomic, weak) UIButton *editButton;
@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, weak) UIButton *closeButton;

@end

@implementation DAZPartyDetailsViewControllers


#pragma mark - Lifecycle

- (instancetype)initWithParty:(PartyMO *)party
{
    self = [super init];
    if (self) {
        _party = party;
        _owner = party.ownership;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNetworkService];
    
    [self setupBackgroundLayer];
    [self setupScrollView];
    
    [self setupNavigationBar];
    [self setupCloseButton];
    
    
    [self setContentWithParty:self.party];
    
    self.statusBarLight = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.contentView.bounds);
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.statusBarLight = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
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

- (void)setupBackgroundLayer
{
    CAGradientLayer *purpleLayer = [CAGradientLayer gr_purpleGradientLayer];
    purpleLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:purpleLayer];
}


#pragma mark - UIScrollView

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    
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
    
    [self.scrollView addSubview:contentView];
    
    self.contentView = contentView;
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self setupHeaderView];
    [self setupDetailsView];
    
}


#pragma mark Content Header View

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    
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
    
    [self.headerView addSubview:navigationLabel];
    
    self.titleLabel = navigationLabel;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).with.offset(64);
        make.left.equalTo(self.headerView).with.offset(16);
        make.right.equalTo(self.headerView).with.offset(-16);
    }];
}


#pragma mark Content Details View

- (void)setupDetailsView
{
    UIView *detailsView = [[UIView alloc] init];
    detailsView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView insertSubview:detailsView belowSubview:self.headerView];
    
    self.detailsView = detailsView;

    [self.detailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-60);
    }];
    
    [self setupAvatarImageView];
    [self setupNameSection];
    [self setupDateSection];
    [self setupDescriptionSection];
    [self setupClaimButton];
    [self setupShareButton];
    [self setupAddressSection];
    [self setupMembersSection];
    //[self setupEditButton];
    [self setupDeleteButton];
}

- (void)setupAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple Avatar"]];
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

- (void)setupNameSection
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
    
    [self.detailsView addSubview:nameLabel];
    
    self.nameLabel = nameLabel;
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView).with.offset(8);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(12);
    }];
    
    UILabel *organizerLabel = [[UILabel alloc] init];
    organizerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    organizerLabel.textColor = [UIColor lightGrayColor];
    organizerLabel.text = @"Организатор";
    
    [self.detailsView addSubview:organizerLabel];
    
    [organizerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(12);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.bottom.equalTo(self.avatarImageView).with.offset(-8);
    }];
}

- (void)setupDateSection
{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [[UIColor cl_lightPurpleColor] colorWithAlphaComponent:0.7];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *dateTitle = [[UILabel alloc] init];
    dateTitle.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    dateTitle.textColor = [UIColor cl_darkPurpleColor];
    dateTitle.text = @"Планируется";
    
    [self.detailsView addSubview:dateTitle];
    
    [dateTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self.detailsView addSubview:dateLabel];
    
    self.dateLabel = dateLabel;
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateTitle.mas_right).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.centerY.equalTo(dateTitle.mas_centerY);
    }];
}

- (void)setupDescriptionSection
{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [[UIColor cl_lightPurpleColor] colorWithAlphaComponent:0.7];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *descriptionHeading = [[UILabel alloc] init];
    descriptionHeading.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    descriptionHeading.textColor = [UIColor cl_darkPurpleColor];
    descriptionHeading.text = @"Описание";
    
    [self.detailsView addSubview:descriptionHeading];
    
    [descriptionHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    descriptionLabel.numberOfLines = 0;
    
    [self.detailsView addSubview:descriptionLabel];
    
    self.descriptionLabel = descriptionLabel;
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionHeading.mas_bottom).with.offset(8);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupClaimButton
{
    if ([self isOwner])
    {
        return;
    }
    
    DAZActivityButton *claimButton = [[DAZActivityButton alloc] init];
    claimButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    claimButton.layer.cornerRadius = 14;
    claimButton.layer.masksToBounds = YES;
    
    claimButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [claimButton setTitle:@"Узнать квартиру" forState:UIControlStateNormal];
    [claimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [claimButton setTitle:@"Отправлено" forState:UIControlStateDisabled];
    [claimButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateDisabled];
    [claimButton addTarget:self action:@selector(actionSendClalim:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:claimButton];
    
    self.claimButton = claimButton;
    
    [self.claimButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.height.equalTo(@48);
    }];
}

- (void)setupShareButton
{
    UIButton *shareButton = [[UIButton alloc] init];
    shareButton.backgroundColor = [UIColor whiteColor];
    shareButton.layer.borderColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0].CGColor;
    shareButton.layer.borderWidth = 2.0f;
    shareButton.layer.cornerRadius = 14;
    shareButton.layer.masksToBounds = YES;
    
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [shareButton setTitle:@"Позвать друга" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(actionShareParty:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:shareButton];
    
    self.shareButton = shareButton;
    
    if ([self isOwner])
    {
        [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(16);
            make.left.equalTo(self.detailsView).with.offset(16);
            make.right.equalTo(self.detailsView).with.offset(-16);
            make.height.equalTo(@48);
        }];
    }
    else
    {
        [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.claimButton);
            make.left.equalTo(self.claimButton.mas_right).with.offset(16);
            make.right.equalTo(self.detailsView).with.offset(-16);
            make.width.equalTo(self.claimButton);
        }];
    }
}

- (void)setupAddressSection
{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *addressHeading = [[UILabel alloc] init];
    addressHeading.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    addressHeading.textColor = [UIColor cl_darkPurpleColor];
    addressHeading.text = @"Место проведения";
    
    [self.detailsView addSubview:addressHeading];
    
    [addressHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    [self.detailsView addSubview:addressLabel];
    
    self.addressLabel = addressLabel;
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressHeading.mas_bottom).with.offset(16);
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

- (void)setupMembersSection
{
    UILabel *membersHeading = [[UILabel alloc] init];
    membersHeading.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    membersHeading.textColor = [UIColor cl_darkPurpleColor];
    membersHeading.text = @"Ожидается людей";
    
    [self.detailsView addSubview:membersHeading];
    
    [membersHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.apartmentLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(membersHeading.mas_bottom).with.offset(6);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *membersLabel = [[UILabel alloc] init];
    membersLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    
    [self.detailsView addSubview:membersLabel];
    
    self.membersLabel = membersLabel;
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(membersHeading.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    if (![self isOwner])
    {
        [self.membersLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.detailsView).with.offset(-16);
        }];
    }
}

//- (void)setupEditButton
//{
//    UIButton *editButton = [[UIButton alloc] init];
//    editButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
//    editButton.layer.cornerRadius = 14;
//    editButton.layer.masksToBounds = YES;
//
//    editButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//    [editButton setTitle:@"Редактировать" forState:UIControlStateNormal];
//    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[claimButton addTarget:self action:@selector(actionSendClalim:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.detailsView addSubview:editButton];
//
//    self.editButton = editButton;
//
//    [self.editButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.membersLabel.mas_bottom).with.offset(16);
//        make.left.equalTo(self.detailsView).with.offset(16);
//        make.right.equalTo(self.detailsView).with.offset(-16);
//        make.height.equalTo(@48);
//    }];
//}

- (void)setupDeleteButton
{
    if (![self isOwner])
    {
        return;
    }
    
    UIButton *deleteButton = [[UIButton alloc] init];
    deleteButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    deleteButton.layer.cornerRadius = 14;
    deleteButton.layer.masksToBounds = YES;
    
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [deleteButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTintColor:[UIColor whiteColor]];
    [deleteButton addTarget:self action:@selector(actionDeleteParty:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:deleteButton];
    
    self.deleteButton = deleteButton;
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.membersLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@48);
        make.bottom.equalTo(self.detailsView).with.offset(-16);
    }];
}


#pragma mark - UINavigationBar

- (void)setupNavigationBar
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.items = @[self.navigationItem];
    navigationBar.delegate = self;
    navigationBar.alpha = 0;
    
    /* Устанавливаем полную прозрачность навигационному бару
     */
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = YES;
    self.navigationItem.hidesBackButton = YES;
    
    [self.view addSubview:navigationBar];
    
    self.navigationBar = navigationBar;
    
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    // Добавляем к навигиционному бару подложку, цвет которой мы будем изменять
    
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


#pragma - UIButton

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
    
    if (party.title)
    {
        self.navigationItem.title = party.title;
        self.titleLabel.text = party.title;
    }
    
    if (party.date)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        self.dateLabel.text = [dateFormatter stringFromDate:party.date];
    }
    
    self.nameLabel.text = party.authorName ? party.authorName : nil;
    self.descriptionLabel.text = party.desc ? party.desc : nil;
    self.addressLabel.text = party.address ? party.address : nil;
    self.apartmentLabel.text = party.apartment ? party.apartment : nil;
    self.membersLabel.text = [NSString stringWithFormat:@"%d", party.members];
    
    if (![party.apartment isEqualToString:@"Скрыто"])
    {
        self.claimButton.enabled = NO;
        [self.claimButton setTitle:@"Адрес получен" forState:UIControlStateDisabled];
    }
}


#pragma mark - Actions

- (void)actionDismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSendClalim:(id)sender
{
    if ([sender isKindOfClass:[DAZActivityButton class]])
    {
        DAZActivityButton *button = (DAZActivityButton *)sender;
        [button startSpinning];

        [self.networkService sendClaimForParty:self.party];
        //[self actionDismissViewController];
    }
}

- (void)actionShareParty:(id)sender
{
    NSString *authorName = self.party.authorName;
    NSString *partyTitle = self.party.title;
    
    NSString *sharedString = [NSString stringWithFormat:@"Приглашаю тебя посмотреть тусовку \"%@\", которую организовал %@", partyTitle, authorName];
    
    NSArray *sharedObjects = @[sharedString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
        initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)actionDeleteParty:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        [self actionDismissViewController];
        [self.networkService deleteParty:self.party];
    }
}


#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    
    // Прячем и отображаем навигационную панель
    CGFloat navigationBarMaxY = CGRectGetMaxY(self.headerView.frame) - CGRectGetMaxY(self.navigationBar.frame);
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


#pragma mark - DAZProxyServiceDelegate

- (void)proxyServiceDidFinishSendClaimWithNetworkStatus:(DAZNetworkStatus)status
{
    [self.claimButton stopSpinning];
    self.claimButton.enabled = NO;
    
    if (status == DAZNetworkOffline)
    {
        [self al_presentOfflineModeAlertViewController];
        [self.claimButton setTitle:@"Ошибка" forState:UIControlStateDisabled];
    }
}

- (void)proxyServiceDidFinishDeletePartyWithNetworkStatus:(DAZNetworkStatus)status
{
    [self actionDismissViewController];
    
    if ([self.delegate respondsToSelector:@selector(proxyServiceDidFinishDeletePartyWithNetworkStatus:)])
    {
        [self.delegate proxyServiceDidFinishDeletePartyWithNetworkStatus:status];
    }
}

@end
