//
//  DAZProfileTableViewCell.h
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAZProfileTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *partiesLabel;
@property (nonatomic, strong) UILabel *membersLabel;

+ (CGFloat)height;

@end
