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

@property (nonatomic, getter=isFlipped, assign) BOOL flipped;

//

@property (nonatomic, strong) UIView *frontCardView;
@property (nonatomic, strong) CAGradientLayer *frontCardLayer;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *apartmentLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *capacityLabel;
@property (nonatomic, strong) UILabel *membersLabel;

//

@property (nonatomic, strong) UIView *backCardView;
@property (nonatomic, strong) CAGradientLayer *backCardLayer;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

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
        _flipped = NO;
        
        // Подложка с фиолетовым слоем
        _frontCardView = [[UIView alloc] init];
        _frontCardView.layer.cornerRadius = 10;
        _frontCardView.layer.masksToBounds = YES;
        _frontCardView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_frontCardView];

        _frontCardLayer = [CAGradientLayer purpleGradientLayer];
        [_frontCardView.layer addSublayer:_frontCardLayer];

        // Заголовок
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_titleLabel];
        
        // Дата и время старта
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_dateLabel];
        
        // Место проведения
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _addressLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_addressLabel];
        
        // Квартира
        _apartmentLabel = [[UILabel alloc] init];
        _apartmentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _apartmentLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_apartmentLabel];
        
        // Аватарка пользователя
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]]; // UIImage ImageNamed
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height /2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        [_frontCardView addSubview:_avatarImageView];
        
        // Имя пользователя
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _authorLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_authorLabel];
        
        _membersLabel = [[UILabel alloc] init];
        _membersLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _membersLabel.textColor = [UIColor whiteColor];
        [_frontCardView addSubview:_membersLabel];
        
        _capacityLabel = [[UILabel alloc] init];
        _capacityLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _capacityLabel.textColor = [UIColor whiteColor];
        _capacityLabel.text = @"мест";
        [_frontCardView addSubview:_capacityLabel];
        
        _backCardView = [[UIView alloc] init];
        _backCardView.layer.cornerRadius = 10;
        _backCardView.layer.masksToBounds = YES;
        _backCardView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:_backCardView belowSubview:_frontCardView];
        
        _backCardLayer = [CAGradientLayer purpleGradientLayer];
        [_backCardView.layer addSublayer:_backCardLayer];
        
        // "Сообщение"
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.text = @"Сообщение";
        [_backCardView addSubview:_messageLabel];
        
        // Содержимое сообщения
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.numberOfLines = 5;
        [_backCardView addSubview:_descriptionLabel];
        
        [self setupGestureRecognizers];
    }
    return self;
}

- (UIView *)cardView
{
    return self.frontCardView;
}

- (void)updateConstraints
{
    UIEdgeInsets cardViewsInsets = UIEdgeInsetsMake(16, 16, 0, 16);
    
    [self.frontCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(cardViewsInsets);
    }];
    
    UIEdgeInsets offsets = UIEdgeInsetsMake(16, 16, -16, -16);
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frontCardView.mas_top).with.offset(offsets.top);
        make.left.equalTo(self.frontCardView.mas_left).with.offset(offsets.left);
    }];
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.frontCardView.mas_left).with.offset(offsets.left);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.frontCardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.apartmentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.dateLabel.mas_lastBaseline);
        make.right.equalTo(self.frontCardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.frontCardView.mas_left).with.offset(offsets.left);
        make.bottom.equalTo(self.frontCardView.mas_bottom).with.offset(offsets.bottom);
        make.size.equalTo(@24);
    }];
    
    [self.authorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.mas_bottom);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(8);
    }];
    
    [self.capacityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.authorLabel);
        make.right.equalTo(self.frontCardView.mas_right).with.offset(offsets.right);
    }];
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.lastBaseline.equalTo(self.capacityLabel);
        make.right.equalTo(self.capacityLabel.mas_left).with.offset(-4);
    }];
    
    [self.backCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(cardViewsInsets);
    }];
    
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backCardView.mas_top).with.offset(offsets.top);
        make.left.equalTo(self.backCardView.mas_left).with.offset(offsets.left);
    }];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.backCardView.mas_left).with.offset(offsets.left);
        make.right.equalTo(self.backCardView.mas_right).with.offset(offsets.right);
    }];
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frontCardLayer.frame = self.backCardLayer.frame = self.contentView.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.flipped = NO;
    [self.contentView insertSubview:self.frontCardView aboveSubview:self.backCardView];
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
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
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
    
    self.descriptionLabel.text = party.desc;
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
    
    UISwipeGestureRecognizer *flipGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cardFlipped:)];
    flipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    flipGestureRecognizer.cancelsTouchesInView = YES;
    flipGestureRecognizer.delegate = self;
    [self addGestureRecognizer:flipGestureRecognizer];
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

- (void)cardFlipped:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [UIView transitionWithView:self.contentView
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
            if (!self.flipped)
            {
                [self.contentView insertSubview:self.backCardView aboveSubview:self.frontCardView];
            }
            else
            {
                [self.contentView insertSubview:self.frontCardView aboveSubview:self.backCardView];
            }
        } completion:^(BOOL finished) {
            if (finished)
            {
                self.flipped = !self.flipped;
            }
        }];
    }
}

@end
