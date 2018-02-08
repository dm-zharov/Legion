//
//  DAZPartyDetailsViewControllers.m
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZPartyDetailsViewControllers.h"
#import "CAGradientLayer+Gradients.h"
#import "UIImage+Overlay.h"
#import "UIColor+Colors.h"

#import <Masonry.h>

@interface DAZPartyDetailsViewControllers ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UILabel *navigationLabel;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UIButton *closeButton;

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *detailsView;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) UIButton *claimButton;
@property (nonatomic, weak) UIButton *inviteButton;

@property (nonatomic, weak) UILabel *descriptionHeading;
@property (nonatomic, weak) UILabel *descriptionLabel;

@property (nonatomic, weak) UILabel *addressHeading;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *apartmentLabel;

@property (nonatomic, weak) UILabel *membersHeading;
@property (nonatomic, weak) UILabel *membersLabel;

- (void)setContentWithParty:(PartyMO *)party;

@end

@implementation DAZPartyDetailsViewControllers

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *purpleLayer = [CAGradientLayer purpleGradientLayer];
    purpleLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:purpleLayer];
    
    [self setupScrollView];
    [self setupCloseButton];
    
    [self setContentWithParty:self.party];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
}

#pragma mark - Setup UI

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
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
    
    [self setupNavigationLabel];
    [self setupAvatarImageView];
    [self setupImageView];
    [self setupDetailsView];
    
}

- (void)setupNavigationLabel
{
    
    UILabel *navigationLabel = [[UILabel alloc] init];
    navigationLabel.textColor = [UIColor whiteColor];
    navigationLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    navigationLabel.text = @"Подробности";
    
    [self.contentView addSubview:navigationLabel];
    
    self.navigationLabel = navigationLabel;
    
    [self.navigationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(64);
        make.left.equalTo(self.contentView).with.offset(16);
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
}

- (void)setupAvatarImageView
{
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:avatarImageView];
    
    self.avatarImageView = avatarImageView;
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@36);
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.bottom.equalTo(self.navigationLabel.mas_lastBaseline);
    }];
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:imageView];
    
    self.imageView = imageView;
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.contentView).with.offset(16);
        make.right.equalTo(self.contentView).with.offset(-16);
        make.height.equalTo(@180);
    }];
    
}

#pragma mark - Content UI

- (void)setupDetailsView
{
    UIView *detailsView = [[UIView alloc] init];
    detailsView.backgroundColor = [UIColor whiteColor];
    detailsView.layer.cornerRadius = 10;
    detailsView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:detailsView];
    
    self.detailsView = detailsView;
    
    if (self.imageView)
    {
        [self.detailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).with.offset(16);
            make.left.equalTo(self.contentView).with.offset(16);
            make.right.equalTo(self.contentView).with.offset(-16);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16);
        }];
    }
    else
    {
        [self.detailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationLabel.mas_bottom).with.offset(16);
            make.left.equalTo(self.contentView).with.offset(16);
            make.right.equalTo(self.contentView).with.offset(-16);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16);
        }];
    }
    
    [self setupDetailsHeader];
    [self setupDetailsClaimButton];
    [self setupDetailsInviteButton];
    [self setupDetailsDescription];
    [self setupDetailsAddress];
    [self setupDetailsMembers];
}

- (void)setupDetailsHeader
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:27 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor cl_darkPurpleColor];
    
    [self.detailsView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsView).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    
    [self.detailsView addSubview:dateLabel];
    
    self.dateLabel = dateLabel;
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupDetailsClaimButton
{
    UIButton *claimButton = [[UIButton alloc] init];
    claimButton.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    claimButton.layer.cornerRadius = 10;
    claimButton.layer.masksToBounds = YES;
    
    claimButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [claimButton setTitle:@"Хочу пойти!" forState:UIControlStateNormal];
    [claimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[claimButton addTarget:self action:@selector(actionClaimButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:claimButton];
    
    self.claimButton = claimButton;
    
    [self.claimButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(16);
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
    inviteButton.layer.cornerRadius = 10;
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

- (void)setupDetailsDescription
{
    UILabel *descriptionHeading = [[UILabel alloc] init];
    descriptionHeading.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    descriptionHeading.text = @"Описание";
    
    [self.detailsView addSubview:descriptionHeading];
    
    self.descriptionHeading = descriptionHeading;
    
    [self.descriptionHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.claimButton.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionHeading.mas_bottom).with.offset(6);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@1);
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    descriptionLabel.numberOfLines = 0;
    
    [self.detailsView addSubview:descriptionLabel];
    
    self.descriptionLabel = descriptionLabel;
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionHeading.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupDetailsAddress
{
    UILabel *addressHeading = [[UILabel alloc] init];
    addressHeading.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    addressHeading.text = @"Место проведения";
    
    [self.detailsView addSubview:addressHeading];
    
    self.addressHeading = addressHeading;
    
    [self.addressHeading mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:115/225.0 green:108/255.0 blue:171/255.0 alpha:1.0];
    
    [self.detailsView addSubview:separator];
    
    [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressHeading.mas_bottom).with.offset(6);
        make.left.equalTo(self.detailsView).with.offset(16);
        make.right.equalTo(self.detailsView).with.offset(-16);
        make.height.equalTo(@1);
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
    membersHeading.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
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
        make.bottom.equalTo(self.detailsView).with.offset(-16);
    }];
}

- (void)setupCloseButton
{
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"Close Glyph"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(actionCloseViewController) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.imageView.image = [[UIImage imageNamed:@"party-placeholder"] tinted];
    //self.imageView.image = [UIImage tintedImageFrom:[UIImage imageNamed:@"party-placeholder"] withColor:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:123/255.0 alpha:0.7]];
    
    self.titleLabel.text = party.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    self.dateLabel.text = [dateFormatter stringFromDate:party.date];
    
    self.descriptionLabel.text = party.desc;
    
    self.addressLabel.text = party.address;
    
    self.apartmentLabel.text = party.apartment;
    
    self.membersLabel.text = [NSString stringWithFormat:@"%d", party.members];
}

#pragma mark - Actions

- (void)actionCloseViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate dismiss];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
