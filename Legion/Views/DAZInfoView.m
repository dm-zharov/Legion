//
//  DAZInfoView.m
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZInfoView.h"

@interface DAZInfoView ()

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation DAZInfoView


#pragma mark - Lifecycle

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 120, 60)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.text = @"Поле для информации";
        _infoLabel.textColor = [UIColor darkGrayColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _infoLabel.numberOfLines = 0;
        [self addSubview:_infoLabel];
    }
    return self;
}

- (void)updateConstraints
{
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_lessThanOrEqualTo(@300);
    }];
    
    [super updateConstraints];
}

@end
