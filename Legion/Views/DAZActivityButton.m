//
//  DAZActivityButton.m
//  Legion
//
//  Created by Дмитрий Жаров on 14.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <Masonry.h>
#import "DAZActivityButton.h"


@interface DAZActivityButton ()

@property (nonatomic, strong) NSString *textString;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation DAZActivityButton


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.color = [UIColor whiteColor];
        [self addSubview:_activityIndicatorView];
    }
    return self;
}


#pragma mark - Public

- (void)startSpinning
{
    self.textString = [self titleForState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateNormal];
    [self.activityIndicatorView startAnimating];
}

- (void)stopSpinning
{
    [self.activityIndicatorView stopAnimating];
    [self setTitle:self.textString forState:UIControlStateNormal];
}


#pragma mark - UIView

- (void)updateConstraints
{
    [self.activityIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

@end
