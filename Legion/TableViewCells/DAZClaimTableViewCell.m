//
//  DAZClaimTableViewCell.m
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "DAZClaimTableViewCell.h"
#import "ClaimMO+CoreDataClass.h"

#import "UIImageView+Cache.h"

@interface DAZClaimTableViewCell ()

@property (nonatomic, strong) ClaimMO *claim;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DAZClaimTableViewCell

+ (CGFloat)height
{
    return 80;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]]; // UIImage ImageNamed
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height /2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _messageLabel.numberOfLines = 3;
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}

- (void)updateConstraints
{
    UIEdgeInsets offsets = UIEdgeInsetsMake(16, 16, 16, -16);
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.contentView).with.insets(offsets);
        make.size.equalTo(@48);
    }];
    
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_top);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(16);
        make.right.equalTo(self.contentView).with.offset(offsets.right);
    }];
    
    [super updateConstraints];
}

- (void)setWithClaim:(ClaimMO *)claim isIncome:(BOOL)income;
{
    self.claim = claim;
    
    if (claim.photoURL)
    {
        [self.avatarImageView ch_imageWithContentsOfURL:claim.photoURL];
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 24;
        self.avatarImageView.layer.masksToBounds = YES;
    }
    else
    {
        self.avatarImageView.image = [UIImage imageNamed:@"Placeholder"];
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 24;
        self.avatarImageView.layer.masksToBounds = YES;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *date = [dateFormatter stringFromDate:claim.date];
    
    if (income)
    {
        self.messageLabel.text = [NSString stringWithFormat:@"%@ отправил вам запрос на посещение тусовки %@ %@", claim.authorName, claim.partyID, date];
    }
    else
    {
        self.messageLabel.text = [NSString stringWithFormat:@"Вы запросили у %@ место проведения тусовки %@ %@", claim.authorName, claim.partyID, date];
    }
}

@end
