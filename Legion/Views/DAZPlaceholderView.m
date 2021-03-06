//
//  DAZPlaceholderView.m
//  Legion
//
//  Created by Дмитрий Жаров on 14.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZPlaceholderView.h"


@interface DAZPlaceholderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DAZPlaceholderView


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor darkGrayColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [self init];
    if (self) {
        _titleLabel.text = title;
        _messageLabel.text = message;
    }
    return self;
}


#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (void)setMessage:(NSString *)message
{
    _messageLabel.text = message;
}

- (NSString *)message
{
    return _messageLabel.text;
}

#pragma mark - UIView

- (void)updateConstraints
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(32);
        make.right.equalTo(self).with.offset(-32);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).with.offset(32);
        make.left.equalTo(self).with.offset(32);
        make.right.equalTo(self).with.offset(-32);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}

@end
