//
//  DAZLogoutTableViewCell.m
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZLogoutTableViewCell.h"

@interface DAZLogoutTableViewCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *logoutLabel;

@end

@implementation DAZLogoutTableViewCell

+ (CGFloat)height
{
    return 40;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cardView = [[UIView alloc] init];
        _cardView.layer.cornerRadius = 10;
        _cardView.layer.masksToBounds = YES;
        _cardView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cardView];
        
        _logoutLabel = [[UILabel alloc] init];
        _logoutLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _logoutLabel.textColor = [UIColor redColor];
        _logoutLabel.textAlignment = NSTextAlignmentCenter;
        _logoutLabel.text = @"Выйти";
        [_cardView addSubview:_logoutLabel];
        
        _cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        _cardView.layer.shadowOpacity = 0.25;
        _cardView.layer.shadowOffset = CGSizeMake(-2, -2);
        _cardView.layer.shadowRadius = 2.0;
        
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
    
    [self.logoutLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cardView);
        make.centerY.equalTo(self.cardView);
        make.edges.equalTo(self.cardView);
    }];
    
    [super updateConstraints];
}

@end
