//
//  DAZProfileViewController+Debug.h
//  Legion
//
//  Created by Дмитрий Жаров on 27.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#ifdef DEBUG


#import "DAZProfileViewController.h"


@interface DAZProfileViewController (Debug)

@property (nonatomic, readonly) UIImageView *avatarImageView;
@property (nonatomic, readonly) UIView *footerView;
@property (nonatomic, readonly) UIButton *signOutButton;

@end


#endif
