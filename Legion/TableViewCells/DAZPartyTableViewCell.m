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

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) CAGradientLayer *purpleLayer;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *apartmentLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *capacityLabel;
@property (nonatomic, strong) UILabel *membersLabel;

@end

@implementation DAZPartyTableViewCell

+ (CGFloat)height
{
    return 196;
}

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
        // Подложка с фиолетовым слоем
        _cardView = [[UIView alloc] init];
        _cardView.layer.cornerRadius = 10;
        _cardView.layer.masksToBounds = YES;
        [self.contentView addSubview:_cardView];
        
        _purpleLayer = [CAGradientLayer purpleGradientLayer];
        [_cardView.layer insertSublayer:_purpleLayer atIndex:0];
        
        // Заголовок
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_titleLabel];
        
        // Дата и время старта
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_dateLabel];
        
        // Место проведения
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _addressLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_addressLabel];
        
        // Квартира
        _apartmentLabel = [[UILabel alloc] init];
        _apartmentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _apartmentLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_apartmentLabel];
        
        // Аватарка пользователя
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]]; // UIImage ImageNamed
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height /2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        [_cardView addSubview:_avatarImageView];
        
        // Имя пользователя
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _authorLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_authorLabel];
        
        _membersLabel = [[UILabel alloc] init];
        _membersLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _membersLabel.textColor = [UIColor whiteColor];
        [_cardView addSubview:_membersLabel];

        
        _capacityLabel = [[UILabel alloc] init];
        _capacityLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _capacityLabel.textColor = [UIColor whiteColor];
        _capacityLabel.text = @"мест";
        [_cardView addSubview:_capacityLabel];
        
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)updateConstraints
{
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(16, 16, 0, 16));
    }];
    
    UIEdgeInsets offsets = UIEdgeInsetsMake(16, 16, -16, -16);
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_top).with.offset(offsets.top);
        make.left.equalTo(self.cardView.mas_left).with.offset(offsets.left);
    }];
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.cardView.mas_left).with.offset(offsets.left);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.cardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.apartmentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.dateLabel.mas_lastBaseline);
        make.right.equalTo(self.cardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView.mas_left).with.offset(offsets.left);
        make.bottom.equalTo(self.cardView.mas_bottom).with.offset(offsets.bottom);
        make.size.equalTo(@24);
    }];
    
    [self.authorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.mas_bottom);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(8);
    }];
    
    [self.capacityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.authorLabel);
        make.right.equalTo(self.cardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.capacityLabel);
        make.right.equalTo(self.capacityLabel.mas_left).with.offset(-4);
    }];
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.purpleLayer.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    
    // Top-left
    self.titleLabel.text = party.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:party.date];
    
    // Top-right
    self.addressLabel.text = party.address;
    
    if (party.apartment)
    {
        self.apartmentLabel.text = party.apartment;
    }
    
    // Bottom-left
    // In future release
    //self.avatarImageView;
    self.authorLabel.text = party.author;
    
    // Bottom-right
    self.membersLabel.text = [NSString stringWithFormat:@"%d", party.members];
}

#pragma mark - UIGestureRecognizer

// Необходим для анимации в стиле AppStore на iOS 11
- (void)setupGestureRecognizers
{
    UILongPressGestureRecognizer *gestureRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cardPressed:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    gestureRecognizer.minimumPressDuration = 0.1;
    [self addGestureRecognizer:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)cardPressed:(UILongPressGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                            } completion:nil];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.contentView.transform = CGAffineTransformIdentity;
                            } completion:nil];
    }
}


@end
