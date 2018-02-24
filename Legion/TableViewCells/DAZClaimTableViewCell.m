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
#import "UIColor+Colors.h"


@interface DAZClaimTableViewCell ()

@property (nonatomic, strong) ClaimMO *claim;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DAZClaimTableViewCell


#pragma mark - Instance Accessors

+ (CGFloat)height
{
    return 80;
}


#pragma mark - UIKit

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple Avatar"]];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
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


#pragma mark - UIView

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

#pragma mark - Custom Mutators

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
        self.avatarImageView.image = [UIImage imageNamed:@"Purple Avatar"];
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 24;
        self.avatarImageView.layer.masksToBounds = YES;
    }
    
    NSString *authorString = claim.authorName;
    NSString *partyString = claim.partyTitle;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:claim.date];
    
    NSString *message;
    if (income)
    {
        message = [NSString stringWithFormat:@"%@ отправил вам запрос на посещение вечеринки %@ %@",
                       authorString, partyString, dateString];
    }
    else
    {
        DAZClaimStatus status = [ClaimMO statusFromString:claim.status];
        switch (status)
        {
            case DAZClaimStatusConfirmed:
                message = [NSString stringWithFormat:@"%@ подтвердил вашу заявку на посещение вечеринки %@ %@",
                            authorString, partyString, dateString];
                break;
            case DAZClaimStatusRequested:
                message = [NSString stringWithFormat:@"Вы запросили у %@ место проведения вечеринки %@ %@",
                            authorString, partyString, dateString];
                break;
            case DAZClaimStatusClosed:
                message = [NSString stringWithFormat:@"%@ отклонил вашу заявку на посещение вечеринки %@ %@",
                            authorString, partyString, dateString];
                break;
        }
    }
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSDictionary <NSAttributedStringKey, id> *purpleTextAttributes =
    @{ NSForegroundColorAttributeName: [UIColor cl_darkPurpleColor],
       NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightBold]
    };
    
    NSDictionary <NSAttributedStringKey, id> *grayTextAttributes =
    @{ NSForegroundColorAttributeName: [UIColor grayColor],
       NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]
       };
    
    if (authorString)
    {
        NSRange authorRange = [message rangeOfString:authorString];
        [attributedMessage addAttributes:purpleTextAttributes range:authorRange];
    }
    
    if (partyString)
    {
        NSRange partyRange = [message rangeOfString:partyString];
        [attributedMessage addAttributes:purpleTextAttributes range:partyRange];
    }
    
    if (dateString)
    {
        NSRange dateRange = [message rangeOfString:dateString];
        [attributedMessage addAttributes:grayTextAttributes range:dateRange];
    }
    
    self.messageLabel.attributedText = attributedMessage;
}

@end
