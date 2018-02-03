//
//  DAZPartyTableViewCell.m
//  Legion
//
//  Created by Дмитрий Жаров on 02.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "DAZPartyTableViewCell.h"
#import "PartyMO+CoreDataClass.h"

#import "CAGradientLayer+Gradients.h"


@interface DAZPartyTableViewCell ()

@property (nonatomic, strong) PartyMO *party;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *createdLabel;
@property (nonatomic, strong) UILabel *membersLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UILabel *dateTitleLabel;

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) CAGradientLayer *purpleLayer;

@end

@implementation DAZPartyTableViewCell

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Card View
        _cardView = [[UIView alloc] init];
        //_cardView.backgroundColor = [UIColor blackColor];
        _cardView.layer.cornerRadius = 10;
        _cardView.layer.masksToBounds = YES;
        [self.contentView addSubview:_cardView];
        _purpleLayer = [CAGradientLayer purpleGradientLayer];
        [_cardView.layer insertSublayer:_purpleLayer atIndex:0];
        
        // Avater Image View
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]]; // UIImage ImageNamed
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height /2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        [_cardView addSubview:_avatarImageView];
        
        // Author Name
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _authorLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_authorLabel];
        
        //
        _createdLabel = [[UILabel alloc] init];
        _createdLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _createdLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_createdLabel];
        
        _membersLabel = [[UILabel alloc] init];
        _membersLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _membersLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_membersLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_titleLabel];
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_descriptionLabel];
        
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.text = @"МЕСТО";
        _addressTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _addressTitleLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_addressTitleLabel];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _addressLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_addressLabel];
        
        _dateTitleLabel = [[UILabel alloc] init];
        _dateTitleLabel.text = @"ДАТА";
        _dateTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _dateTitleLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_dateTitleLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_dateLabel];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cardPressed:)];
        recognizer.delegate = self;
        recognizer.minimumPressDuration = 0.0;
        [self.contentView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, -20, -20);
    
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.top.and.right.equalTo(self.contentView);
//        make.height.equalTo(@400);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(16, 16, 0, 16));
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_top).with.offset(insets.top);
        make.leading.equalTo(self.cardView.mas_leading).with.offset(insets.left);
        make.size.equalTo(@40);
    }];
    
    [self.authorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_top).with.offset(0);
        make.leading.equalTo(self.avatarImageView.mas_trailing).with.offset(8);
    }];
    
    [self.createdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarImageView.mas_trailing).with.offset(8);
        make.bottom.equalTo(self.avatarImageView.mas_bottom).with.offset(0);
    }];
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView.mas_centerY).with.offset(0);
        make.trailing.equalTo(self.cardView.mas_trailing).with.offset(insets.right);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(24);
        make.leading.equalTo(self.cardView.mas_leading).with.offset(insets.left);
    }];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.cardView.mas_leading).with.offset(insets.left);
        make.trailing.equalTo(self.cardView.mas_trailing).with.offset(insets.right);
    }];
    
    [self.addressTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.cardView.mas_leading).with.offset(insets.left);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.cardView.mas_leading).with.offset(insets.left);
        make.bottom.equalTo(self.cardView.mas_bottom).with.offset(insets.bottom);
    }];
    
    [self.dateTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_top);
        make.trailing.equalTo(self.cardView.mas_trailing).with.offset(insets.right);
    }];
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateTitleLabel.mas_bottom).with.offset(10);
        make.trailing.equalTo(self.cardView.mas_trailing).with.offset(insets.right);
        make.bottom.equalTo(self.cardView.mas_bottom).with.offset(insets.bottom);
    }];
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.purpleLayer.frame = self.contentView.bounds;
}

#pragma mark - Accessors

- (void)setWithParty:(PartyMO *)party
{
    if (!party)
    {
        return;
    }
    
    self.party = party;
    
    // For future release
    //self.avatarImageView;
    
    // Header
    self.authorLabel.text = party.author;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.createdLabel.text = [dateFormatter stringFromDate:party.created];
    self.membersLabel.text = [NSString stringWithFormat:@"Ожидается людей: %d", party.members];
    
    // Body
    self.titleLabel.text = party.title;
    self.descriptionLabel.text = party.desc;
    
    // Footer
    self.addressLabel.text = party.address;
    self.dateLabel.text = [dateFormatter stringFromDate:party.date];
}

- (void)cardPressed:(UILongPressGestureRecognizer*)sender {
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:nil];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
