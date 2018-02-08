//
//  DAZProfileTableViewCell.m
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZProfileTableViewCell.h"

@interface DAZProfileTableViewCell ()

@property (nonatomic, strong) UIView *cardView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *partiesTitle;
@property (nonatomic, strong) UILabel *membersTitle;

@end

@implementation DAZProfileTableViewCell

+ (CGFloat)height
{
    return 112;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cardView = [[UIView alloc] init];
        _cardView.layer.cornerRadius = 10;
        _cardView.layer.masksToBounds = YES;
        _cardView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cardView];
        
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height /2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.clipsToBounds = YES;
        [_cardView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightBold];
        _nameLabel.textColor = [UIColor blackColor];
        [_cardView addSubview:_nameLabel];
        
        _partiesLabel = [[UILabel alloc] init];
        _partiesLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _partiesLabel.textColor = [UIColor blackColor];
        [_cardView addSubview:_partiesLabel];
        
        _partiesTitle = [[UILabel alloc] init];
        _partiesTitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _partiesTitle.textColor = [UIColor blackColor];
        _partiesTitle.text = @"предложений";
        [_cardView addSubview:_partiesTitle];
        
        _membersLabel = [[UILabel alloc] init];
        _membersLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _membersLabel.textColor = [UIColor blackColor];
        [_cardView addSubview:_membersLabel];
        
        _membersTitle = [[UILabel alloc] init];
        _membersTitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _membersTitle.textColor = [UIColor blackColor];
        _membersTitle.text = @"участий";
        [_cardView addSubview:_membersTitle];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateConstraints
{
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(16);
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).with.offset(16);
        make.left.equalTo(self.cardView).with.offset(16);
        make.bottom.equalTo(self.cardView).with.offset(-16);
        make.size.equalTo(@80);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView).with.offset(4);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(16);
    }];
    
    [self.partiesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(16);
        make.bottom.equalTo(self.avatarImageView.mas_bottom).with.offset(-4);
    }];
    
    [self.partiesTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partiesLabel.mas_right).with.offset(4);
        make.lastBaseline.equalTo(self.partiesLabel);
    }];
    
    [self.membersLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partiesTitle.mas_right).with.offset(32);
        make.lastBaseline.equalTo(self.partiesTitle);
    }];
    
    [self.membersTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.membersLabel.mas_right).with.offset(4);
        make.lastBaseline.equalTo(self.membersLabel);
    }];
    
    [super updateConstraints];
}

@end
